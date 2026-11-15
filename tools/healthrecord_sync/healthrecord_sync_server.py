#!/usr/bin/env python3
"""Private LAN/Tailscale-only HealthRecord snapshot relay (stdlib only).

Run as localhost-bound HTTP server; use Tailscale Serve for HTTPS on iPhone.
This does NOT do conflict resolution; clients use optimistic revision checks.
"""
import argparse
import hmac
import json
import mimetypes
import os
from pathlib import Path
import secrets
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import unquote, urlsplit

DATA_DIR = Path.home() / '.healthrecord_sync'
DATA_FILE = DATA_DIR / 'state.json'
SECRET_FILE = DATA_DIR / 'secret.txt'
MAX_BYTES = 120 * 1024 * 1024
LOCK = threading.Lock()


def create_secret():
    DATA_DIR.mkdir(mode=0o700, parents=True, exist_ok=True)
    os.chmod(DATA_DIR, 0o700)
    if not SECRET_FILE.exists():
        fd = os.open(SECRET_FILE, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        with os.fdopen(fd, 'w', encoding='ascii') as f:
            f.write(secrets.token_urlsafe(40) + '\n')
    os.chmod(SECRET_FILE, 0o600)
    return SECRET_FILE.read_text(encoding='ascii').strip()


def load_state():
    if not DATA_FILE.exists():
        return {'revision': 0, 'snapshot': None}
    with DATA_FILE.open('r', encoding='utf-8') as f:
        data = json.load(f)
    if not isinstance(data.get('revision'), int) or data['revision'] < 0:
        raise ValueError('Invalid server state revision')
    return data


def atomic_save(value):
    # fsync + atomic rename reduce the risk of losing an acknowledged upload.
    temp = DATA_DIR / f'.state.{secrets.token_hex(6)}.tmp'
    fd = os.open(temp, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    try:
        with os.fdopen(fd, 'w', encoding='utf-8') as f:
            json.dump(value, f, ensure_ascii=False, separators=(',', ':'))
            f.flush()
            os.fsync(f.fileno())
        os.replace(temp, DATA_FILE)
        os.chmod(DATA_FILE, 0o600)
    finally:
        temp.unlink(missing_ok=True)


class Handler(BaseHTTPRequestHandler):
    server_version = 'HealthRecordSync/1'

    def _origin(self):
        origin = self.headers.get('Origin', '')
        return origin if origin in {'http://localhost:8080', 'http://127.0.0.1:8080'} else None

    def _headers(self, code, ctype='application/json; charset=utf-8', size=None):
        self.send_response(code)
        self.send_header('Content-Type', ctype)
        self.send_header('X-Content-Type-Options', 'nosniff')
        self.send_header('Cache-Control', 'no-store')
        self.send_header('Referrer-Policy', 'no-referrer')
        self.send_header('X-Frame-Options', 'DENY')
        self.send_header('Content-Security-Policy', "frame-ancestors 'none'")
        origin = self._origin()
        if origin:
            self.send_header('Access-Control-Allow-Origin', origin)
            self.send_header('Vary', 'Origin')
            self.send_header('Access-Control-Allow-Headers', 'X-HealthRecord-Token,Content-Type')
            self.send_header('Access-Control-Allow-Methods', 'GET,POST,OPTIONS')
        if size is not None:
            self.send_header('Content-Length', str(size))
        self.end_headers()

    def _json(self, code, body):
        data = json.dumps(body, ensure_ascii=False, separators=(',', ':')).encode('utf-8')
        self._headers(code, size=len(data))
        self.wfile.write(data)

    def _authenticated(self):
        provided = self.headers.get('X-HealthRecord-Token', '')
        return hmac.compare_digest(provided, self.server.sync_token)

    def do_OPTIONS(self):
        if urlsplit(self.path).path != '/api/snapshot' or not self._origin():
            return self._json(403, {'error': 'origin not allowed'})
        self._headers(204, size=0)

    def do_GET(self):
        path = urlsplit(self.path).path
        if path == '/api/snapshot':
            if not self._authenticated():
                return self._json(401, {'error': 'unauthorized'})
            with LOCK:
                result = load_state()
            return self._json(200, result)
        if path == '/api/health':
            return self._json(200, {'status': 'ok'})
        return self._static(path)

    def do_POST(self):
        if urlsplit(self.path).path != '/api/snapshot':
            return self._json(404, {'error': 'not found'})
        if not self._authenticated():
            return self._json(401, {'error': 'unauthorized'})
        try:
            length = int(self.headers.get('Content-Length', '-1'))
        except ValueError:
            length = -1
        if length < 1 or length > MAX_BYTES:
            return self._json(413, {'error': 'invalid size'})
        try:
            payload = json.loads(self.rfile.read(length))
            snapshot = payload.get('snapshot')
            base_rev = payload.get('baseRevision')
            if (not isinstance(base_rev, int) or isinstance(base_rev, bool) or
                not isinstance(snapshot, dict) or
                snapshot.get('format') != 'health_record_local_backup' or
                snapshot.get('schemaVersion') != 11 or
                not isinstance(snapshot.get('tables'), dict)):
                return self._json(400, {'error': 'invalid backup payload'})
        except (ValueError, AttributeError, UnicodeError):
            return self._json(400, {'error': 'invalid json'})
        with LOCK:
            current = load_state()
            if base_rev != current['revision']:
                return self._json(409, {'error': 'conflict', 'revision': current['revision']})
            next_rev = current['revision'] + 1
            atomic_save({'revision': next_rev, 'snapshot': snapshot})
        return self._json(200, {'revision': next_rev})

    def _static(self, url_path):
        # Serve built Flutter Web assets; never serve config or parent paths.
        if not self.server.web_root.is_dir():
            return self._json(404, {'error': 'run flutter build web --release first'})
        relative = unquote(url_path).lstrip('/')
        if not relative:
            relative = 'index.html'
        root = self.server.web_root.resolve()
        file = (root / relative).resolve()
        if not file.is_relative_to(root) or not file.is_file():
            return self._json(404, {'error': 'not found'})
        if any(x.startswith('.') for x in file.relative_to(root).parts):
            return self._json(404, {'error': 'not found'})
        ctype, _ = mimetypes.guess_type(str(file))
        ctype = ctype or 'application/octet-stream'
        # Wasm and JS MIME types are important for Flutter's database worker.
        if file.suffix == '.wasm':
            ctype = 'application/wasm'
        if file.suffix == '.js':
            ctype = 'text/javascript; charset=utf-8'
        content = file.read_bytes()
        self._headers(200, ctype, len(content))
        self.wfile.write(content)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', type=int, default=8765)
    parser.add_argument('--web-root', type=Path, default=Path('build/web'))
    args = parser.parse_args()
    token = create_secret()
    httpd = ThreadingHTTPServer(('127.0.0.1', args.port), Handler)
    httpd.sync_token = token
    httpd.web_root = args.web_root.resolve()
    print('Sync server listening on 127.0.0.1:' + str(args.port))
    print('Private data directory: ' + str(DATA_DIR))
    print('Read pairing secret locally: cat ~/.healthrecord_sync/secret.txt')
    print('Use Tailscale Serve, NEVER Tailscale Funnel, for iPhone HTTPS access.')
    httpd.serve_forever()


if __name__ == '__main__':
    main()
