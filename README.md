# HealthRecord

HealthRecord is a local-first personal health management app built with Flutter. It brings together laboratory results, medical visits, medication plans, inventory, and symptom records to help you track your health over time.

The current implementation targets Flutter Web and provides a Simplified Chinese interface.

## Features

| Module | Capabilities |
| --- | --- |
| Laboratory results | Enter results manually or import CSV files with preview, validation, hospital selection, and duplicate detection. |
| Trend charts | View manually entered and imported results together. Filter by hospital and display different units separately while preserving original values and reference ranges. |
| Hospital management | Manage hospital information, assign results to hospitals in batches, and merge duplicate hospital entries. |
| Medical visits | Record visits, link existing laboratory results, and store or download PDF attachments. |
| Medication management | View today's medication plan and maintain historical and future medication schedules. |
| Medication inventory | Track stock by strength and batch, record inventory changes, and estimate remaining supply using a confirmed daily consumption rate. |
| Symptom diary | Record symptoms, dates, severity, notes, and photos. |
| Backup and restore | Export a complete JSON backup and preview a backup before restoring it to the current browser. |

## Getting Started

### Requirements

- Flutter SDK
- Git
- Chrome

The repository's current `pubspec.lock` specifies Flutter 3.47.0 or later and Dart 3.13.5 or later within the Dart 3.x series.

### Run Locally

```bash
git clone https://github.com/Cheng-JY/health_record.git
cd health_record
flutter pub get
flutter run -d chrome --web-port 8080
```

Use a consistent browser address and port during development to access the same browser-local data.

### Build for Web

```bash
flutter build web
```

The generated files are available in `build/web/`.

The [web/](web/) directory includes the SQLite WebAssembly binary and the Drift Worker used for browser-based storage.

## Importing Laboratory Results

Open the CSV import screen from the laboratory results section. Select a UTF-8 encoded, comma-separated file, review the preview, choose the associated hospital, and confirm the import.

Include every column shown below. Each row represents one laboratory result. The sample date, indicator name, and result value must be filled in.

The following row contains fictional demonstration data.

```csv
report_id,sample_date,report_date,indicator_code,indicator_name_cn,value,unit,reference_range,category
DEMO-001,2026-01-15,2026-01-15,WBC,白细胞计数,6.2,10^9/L,4.0-10.0,血常规
```

Keep the column names exactly as shown, including `indicator_name_cn`. Use a period as the decimal separator and an ISO-style date such as `2026-01-15`.

## Data Storage and Backups

HealthRecord stores records locally in the current browser's database by default. Export a JSON backup before clearing site data or moving to another browser.

Backups include laboratory results, hospitals, visits, medication history, inventory, symptom records, photos, and visit PDF attachments.

Restoring a backup replaces the records in the current browser. Review the backup preview and export your existing data before confirming a restore.

JSON backups and snapshots saved by the synchronization service are stored in plaintext. Keep these files in a protected location.

## Experimental Synchronization

The repository includes an optional [Python synchronization service](tools/healthrecord_sync/healthrecord_sync_server.py) for a Mac-hosted setup accessible from an iPhone browser through a private Tailscale Serve HTTPS address.

Synchronization transfers complete database snapshots. Automatic synchronization pauses when both devices have independent changes.

The Mac must remain running with the synchronization service active. Export backups from both devices before pairing them.

## Technology Stack

- **Flutter and Dart** for the application interface
- **Riverpod** for application state management
- **Drift and SQLite** for local data persistence
- **WebAssembly** for SQLite support in the browser
- **fl_chart** for laboratory trend visualization
- **Python standard library** for the optional synchronization service
