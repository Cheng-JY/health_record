import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'core/database/app_database.dart';
import 'features/labs/lab_repository.dart';
import 'features/labs/lab_pages.dart';
import 'features/labs/unified_lab_page.dart';
import 'features/hospitals/hospitals_page.dart';
import 'features/backup/backup_page.dart';
import 'features/settings/settings_page.dart';
import 'features/settings/plot_settings.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
final labRepositoryProvider = Provider<LabRepository>(
  (ref) => LabRepository(ref.watch(databaseProvider)),
);
final initProvider = FutureProvider<void>(
  (ref) => ref.watch(labRepositoryProvider).seedCatalog(),
);
final testsProvider = StreamProvider<List<LabTest>>(
  (ref) => ref.watch(labRepositoryProvider).tests(),
);
final categoriesProvider = StreamProvider<List<LabCategory>>(
  (ref) => ref.watch(labRepositoryProvider).categories(),
);
final resultsProvider = StreamProvider<List<LabResult>>(
  (ref) => ref.watch(labRepositoryProvider).results(),
);
final testResultsProvider = StreamProvider.family<List<LabResult>, String>(
  (ref, id) => ref.watch(labRepositoryProvider).byTest(id),
);

final appNavigatorKey = GlobalKey<NavigatorState>();
final selectedMainTab = ValueNotifier<int>(0);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await plotSettings.load();
  runApp(const ProviderScope(child: HealthRecordApp()));
}

class HealthRecordApp extends StatelessWidget {
  const HealthRecordApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'HealthRecord',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      useMaterial3: true,
    ),
    // Keep the global navigation shell inside MaterialApp's own Navigator.
    // Nested Navigator owns detail routes, so the bottom menu stays visible.
    home: _MainNavigationShell(
      child: Navigator(
        key: appNavigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomeScreen(),
        ),
      ),
    ),
  );
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int index = selectedMainTab.value;

  @override
  void initState() {
    super.initState();
    selectedMainTab.addListener(_syncMainTab);
  }

  void _syncMainTab() {
    if (mounted) setState(() => index = selectedMainTab.value);
  }

  @override
  void dispose() {
    selectedMainTab.removeListener(_syncMainTab);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final init = ref.watch(initProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthRecord'),
        actions: [
          IconButton(
            tooltip: '本地备份与恢复',
            icon: const Icon(Icons.backup_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const BackupPage())),
          ),
        ],
      ),
      body: init.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('初始化数据库失败：$e')),
        data: (_) => IndexedStack(
          index: index,
          children: const [
            DashboardPage(),
            UnifiedLabPage(),
            HospitalsPage(),
            SettingsPage(),
          ],
        ),
      ),
      floatingActionButton: index == 1 && init.hasValue
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const LabFormPage())),
              label: const Text('录入结果'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}

/// This wraps the MaterialApp Navigator, keeping the main menu visible even
/// when secondary pages are opened with Navigator.push.
class _MainNavigationShell extends StatelessWidget {
  const _MainNavigationShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedMainTab,
      builder: (context, selected, _) => Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: (index) {
            selectedMainTab.value = index;
            appNavigatorKey.currentState?.popUntil((route) => route.isFirst);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              label: '首页',
            ),
            NavigationDestination(
              icon: Icon(Icons.biotech_outlined),
              label: '检查结果',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_hospital_outlined),
              label: '医院',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }
}
