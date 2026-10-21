import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/app_database.dart';
import 'features/labs/lab_repository.dart';
import 'features/labs/lab_pages.dart';
import 'features/labs/unified_lab_page.dart';
import 'features/csv_import/csv_import_page.dart';

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

void main() => runApp(const ProviderScope(child: HealthRecordApp()));

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
    home: const HomeScreen(),
  );
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final init = ref.watch(initProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('HealthRecord')),
      body: init.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('初始化数据库失败：$e')),
        data: (_) => IndexedStack(
          index: index,
          children: const [
            DashboardPage(),
            UnifiedLabPage(),
            TrendsPage(),
            CsvImportPage(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.biotech_outlined),
            label: '检查结果',
          ),
          NavigationDestination(icon: Icon(Icons.show_chart), label: '趋势'),
          NavigationDestination(icon: Icon(Icons.upload_file), label: 'CSV 导入'),
        ],
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
