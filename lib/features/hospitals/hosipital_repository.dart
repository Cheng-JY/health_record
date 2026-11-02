import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';

class HospitalRepository {
  final AppDatabase db;

  HospitalRepository(this.db);

  // 实时获取已保存医院
  Stream<List<Hospital>> watchHospitals() {
    return (db.select(
      db.hospitals,
    )..orderBy([(h) => OrderingTerm.asc(h.name)])).watch();
  }

  // 创建医院，返回医院 UUID
  Future<String> createHospital({required String name, String? city}) async {
    final cleanName = name.trim();
    final cleanCity = city?.trim();

    if (cleanName.isEmpty) {
      throw ArgumentError('医院名称不能为空');
    }

    // 避免重复创建名称和城市相同的医院
    final existing = await db.select(db.hospitals).get();

    for (final hospital in existing) {
      if (hospital.name.trim().toLowerCase() == cleanName.toLowerCase() &&
          (hospital.city ?? '').trim().toLowerCase() ==
              (cleanCity ?? '').toLowerCase()) {
        return hospital.id;
      }
    }

    final id = const Uuid().v4();

    await db
        .into(db.hospitals)
        .insert(
          HospitalsCompanion.insert(
            id: id,
            name: cleanName,
            city: Value(
              cleanCity == null || cleanCity.isEmpty ? null : cleanCity,
            ),
            createdAt: DateTime.now(),
          ),
        );

    return id;
  }
}
