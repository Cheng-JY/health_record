// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LabCategoriesTable extends LabCategories
    with TableInfo<$LabCategoriesTable, LabCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameZhMeta = const VerificationMeta('nameZh');
  @override
  late final GeneratedColumn<String> nameZh = GeneratedColumn<String>(
    'name_zh',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, nameZh, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lab_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_zh')) {
      context.handle(
        _nameZhMeta,
        nameZh.isAcceptableOrUnknown(data['name_zh']!, _nameZhMeta),
      );
    } else if (isInserting) {
      context.missing(_nameZhMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameZh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_zh'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $LabCategoriesTable createAlias(String alias) {
    return $LabCategoriesTable(attachedDatabase, alias);
  }
}

class LabCategory extends DataClass implements Insertable<LabCategory> {
  final String id;
  final String code;
  final String nameZh;
  final int sortOrder;
  const LabCategory({
    required this.id,
    required this.code,
    required this.nameZh,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name_zh'] = Variable<String>(nameZh);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  LabCategoriesCompanion toCompanion(bool nullToAbsent) {
    return LabCategoriesCompanion(
      id: Value(id),
      code: Value(code),
      nameZh: Value(nameZh),
      sortOrder: Value(sortOrder),
    );
  }

  factory LabCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabCategory(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameZh: serializer.fromJson<String>(json['nameZh']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'nameZh': serializer.toJson<String>(nameZh),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  LabCategory copyWith({
    String? id,
    String? code,
    String? nameZh,
    int? sortOrder,
  }) => LabCategory(
    id: id ?? this.id,
    code: code ?? this.code,
    nameZh: nameZh ?? this.nameZh,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  LabCategory copyWithCompanion(LabCategoriesCompanion data) {
    return LabCategory(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameZh: data.nameZh.present ? data.nameZh.value : this.nameZh,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabCategory(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameZh: $nameZh, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, nameZh, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabCategory &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameZh == this.nameZh &&
          other.sortOrder == this.sortOrder);
}

class LabCategoriesCompanion extends UpdateCompanion<LabCategory> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> nameZh;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const LabCategoriesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameZh = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabCategoriesCompanion.insert({
    required String id,
    required String code,
    required String nameZh,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       nameZh = Value(nameZh);
  static Insertable<LabCategory> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? nameZh,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameZh != null) 'name_zh': nameZh,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? nameZh,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return LabCategoriesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameZh: nameZh ?? this.nameZh,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameZh.present) {
      map['name_zh'] = Variable<String>(nameZh.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameZh: $nameZh, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LabTestsTable extends LabTests with TableInfo<$LabTestsTable, LabTest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabTestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lab_categories (id)',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameZhMeta = const VerificationMeta('nameZh');
  @override
  late final GeneratedColumn<String> nameZh = GeneratedColumn<String>(
    'name_zh',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameDeMeta = const VerificationMeta('nameDe');
  @override
  late final GeneratedColumn<String> nameDe = GeneratedColumn<String>(
    'name_de',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canonicalUnitMeta = const VerificationMeta(
    'canonicalUnit',
  );
  @override
  late final GeneratedColumn<String> canonicalUnit = GeneratedColumn<String>(
    'canonical_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    code,
    nameZh,
    nameDe,
    canonicalUnit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lab_tests';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabTest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_zh')) {
      context.handle(
        _nameZhMeta,
        nameZh.isAcceptableOrUnknown(data['name_zh']!, _nameZhMeta),
      );
    } else if (isInserting) {
      context.missing(_nameZhMeta);
    }
    if (data.containsKey('name_de')) {
      context.handle(
        _nameDeMeta,
        nameDe.isAcceptableOrUnknown(data['name_de']!, _nameDeMeta),
      );
    }
    if (data.containsKey('canonical_unit')) {
      context.handle(
        _canonicalUnitMeta,
        canonicalUnit.isAcceptableOrUnknown(
          data['canonical_unit']!,
          _canonicalUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalUnitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabTest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabTest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameZh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_zh'],
      )!,
      nameDe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_de'],
      ),
      canonicalUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_unit'],
      )!,
    );
  }

  @override
  $LabTestsTable createAlias(String alias) {
    return $LabTestsTable(attachedDatabase, alias);
  }
}

class LabTest extends DataClass implements Insertable<LabTest> {
  final String id;
  final String categoryId;
  final String code;
  final String nameZh;
  final String? nameDe;
  final String canonicalUnit;
  const LabTest({
    required this.id,
    required this.categoryId,
    required this.code,
    required this.nameZh,
    this.nameDe,
    required this.canonicalUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['code'] = Variable<String>(code);
    map['name_zh'] = Variable<String>(nameZh);
    if (!nullToAbsent || nameDe != null) {
      map['name_de'] = Variable<String>(nameDe);
    }
    map['canonical_unit'] = Variable<String>(canonicalUnit);
    return map;
  }

  LabTestsCompanion toCompanion(bool nullToAbsent) {
    return LabTestsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      code: Value(code),
      nameZh: Value(nameZh),
      nameDe: nameDe == null && nullToAbsent
          ? const Value.absent()
          : Value(nameDe),
      canonicalUnit: Value(canonicalUnit),
    );
  }

  factory LabTest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabTest(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      code: serializer.fromJson<String>(json['code']),
      nameZh: serializer.fromJson<String>(json['nameZh']),
      nameDe: serializer.fromJson<String?>(json['nameDe']),
      canonicalUnit: serializer.fromJson<String>(json['canonicalUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'code': serializer.toJson<String>(code),
      'nameZh': serializer.toJson<String>(nameZh),
      'nameDe': serializer.toJson<String?>(nameDe),
      'canonicalUnit': serializer.toJson<String>(canonicalUnit),
    };
  }

  LabTest copyWith({
    String? id,
    String? categoryId,
    String? code,
    String? nameZh,
    Value<String?> nameDe = const Value.absent(),
    String? canonicalUnit,
  }) => LabTest(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    code: code ?? this.code,
    nameZh: nameZh ?? this.nameZh,
    nameDe: nameDe.present ? nameDe.value : this.nameDe,
    canonicalUnit: canonicalUnit ?? this.canonicalUnit,
  );
  LabTest copyWithCompanion(LabTestsCompanion data) {
    return LabTest(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      code: data.code.present ? data.code.value : this.code,
      nameZh: data.nameZh.present ? data.nameZh.value : this.nameZh,
      nameDe: data.nameDe.present ? data.nameDe.value : this.nameDe,
      canonicalUnit: data.canonicalUnit.present
          ? data.canonicalUnit.value
          : this.canonicalUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabTest(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('code: $code, ')
          ..write('nameZh: $nameZh, ')
          ..write('nameDe: $nameDe, ')
          ..write('canonicalUnit: $canonicalUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryId, code, nameZh, nameDe, canonicalUnit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabTest &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.code == this.code &&
          other.nameZh == this.nameZh &&
          other.nameDe == this.nameDe &&
          other.canonicalUnit == this.canonicalUnit);
}

class LabTestsCompanion extends UpdateCompanion<LabTest> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String> code;
  final Value<String> nameZh;
  final Value<String?> nameDe;
  final Value<String> canonicalUnit;
  final Value<int> rowid;
  const LabTestsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.code = const Value.absent(),
    this.nameZh = const Value.absent(),
    this.nameDe = const Value.absent(),
    this.canonicalUnit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabTestsCompanion.insert({
    required String id,
    required String categoryId,
    required String code,
    required String nameZh,
    this.nameDe = const Value.absent(),
    required String canonicalUnit,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryId = Value(categoryId),
       code = Value(code),
       nameZh = Value(nameZh),
       canonicalUnit = Value(canonicalUnit);
  static Insertable<LabTest> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? code,
    Expression<String>? nameZh,
    Expression<String>? nameDe,
    Expression<String>? canonicalUnit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (code != null) 'code': code,
      if (nameZh != null) 'name_zh': nameZh,
      if (nameDe != null) 'name_de': nameDe,
      if (canonicalUnit != null) 'canonical_unit': canonicalUnit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabTestsCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryId,
    Value<String>? code,
    Value<String>? nameZh,
    Value<String?>? nameDe,
    Value<String>? canonicalUnit,
    Value<int>? rowid,
  }) {
    return LabTestsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      code: code ?? this.code,
      nameZh: nameZh ?? this.nameZh,
      nameDe: nameDe ?? this.nameDe,
      canonicalUnit: canonicalUnit ?? this.canonicalUnit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameZh.present) {
      map['name_zh'] = Variable<String>(nameZh.value);
    }
    if (nameDe.present) {
      map['name_de'] = Variable<String>(nameDe.value);
    }
    if (canonicalUnit.present) {
      map['canonical_unit'] = Variable<String>(canonicalUnit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabTestsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('code: $code, ')
          ..write('nameZh: $nameZh, ')
          ..write('nameDe: $nameDe, ')
          ..write('canonicalUnit: $canonicalUnit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LabResultsTable extends LabResults
    with TableInfo<$LabResultsTable, LabResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _testIdMeta = const VerificationMeta('testId');
  @override
  late final GeneratedColumn<String> testId = GeneratedColumn<String>(
    'test_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lab_tests (id)',
    ),
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueNumericMeta = const VerificationMeta(
    'valueNumeric',
  );
  @override
  late final GeneratedColumn<double> valueNumeric = GeneratedColumn<double>(
    'value_numeric',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceLowMeta = const VerificationMeta(
    'referenceLow',
  );
  @override
  late final GeneratedColumn<double> referenceLow = GeneratedColumn<double>(
    'reference_low',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceHighMeta = const VerificationMeta(
    'referenceHigh',
  );
  @override
  late final GeneratedColumn<double> referenceHigh = GeneratedColumn<double>(
    'reference_high',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    testId,
    measuredAt,
    valueNumeric,
    unit,
    referenceLow,
    referenceHigh,
    note,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lab_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('test_id')) {
      context.handle(
        _testIdMeta,
        testId.isAcceptableOrUnknown(data['test_id']!, _testIdMeta),
      );
    } else if (isInserting) {
      context.missing(_testIdMeta);
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('value_numeric')) {
      context.handle(
        _valueNumericMeta,
        valueNumeric.isAcceptableOrUnknown(
          data['value_numeric']!,
          _valueNumericMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valueNumericMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('reference_low')) {
      context.handle(
        _referenceLowMeta,
        referenceLow.isAcceptableOrUnknown(
          data['reference_low']!,
          _referenceLowMeta,
        ),
      );
    }
    if (data.containsKey('reference_high')) {
      context.handle(
        _referenceHighMeta,
        referenceHigh.isAcceptableOrUnknown(
          data['reference_high']!,
          _referenceHighMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      testId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_id'],
      )!,
      measuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}measured_at'],
      )!,
      valueNumeric: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value_numeric'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      referenceLow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reference_low'],
      ),
      referenceHigh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reference_high'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LabResultsTable createAlias(String alias) {
    return $LabResultsTable(attachedDatabase, alias);
  }
}

class LabResult extends DataClass implements Insertable<LabResult> {
  final String id;
  final String testId;
  final DateTime measuredAt;
  final double valueNumeric;
  final String unit;
  final double? referenceLow;
  final double? referenceHigh;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const LabResult({
    required this.id,
    required this.testId,
    required this.measuredAt,
    required this.valueNumeric,
    required this.unit,
    this.referenceLow,
    this.referenceHigh,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['test_id'] = Variable<String>(testId);
    map['measured_at'] = Variable<DateTime>(measuredAt);
    map['value_numeric'] = Variable<double>(valueNumeric);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || referenceLow != null) {
      map['reference_low'] = Variable<double>(referenceLow);
    }
    if (!nullToAbsent || referenceHigh != null) {
      map['reference_high'] = Variable<double>(referenceHigh);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LabResultsCompanion toCompanion(bool nullToAbsent) {
    return LabResultsCompanion(
      id: Value(id),
      testId: Value(testId),
      measuredAt: Value(measuredAt),
      valueNumeric: Value(valueNumeric),
      unit: Value(unit),
      referenceLow: referenceLow == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceLow),
      referenceHigh: referenceHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceHigh),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LabResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabResult(
      id: serializer.fromJson<String>(json['id']),
      testId: serializer.fromJson<String>(json['testId']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      valueNumeric: serializer.fromJson<double>(json['valueNumeric']),
      unit: serializer.fromJson<String>(json['unit']),
      referenceLow: serializer.fromJson<double?>(json['referenceLow']),
      referenceHigh: serializer.fromJson<double?>(json['referenceHigh']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'testId': serializer.toJson<String>(testId),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'valueNumeric': serializer.toJson<double>(valueNumeric),
      'unit': serializer.toJson<String>(unit),
      'referenceLow': serializer.toJson<double?>(referenceLow),
      'referenceHigh': serializer.toJson<double?>(referenceHigh),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LabResult copyWith({
    String? id,
    String? testId,
    DateTime? measuredAt,
    double? valueNumeric,
    String? unit,
    Value<double?> referenceLow = const Value.absent(),
    Value<double?> referenceHigh = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LabResult(
    id: id ?? this.id,
    testId: testId ?? this.testId,
    measuredAt: measuredAt ?? this.measuredAt,
    valueNumeric: valueNumeric ?? this.valueNumeric,
    unit: unit ?? this.unit,
    referenceLow: referenceLow.present ? referenceLow.value : this.referenceLow,
    referenceHigh: referenceHigh.present
        ? referenceHigh.value
        : this.referenceHigh,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LabResult copyWithCompanion(LabResultsCompanion data) {
    return LabResult(
      id: data.id.present ? data.id.value : this.id,
      testId: data.testId.present ? data.testId.value : this.testId,
      measuredAt: data.measuredAt.present
          ? data.measuredAt.value
          : this.measuredAt,
      valueNumeric: data.valueNumeric.present
          ? data.valueNumeric.value
          : this.valueNumeric,
      unit: data.unit.present ? data.unit.value : this.unit,
      referenceLow: data.referenceLow.present
          ? data.referenceLow.value
          : this.referenceLow,
      referenceHigh: data.referenceHigh.present
          ? data.referenceHigh.value
          : this.referenceHigh,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabResult(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('valueNumeric: $valueNumeric, ')
          ..write('unit: $unit, ')
          ..write('referenceLow: $referenceLow, ')
          ..write('referenceHigh: $referenceHigh, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    testId,
    measuredAt,
    valueNumeric,
    unit,
    referenceLow,
    referenceHigh,
    note,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabResult &&
          other.id == this.id &&
          other.testId == this.testId &&
          other.measuredAt == this.measuredAt &&
          other.valueNumeric == this.valueNumeric &&
          other.unit == this.unit &&
          other.referenceLow == this.referenceLow &&
          other.referenceHigh == this.referenceHigh &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class LabResultsCompanion extends UpdateCompanion<LabResult> {
  final Value<String> id;
  final Value<String> testId;
  final Value<DateTime> measuredAt;
  final Value<double> valueNumeric;
  final Value<String> unit;
  final Value<double?> referenceLow;
  final Value<double?> referenceHigh;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LabResultsCompanion({
    this.id = const Value.absent(),
    this.testId = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.valueNumeric = const Value.absent(),
    this.unit = const Value.absent(),
    this.referenceLow = const Value.absent(),
    this.referenceHigh = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabResultsCompanion.insert({
    required String id,
    required String testId,
    required DateTime measuredAt,
    required double valueNumeric,
    required String unit,
    this.referenceLow = const Value.absent(),
    this.referenceHigh = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       testId = Value(testId),
       measuredAt = Value(measuredAt),
       valueNumeric = Value(valueNumeric),
       unit = Value(unit),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LabResult> custom({
    Expression<String>? id,
    Expression<String>? testId,
    Expression<DateTime>? measuredAt,
    Expression<double>? valueNumeric,
    Expression<String>? unit,
    Expression<double>? referenceLow,
    Expression<double>? referenceHigh,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (testId != null) 'test_id': testId,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (valueNumeric != null) 'value_numeric': valueNumeric,
      if (unit != null) 'unit': unit,
      if (referenceLow != null) 'reference_low': referenceLow,
      if (referenceHigh != null) 'reference_high': referenceHigh,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? testId,
    Value<DateTime>? measuredAt,
    Value<double>? valueNumeric,
    Value<String>? unit,
    Value<double?>? referenceLow,
    Value<double?>? referenceHigh,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LabResultsCompanion(
      id: id ?? this.id,
      testId: testId ?? this.testId,
      measuredAt: measuredAt ?? this.measuredAt,
      valueNumeric: valueNumeric ?? this.valueNumeric,
      unit: unit ?? this.unit,
      referenceLow: referenceLow ?? this.referenceLow,
      referenceHigh: referenceHigh ?? this.referenceHigh,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (testId.present) {
      map['test_id'] = Variable<String>(testId.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (valueNumeric.present) {
      map['value_numeric'] = Variable<double>(valueNumeric.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (referenceLow.present) {
      map['reference_low'] = Variable<double>(referenceLow.value);
    }
    if (referenceHigh.present) {
      map['reference_high'] = Variable<double>(referenceHigh.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabResultsCompanion(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('valueNumeric: $valueNumeric, ')
          ..write('unit: $unit, ')
          ..write('referenceLow: $referenceLow, ')
          ..write('referenceHigh: $referenceHigh, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HospitalsTable extends Hospitals
    with TableInfo<$HospitalsTable, Hospital> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HospitalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, city, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hospitals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Hospital> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hospital map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hospital(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HospitalsTable createAlias(String alias) {
    return $HospitalsTable(attachedDatabase, alias);
  }
}

class Hospital extends DataClass implements Insertable<Hospital> {
  final String id;
  final String name;
  final String? city;
  final DateTime createdAt;
  const Hospital({
    required this.id,
    required this.name,
    this.city,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HospitalsCompanion toCompanion(bool nullToAbsent) {
    return HospitalsCompanion(
      id: Value(id),
      name: Value(name),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      createdAt: Value(createdAt),
    );
  }

  factory Hospital.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hospital(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      city: serializer.fromJson<String?>(json['city']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'city': serializer.toJson<String?>(city),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Hospital copyWith({
    String? id,
    String? name,
    Value<String?> city = const Value.absent(),
    DateTime? createdAt,
  }) => Hospital(
    id: id ?? this.id,
    name: name ?? this.name,
    city: city.present ? city.value : this.city,
    createdAt: createdAt ?? this.createdAt,
  );
  Hospital copyWithCompanion(HospitalsCompanion data) {
    return Hospital(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      city: data.city.present ? data.city.value : this.city,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hospital(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('city: $city, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, city, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hospital &&
          other.id == this.id &&
          other.name == this.name &&
          other.city == this.city &&
          other.createdAt == this.createdAt);
}

class HospitalsCompanion extends UpdateCompanion<Hospital> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> city;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HospitalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.city = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HospitalsCompanion.insert({
    required String id,
    required String name,
    this.city = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Hospital> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? city,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (city != null) 'city': city,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HospitalsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? city,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return HospitalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HospitalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('city: $city, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportedLabResultsTable extends ImportedLabResults
    with TableInfo<$ImportedLabResultsTable, ImportedLabResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportedLabResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  @override
  late final GeneratedColumn<String> reportId = GeneratedColumn<String>(
    'report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sampleDateRawMeta = const VerificationMeta(
    'sampleDateRaw',
  );
  @override
  late final GeneratedColumn<String> sampleDateRaw = GeneratedColumn<String>(
    'sample_date_raw',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sampleDateMeta = const VerificationMeta(
    'sampleDate',
  );
  @override
  late final GeneratedColumn<DateTime> sampleDate = GeneratedColumn<DateTime>(
    'sample_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportDateRawMeta = const VerificationMeta(
    'reportDateRaw',
  );
  @override
  late final GeneratedColumn<String> reportDateRaw = GeneratedColumn<String>(
    'report_date_raw',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indicatorCodeMeta = const VerificationMeta(
    'indicatorCode',
  );
  @override
  late final GeneratedColumn<String> indicatorCode = GeneratedColumn<String>(
    'indicator_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indicatorNameCnMeta = const VerificationMeta(
    'indicatorNameCn',
  );
  @override
  late final GeneratedColumn<String> indicatorNameCn = GeneratedColumn<String>(
    'indicator_name_cn',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawValueMeta = const VerificationMeta(
    'rawValue',
  );
  @override
  late final GeneratedColumn<String> rawValue = GeneratedColumn<String>(
    'raw_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numericValueMeta = const VerificationMeta(
    'numericValue',
  );
  @override
  late final GeneratedColumn<double> numericValue = GeneratedColumn<double>(
    'numeric_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceRangeMeta = const VerificationMeta(
    'referenceRange',
  );
  @override
  late final GeneratedColumn<String> referenceRange = GeneratedColumn<String>(
    'reference_range',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalSnapshotMeta = const VerificationMeta(
    'originalSnapshot',
  );
  @override
  late final GeneratedColumn<String> originalSnapshot = GeneratedColumn<String>(
    'original_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editedAtMeta = const VerificationMeta(
    'editedAt',
  );
  @override
  late final GeneratedColumn<DateTime> editedAt = GeneratedColumn<DateTime>(
    'edited_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hospitalIdMeta = const VerificationMeta(
    'hospitalId',
  );
  @override
  late final GeneratedColumn<String> hospitalId = GeneratedColumn<String>(
    'hospital_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES hospitals (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fileName,
    reportId,
    sampleDateRaw,
    sampleDate,
    reportDateRaw,
    indicatorCode,
    indicatorNameCn,
    rawValue,
    numericValue,
    unit,
    referenceRange,
    category,
    importedAt,
    originalSnapshot,
    note,
    editedAt,
    deletedAt,
    hospitalId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'imported_lab_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportedLabResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reportIdMeta);
    }
    if (data.containsKey('sample_date_raw')) {
      context.handle(
        _sampleDateRawMeta,
        sampleDateRaw.isAcceptableOrUnknown(
          data['sample_date_raw']!,
          _sampleDateRawMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sampleDateRawMeta);
    }
    if (data.containsKey('sample_date')) {
      context.handle(
        _sampleDateMeta,
        sampleDate.isAcceptableOrUnknown(data['sample_date']!, _sampleDateMeta),
      );
    } else if (isInserting) {
      context.missing(_sampleDateMeta);
    }
    if (data.containsKey('report_date_raw')) {
      context.handle(
        _reportDateRawMeta,
        reportDateRaw.isAcceptableOrUnknown(
          data['report_date_raw']!,
          _reportDateRawMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reportDateRawMeta);
    }
    if (data.containsKey('indicator_code')) {
      context.handle(
        _indicatorCodeMeta,
        indicatorCode.isAcceptableOrUnknown(
          data['indicator_code']!,
          _indicatorCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_indicatorCodeMeta);
    }
    if (data.containsKey('indicator_name_cn')) {
      context.handle(
        _indicatorNameCnMeta,
        indicatorNameCn.isAcceptableOrUnknown(
          data['indicator_name_cn']!,
          _indicatorNameCnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_indicatorNameCnMeta);
    }
    if (data.containsKey('raw_value')) {
      context.handle(
        _rawValueMeta,
        rawValue.isAcceptableOrUnknown(data['raw_value']!, _rawValueMeta),
      );
    } else if (isInserting) {
      context.missing(_rawValueMeta);
    }
    if (data.containsKey('numeric_value')) {
      context.handle(
        _numericValueMeta,
        numericValue.isAcceptableOrUnknown(
          data['numeric_value']!,
          _numericValueMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('reference_range')) {
      context.handle(
        _referenceRangeMeta,
        referenceRange.isAcceptableOrUnknown(
          data['reference_range']!,
          _referenceRangeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceRangeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('original_snapshot')) {
      context.handle(
        _originalSnapshotMeta,
        originalSnapshot.isAcceptableOrUnknown(
          data['original_snapshot']!,
          _originalSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('edited_at')) {
      context.handle(
        _editedAtMeta,
        editedAt.isAcceptableOrUnknown(data['edited_at']!, _editedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('hospital_id')) {
      context.handle(
        _hospitalIdMeta,
        hospitalId.isAcceptableOrUnknown(data['hospital_id']!, _hospitalIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportedLabResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportedLabResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_id'],
      )!,
      sampleDateRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sample_date_raw'],
      )!,
      sampleDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sample_date'],
      )!,
      reportDateRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_date_raw'],
      )!,
      indicatorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}indicator_code'],
      )!,
      indicatorNameCn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}indicator_name_cn'],
      )!,
      rawValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_value'],
      )!,
      numericValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}numeric_value'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      referenceRange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_range'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
      originalSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_snapshot'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      editedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}edited_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      hospitalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hospital_id'],
      ),
    );
  }

  @override
  $ImportedLabResultsTable createAlias(String alias) {
    return $ImportedLabResultsTable(attachedDatabase, alias);
  }
}

class ImportedLabResult extends DataClass
    implements Insertable<ImportedLabResult> {
  final String id;
  final String fileName;
  final String reportId;
  final String sampleDateRaw;
  final DateTime sampleDate;
  final String reportDateRaw;
  final String indicatorCode;
  final String indicatorNameCn;
  final String rawValue;
  final double? numericValue;
  final String unit;
  final String referenceRange;
  final String category;
  final DateTime importedAt;
  final String? originalSnapshot;
  final String? note;
  final DateTime? editedAt;
  final DateTime? deletedAt;
  final String? hospitalId;
  const ImportedLabResult({
    required this.id,
    required this.fileName,
    required this.reportId,
    required this.sampleDateRaw,
    required this.sampleDate,
    required this.reportDateRaw,
    required this.indicatorCode,
    required this.indicatorNameCn,
    required this.rawValue,
    this.numericValue,
    required this.unit,
    required this.referenceRange,
    required this.category,
    required this.importedAt,
    this.originalSnapshot,
    this.note,
    this.editedAt,
    this.deletedAt,
    this.hospitalId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['file_name'] = Variable<String>(fileName);
    map['report_id'] = Variable<String>(reportId);
    map['sample_date_raw'] = Variable<String>(sampleDateRaw);
    map['sample_date'] = Variable<DateTime>(sampleDate);
    map['report_date_raw'] = Variable<String>(reportDateRaw);
    map['indicator_code'] = Variable<String>(indicatorCode);
    map['indicator_name_cn'] = Variable<String>(indicatorNameCn);
    map['raw_value'] = Variable<String>(rawValue);
    if (!nullToAbsent || numericValue != null) {
      map['numeric_value'] = Variable<double>(numericValue);
    }
    map['unit'] = Variable<String>(unit);
    map['reference_range'] = Variable<String>(referenceRange);
    map['category'] = Variable<String>(category);
    map['imported_at'] = Variable<DateTime>(importedAt);
    if (!nullToAbsent || originalSnapshot != null) {
      map['original_snapshot'] = Variable<String>(originalSnapshot);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || editedAt != null) {
      map['edited_at'] = Variable<DateTime>(editedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || hospitalId != null) {
      map['hospital_id'] = Variable<String>(hospitalId);
    }
    return map;
  }

  ImportedLabResultsCompanion toCompanion(bool nullToAbsent) {
    return ImportedLabResultsCompanion(
      id: Value(id),
      fileName: Value(fileName),
      reportId: Value(reportId),
      sampleDateRaw: Value(sampleDateRaw),
      sampleDate: Value(sampleDate),
      reportDateRaw: Value(reportDateRaw),
      indicatorCode: Value(indicatorCode),
      indicatorNameCn: Value(indicatorNameCn),
      rawValue: Value(rawValue),
      numericValue: numericValue == null && nullToAbsent
          ? const Value.absent()
          : Value(numericValue),
      unit: Value(unit),
      referenceRange: Value(referenceRange),
      category: Value(category),
      importedAt: Value(importedAt),
      originalSnapshot: originalSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(originalSnapshot),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      editedAt: editedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(editedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      hospitalId: hospitalId == null && nullToAbsent
          ? const Value.absent()
          : Value(hospitalId),
    );
  }

  factory ImportedLabResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportedLabResult(
      id: serializer.fromJson<String>(json['id']),
      fileName: serializer.fromJson<String>(json['fileName']),
      reportId: serializer.fromJson<String>(json['reportId']),
      sampleDateRaw: serializer.fromJson<String>(json['sampleDateRaw']),
      sampleDate: serializer.fromJson<DateTime>(json['sampleDate']),
      reportDateRaw: serializer.fromJson<String>(json['reportDateRaw']),
      indicatorCode: serializer.fromJson<String>(json['indicatorCode']),
      indicatorNameCn: serializer.fromJson<String>(json['indicatorNameCn']),
      rawValue: serializer.fromJson<String>(json['rawValue']),
      numericValue: serializer.fromJson<double?>(json['numericValue']),
      unit: serializer.fromJson<String>(json['unit']),
      referenceRange: serializer.fromJson<String>(json['referenceRange']),
      category: serializer.fromJson<String>(json['category']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      originalSnapshot: serializer.fromJson<String?>(json['originalSnapshot']),
      note: serializer.fromJson<String?>(json['note']),
      editedAt: serializer.fromJson<DateTime?>(json['editedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      hospitalId: serializer.fromJson<String?>(json['hospitalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fileName': serializer.toJson<String>(fileName),
      'reportId': serializer.toJson<String>(reportId),
      'sampleDateRaw': serializer.toJson<String>(sampleDateRaw),
      'sampleDate': serializer.toJson<DateTime>(sampleDate),
      'reportDateRaw': serializer.toJson<String>(reportDateRaw),
      'indicatorCode': serializer.toJson<String>(indicatorCode),
      'indicatorNameCn': serializer.toJson<String>(indicatorNameCn),
      'rawValue': serializer.toJson<String>(rawValue),
      'numericValue': serializer.toJson<double?>(numericValue),
      'unit': serializer.toJson<String>(unit),
      'referenceRange': serializer.toJson<String>(referenceRange),
      'category': serializer.toJson<String>(category),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'originalSnapshot': serializer.toJson<String?>(originalSnapshot),
      'note': serializer.toJson<String?>(note),
      'editedAt': serializer.toJson<DateTime?>(editedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'hospitalId': serializer.toJson<String?>(hospitalId),
    };
  }

  ImportedLabResult copyWith({
    String? id,
    String? fileName,
    String? reportId,
    String? sampleDateRaw,
    DateTime? sampleDate,
    String? reportDateRaw,
    String? indicatorCode,
    String? indicatorNameCn,
    String? rawValue,
    Value<double?> numericValue = const Value.absent(),
    String? unit,
    String? referenceRange,
    String? category,
    DateTime? importedAt,
    Value<String?> originalSnapshot = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<DateTime?> editedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> hospitalId = const Value.absent(),
  }) => ImportedLabResult(
    id: id ?? this.id,
    fileName: fileName ?? this.fileName,
    reportId: reportId ?? this.reportId,
    sampleDateRaw: sampleDateRaw ?? this.sampleDateRaw,
    sampleDate: sampleDate ?? this.sampleDate,
    reportDateRaw: reportDateRaw ?? this.reportDateRaw,
    indicatorCode: indicatorCode ?? this.indicatorCode,
    indicatorNameCn: indicatorNameCn ?? this.indicatorNameCn,
    rawValue: rawValue ?? this.rawValue,
    numericValue: numericValue.present ? numericValue.value : this.numericValue,
    unit: unit ?? this.unit,
    referenceRange: referenceRange ?? this.referenceRange,
    category: category ?? this.category,
    importedAt: importedAt ?? this.importedAt,
    originalSnapshot: originalSnapshot.present
        ? originalSnapshot.value
        : this.originalSnapshot,
    note: note.present ? note.value : this.note,
    editedAt: editedAt.present ? editedAt.value : this.editedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    hospitalId: hospitalId.present ? hospitalId.value : this.hospitalId,
  );
  ImportedLabResult copyWithCompanion(ImportedLabResultsCompanion data) {
    return ImportedLabResult(
      id: data.id.present ? data.id.value : this.id,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      sampleDateRaw: data.sampleDateRaw.present
          ? data.sampleDateRaw.value
          : this.sampleDateRaw,
      sampleDate: data.sampleDate.present
          ? data.sampleDate.value
          : this.sampleDate,
      reportDateRaw: data.reportDateRaw.present
          ? data.reportDateRaw.value
          : this.reportDateRaw,
      indicatorCode: data.indicatorCode.present
          ? data.indicatorCode.value
          : this.indicatorCode,
      indicatorNameCn: data.indicatorNameCn.present
          ? data.indicatorNameCn.value
          : this.indicatorNameCn,
      rawValue: data.rawValue.present ? data.rawValue.value : this.rawValue,
      numericValue: data.numericValue.present
          ? data.numericValue.value
          : this.numericValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      referenceRange: data.referenceRange.present
          ? data.referenceRange.value
          : this.referenceRange,
      category: data.category.present ? data.category.value : this.category,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      originalSnapshot: data.originalSnapshot.present
          ? data.originalSnapshot.value
          : this.originalSnapshot,
      note: data.note.present ? data.note.value : this.note,
      editedAt: data.editedAt.present ? data.editedAt.value : this.editedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      hospitalId: data.hospitalId.present
          ? data.hospitalId.value
          : this.hospitalId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportedLabResult(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('reportId: $reportId, ')
          ..write('sampleDateRaw: $sampleDateRaw, ')
          ..write('sampleDate: $sampleDate, ')
          ..write('reportDateRaw: $reportDateRaw, ')
          ..write('indicatorCode: $indicatorCode, ')
          ..write('indicatorNameCn: $indicatorNameCn, ')
          ..write('rawValue: $rawValue, ')
          ..write('numericValue: $numericValue, ')
          ..write('unit: $unit, ')
          ..write('referenceRange: $referenceRange, ')
          ..write('category: $category, ')
          ..write('importedAt: $importedAt, ')
          ..write('originalSnapshot: $originalSnapshot, ')
          ..write('note: $note, ')
          ..write('editedAt: $editedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hospitalId: $hospitalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fileName,
    reportId,
    sampleDateRaw,
    sampleDate,
    reportDateRaw,
    indicatorCode,
    indicatorNameCn,
    rawValue,
    numericValue,
    unit,
    referenceRange,
    category,
    importedAt,
    originalSnapshot,
    note,
    editedAt,
    deletedAt,
    hospitalId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportedLabResult &&
          other.id == this.id &&
          other.fileName == this.fileName &&
          other.reportId == this.reportId &&
          other.sampleDateRaw == this.sampleDateRaw &&
          other.sampleDate == this.sampleDate &&
          other.reportDateRaw == this.reportDateRaw &&
          other.indicatorCode == this.indicatorCode &&
          other.indicatorNameCn == this.indicatorNameCn &&
          other.rawValue == this.rawValue &&
          other.numericValue == this.numericValue &&
          other.unit == this.unit &&
          other.referenceRange == this.referenceRange &&
          other.category == this.category &&
          other.importedAt == this.importedAt &&
          other.originalSnapshot == this.originalSnapshot &&
          other.note == this.note &&
          other.editedAt == this.editedAt &&
          other.deletedAt == this.deletedAt &&
          other.hospitalId == this.hospitalId);
}

class ImportedLabResultsCompanion extends UpdateCompanion<ImportedLabResult> {
  final Value<String> id;
  final Value<String> fileName;
  final Value<String> reportId;
  final Value<String> sampleDateRaw;
  final Value<DateTime> sampleDate;
  final Value<String> reportDateRaw;
  final Value<String> indicatorCode;
  final Value<String> indicatorNameCn;
  final Value<String> rawValue;
  final Value<double?> numericValue;
  final Value<String> unit;
  final Value<String> referenceRange;
  final Value<String> category;
  final Value<DateTime> importedAt;
  final Value<String?> originalSnapshot;
  final Value<String?> note;
  final Value<DateTime?> editedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> hospitalId;
  final Value<int> rowid;
  const ImportedLabResultsCompanion({
    this.id = const Value.absent(),
    this.fileName = const Value.absent(),
    this.reportId = const Value.absent(),
    this.sampleDateRaw = const Value.absent(),
    this.sampleDate = const Value.absent(),
    this.reportDateRaw = const Value.absent(),
    this.indicatorCode = const Value.absent(),
    this.indicatorNameCn = const Value.absent(),
    this.rawValue = const Value.absent(),
    this.numericValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.referenceRange = const Value.absent(),
    this.category = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.originalSnapshot = const Value.absent(),
    this.note = const Value.absent(),
    this.editedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hospitalId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportedLabResultsCompanion.insert({
    required String id,
    required String fileName,
    required String reportId,
    required String sampleDateRaw,
    required DateTime sampleDate,
    required String reportDateRaw,
    required String indicatorCode,
    required String indicatorNameCn,
    required String rawValue,
    this.numericValue = const Value.absent(),
    required String unit,
    required String referenceRange,
    required String category,
    required DateTime importedAt,
    this.originalSnapshot = const Value.absent(),
    this.note = const Value.absent(),
    this.editedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.hospitalId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fileName = Value(fileName),
       reportId = Value(reportId),
       sampleDateRaw = Value(sampleDateRaw),
       sampleDate = Value(sampleDate),
       reportDateRaw = Value(reportDateRaw),
       indicatorCode = Value(indicatorCode),
       indicatorNameCn = Value(indicatorNameCn),
       rawValue = Value(rawValue),
       unit = Value(unit),
       referenceRange = Value(referenceRange),
       category = Value(category),
       importedAt = Value(importedAt);
  static Insertable<ImportedLabResult> custom({
    Expression<String>? id,
    Expression<String>? fileName,
    Expression<String>? reportId,
    Expression<String>? sampleDateRaw,
    Expression<DateTime>? sampleDate,
    Expression<String>? reportDateRaw,
    Expression<String>? indicatorCode,
    Expression<String>? indicatorNameCn,
    Expression<String>? rawValue,
    Expression<double>? numericValue,
    Expression<String>? unit,
    Expression<String>? referenceRange,
    Expression<String>? category,
    Expression<DateTime>? importedAt,
    Expression<String>? originalSnapshot,
    Expression<String>? note,
    Expression<DateTime>? editedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? hospitalId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileName != null) 'file_name': fileName,
      if (reportId != null) 'report_id': reportId,
      if (sampleDateRaw != null) 'sample_date_raw': sampleDateRaw,
      if (sampleDate != null) 'sample_date': sampleDate,
      if (reportDateRaw != null) 'report_date_raw': reportDateRaw,
      if (indicatorCode != null) 'indicator_code': indicatorCode,
      if (indicatorNameCn != null) 'indicator_name_cn': indicatorNameCn,
      if (rawValue != null) 'raw_value': rawValue,
      if (numericValue != null) 'numeric_value': numericValue,
      if (unit != null) 'unit': unit,
      if (referenceRange != null) 'reference_range': referenceRange,
      if (category != null) 'category': category,
      if (importedAt != null) 'imported_at': importedAt,
      if (originalSnapshot != null) 'original_snapshot': originalSnapshot,
      if (note != null) 'note': note,
      if (editedAt != null) 'edited_at': editedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (hospitalId != null) 'hospital_id': hospitalId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportedLabResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? fileName,
    Value<String>? reportId,
    Value<String>? sampleDateRaw,
    Value<DateTime>? sampleDate,
    Value<String>? reportDateRaw,
    Value<String>? indicatorCode,
    Value<String>? indicatorNameCn,
    Value<String>? rawValue,
    Value<double?>? numericValue,
    Value<String>? unit,
    Value<String>? referenceRange,
    Value<String>? category,
    Value<DateTime>? importedAt,
    Value<String?>? originalSnapshot,
    Value<String?>? note,
    Value<DateTime?>? editedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? hospitalId,
    Value<int>? rowid,
  }) {
    return ImportedLabResultsCompanion(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      reportId: reportId ?? this.reportId,
      sampleDateRaw: sampleDateRaw ?? this.sampleDateRaw,
      sampleDate: sampleDate ?? this.sampleDate,
      reportDateRaw: reportDateRaw ?? this.reportDateRaw,
      indicatorCode: indicatorCode ?? this.indicatorCode,
      indicatorNameCn: indicatorNameCn ?? this.indicatorNameCn,
      rawValue: rawValue ?? this.rawValue,
      numericValue: numericValue ?? this.numericValue,
      unit: unit ?? this.unit,
      referenceRange: referenceRange ?? this.referenceRange,
      category: category ?? this.category,
      importedAt: importedAt ?? this.importedAt,
      originalSnapshot: originalSnapshot ?? this.originalSnapshot,
      note: note ?? this.note,
      editedAt: editedAt ?? this.editedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      hospitalId: hospitalId ?? this.hospitalId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (reportId.present) {
      map['report_id'] = Variable<String>(reportId.value);
    }
    if (sampleDateRaw.present) {
      map['sample_date_raw'] = Variable<String>(sampleDateRaw.value);
    }
    if (sampleDate.present) {
      map['sample_date'] = Variable<DateTime>(sampleDate.value);
    }
    if (reportDateRaw.present) {
      map['report_date_raw'] = Variable<String>(reportDateRaw.value);
    }
    if (indicatorCode.present) {
      map['indicator_code'] = Variable<String>(indicatorCode.value);
    }
    if (indicatorNameCn.present) {
      map['indicator_name_cn'] = Variable<String>(indicatorNameCn.value);
    }
    if (rawValue.present) {
      map['raw_value'] = Variable<String>(rawValue.value);
    }
    if (numericValue.present) {
      map['numeric_value'] = Variable<double>(numericValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (referenceRange.present) {
      map['reference_range'] = Variable<String>(referenceRange.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (originalSnapshot.present) {
      map['original_snapshot'] = Variable<String>(originalSnapshot.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (editedAt.present) {
      map['edited_at'] = Variable<DateTime>(editedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (hospitalId.present) {
      map['hospital_id'] = Variable<String>(hospitalId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportedLabResultsCompanion(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('reportId: $reportId, ')
          ..write('sampleDateRaw: $sampleDateRaw, ')
          ..write('sampleDate: $sampleDate, ')
          ..write('reportDateRaw: $reportDateRaw, ')
          ..write('indicatorCode: $indicatorCode, ')
          ..write('indicatorNameCn: $indicatorNameCn, ')
          ..write('rawValue: $rawValue, ')
          ..write('numericValue: $numericValue, ')
          ..write('unit: $unit, ')
          ..write('referenceRange: $referenceRange, ')
          ..write('category: $category, ')
          ..write('importedAt: $importedAt, ')
          ..write('originalSnapshot: $originalSnapshot, ')
          ..write('note: $note, ')
          ..write('editedAt: $editedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('hospitalId: $hospitalId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisitsTable extends Visits with TableInfo<$VisitsTable, Visit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hospitalIdMeta = const VerificationMeta(
    'hospitalId',
  );
  @override
  late final GeneratedColumn<String> hospitalId = GeneratedColumn<String>(
    'hospital_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES hospitals (id)',
    ),
  );
  static const VerificationMeta _visitTypeMeta = const VerificationMeta(
    'visitType',
  );
  @override
  late final GeneratedColumn<String> visitType = GeneratedColumn<String>(
    'visit_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doctorMeta = const VerificationMeta('doctor');
  @override
  late final GeneratedColumn<String> doctor = GeneratedColumn<String>(
    'doctor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diagnosisMeta = const VerificationMeta(
    'diagnosis',
  );
  @override
  late final GeneratedColumn<String> diagnosis = GeneratedColumn<String>(
    'diagnosis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hospitalId,
    visitType,
    startDate,
    endDate,
    department,
    doctor,
    reason,
    diagnosis,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Visit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hospital_id')) {
      context.handle(
        _hospitalIdMeta,
        hospitalId.isAcceptableOrUnknown(data['hospital_id']!, _hospitalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hospitalIdMeta);
    }
    if (data.containsKey('visit_type')) {
      context.handle(
        _visitTypeMeta,
        visitType.isAcceptableOrUnknown(data['visit_type']!, _visitTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_visitTypeMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    }
    if (data.containsKey('doctor')) {
      context.handle(
        _doctorMeta,
        doctor.isAcceptableOrUnknown(data['doctor']!, _doctorMeta),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('diagnosis')) {
      context.handle(
        _diagnosisMeta,
        diagnosis.isAcceptableOrUnknown(data['diagnosis']!, _diagnosisMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Visit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Visit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      hospitalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hospital_id'],
      )!,
      visitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_type'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      ),
      doctor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      diagnosis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosis'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VisitsTable createAlias(String alias) {
    return $VisitsTable(attachedDatabase, alias);
  }
}

class Visit extends DataClass implements Insertable<Visit> {
  final String id;
  final String hospitalId;
  final String visitType;
  final DateTime startDate;
  final DateTime? endDate;
  final String? department;
  final String? doctor;
  final String? reason;
  final String? diagnosis;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Visit({
    required this.id,
    required this.hospitalId,
    required this.visitType,
    required this.startDate,
    this.endDate,
    this.department,
    this.doctor,
    this.reason,
    this.diagnosis,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hospital_id'] = Variable<String>(hospitalId);
    map['visit_type'] = Variable<String>(visitType);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    if (!nullToAbsent || doctor != null) {
      map['doctor'] = Variable<String>(doctor);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || diagnosis != null) {
      map['diagnosis'] = Variable<String>(diagnosis);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VisitsCompanion toCompanion(bool nullToAbsent) {
    return VisitsCompanion(
      id: Value(id),
      hospitalId: Value(hospitalId),
      visitType: Value(visitType),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
      doctor: doctor == null && nullToAbsent
          ? const Value.absent()
          : Value(doctor),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      diagnosis: diagnosis == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosis),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Visit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Visit(
      id: serializer.fromJson<String>(json['id']),
      hospitalId: serializer.fromJson<String>(json['hospitalId']),
      visitType: serializer.fromJson<String>(json['visitType']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      department: serializer.fromJson<String?>(json['department']),
      doctor: serializer.fromJson<String?>(json['doctor']),
      reason: serializer.fromJson<String?>(json['reason']),
      diagnosis: serializer.fromJson<String?>(json['diagnosis']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hospitalId': serializer.toJson<String>(hospitalId),
      'visitType': serializer.toJson<String>(visitType),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'department': serializer.toJson<String?>(department),
      'doctor': serializer.toJson<String?>(doctor),
      'reason': serializer.toJson<String?>(reason),
      'diagnosis': serializer.toJson<String?>(diagnosis),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Visit copyWith({
    String? id,
    String? hospitalId,
    String? visitType,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<String?> department = const Value.absent(),
    Value<String?> doctor = const Value.absent(),
    Value<String?> reason = const Value.absent(),
    Value<String?> diagnosis = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Visit(
    id: id ?? this.id,
    hospitalId: hospitalId ?? this.hospitalId,
    visitType: visitType ?? this.visitType,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    department: department.present ? department.value : this.department,
    doctor: doctor.present ? doctor.value : this.doctor,
    reason: reason.present ? reason.value : this.reason,
    diagnosis: diagnosis.present ? diagnosis.value : this.diagnosis,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Visit copyWithCompanion(VisitsCompanion data) {
    return Visit(
      id: data.id.present ? data.id.value : this.id,
      hospitalId: data.hospitalId.present
          ? data.hospitalId.value
          : this.hospitalId,
      visitType: data.visitType.present ? data.visitType.value : this.visitType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      department: data.department.present
          ? data.department.value
          : this.department,
      doctor: data.doctor.present ? data.doctor.value : this.doctor,
      reason: data.reason.present ? data.reason.value : this.reason,
      diagnosis: data.diagnosis.present ? data.diagnosis.value : this.diagnosis,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Visit(')
          ..write('id: $id, ')
          ..write('hospitalId: $hospitalId, ')
          ..write('visitType: $visitType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('department: $department, ')
          ..write('doctor: $doctor, ')
          ..write('reason: $reason, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hospitalId,
    visitType,
    startDate,
    endDate,
    department,
    doctor,
    reason,
    diagnosis,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Visit &&
          other.id == this.id &&
          other.hospitalId == this.hospitalId &&
          other.visitType == this.visitType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.department == this.department &&
          other.doctor == this.doctor &&
          other.reason == this.reason &&
          other.diagnosis == this.diagnosis &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VisitsCompanion extends UpdateCompanion<Visit> {
  final Value<String> id;
  final Value<String> hospitalId;
  final Value<String> visitType;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> department;
  final Value<String?> doctor;
  final Value<String?> reason;
  final Value<String?> diagnosis;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VisitsCompanion({
    this.id = const Value.absent(),
    this.hospitalId = const Value.absent(),
    this.visitType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.department = const Value.absent(),
    this.doctor = const Value.absent(),
    this.reason = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisitsCompanion.insert({
    required String id,
    required String hospitalId,
    required String visitType,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.department = const Value.absent(),
    this.doctor = const Value.absent(),
    this.reason = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       hospitalId = Value(hospitalId),
       visitType = Value(visitType),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Visit> custom({
    Expression<String>? id,
    Expression<String>? hospitalId,
    Expression<String>? visitType,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? department,
    Expression<String>? doctor,
    Expression<String>? reason,
    Expression<String>? diagnosis,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hospitalId != null) 'hospital_id': hospitalId,
      if (visitType != null) 'visit_type': visitType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (department != null) 'department': department,
      if (doctor != null) 'doctor': doctor,
      if (reason != null) 'reason': reason,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisitsCompanion copyWith({
    Value<String>? id,
    Value<String>? hospitalId,
    Value<String>? visitType,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<String?>? department,
    Value<String?>? doctor,
    Value<String?>? reason,
    Value<String?>? diagnosis,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return VisitsCompanion(
      id: id ?? this.id,
      hospitalId: hospitalId ?? this.hospitalId,
      visitType: visitType ?? this.visitType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      department: department ?? this.department,
      doctor: doctor ?? this.doctor,
      reason: reason ?? this.reason,
      diagnosis: diagnosis ?? this.diagnosis,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hospitalId.present) {
      map['hospital_id'] = Variable<String>(hospitalId.value);
    }
    if (visitType.present) {
      map['visit_type'] = Variable<String>(visitType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (doctor.present) {
      map['doctor'] = Variable<String>(doctor.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (diagnosis.present) {
      map['diagnosis'] = Variable<String>(diagnosis.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitsCompanion(')
          ..write('id: $id, ')
          ..write('hospitalId: $hospitalId, ')
          ..write('visitType: $visitType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('department: $department, ')
          ..write('doctor: $doctor, ')
          ..write('reason: $reason, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisitReportsTable extends VisitReports
    with TableInfo<$VisitReportsTable, VisitReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES visits (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportDateMeta = const VerificationMeta(
    'reportDate',
  );
  @override
  late final GeneratedColumn<DateTime> reportDate = GeneratedColumn<DateTime>(
    'report_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    visitId,
    title,
    reportDate,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visit_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisitReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('report_date')) {
      context.handle(
        _reportDateMeta,
        reportDate.isAcceptableOrUnknown(data['report_date']!, _reportDateMeta),
      );
    } else if (isInserting) {
      context.missing(_reportDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VisitReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisitReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      reportDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}report_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VisitReportsTable createAlias(String alias) {
    return $VisitReportsTable(attachedDatabase, alias);
  }
}

class VisitReport extends DataClass implements Insertable<VisitReport> {
  final String id;
  final String visitId;
  final String title;
  final DateTime reportDate;
  final String? notes;
  final DateTime createdAt;
  const VisitReport({
    required this.id,
    required this.visitId,
    required this.title,
    required this.reportDate,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['visit_id'] = Variable<String>(visitId);
    map['title'] = Variable<String>(title);
    map['report_date'] = Variable<DateTime>(reportDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VisitReportsCompanion toCompanion(bool nullToAbsent) {
    return VisitReportsCompanion(
      id: Value(id),
      visitId: Value(visitId),
      title: Value(title),
      reportDate: Value(reportDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory VisitReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisitReport(
      id: serializer.fromJson<String>(json['id']),
      visitId: serializer.fromJson<String>(json['visitId']),
      title: serializer.fromJson<String>(json['title']),
      reportDate: serializer.fromJson<DateTime>(json['reportDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'visitId': serializer.toJson<String>(visitId),
      'title': serializer.toJson<String>(title),
      'reportDate': serializer.toJson<DateTime>(reportDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VisitReport copyWith({
    String? id,
    String? visitId,
    String? title,
    DateTime? reportDate,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => VisitReport(
    id: id ?? this.id,
    visitId: visitId ?? this.visitId,
    title: title ?? this.title,
    reportDate: reportDate ?? this.reportDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  VisitReport copyWithCompanion(VisitReportsCompanion data) {
    return VisitReport(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      title: data.title.present ? data.title.value : this.title,
      reportDate: data.reportDate.present
          ? data.reportDate.value
          : this.reportDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisitReport(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('title: $title, ')
          ..write('reportDate: $reportDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, visitId, title, reportDate, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisitReport &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.title == this.title &&
          other.reportDate == this.reportDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class VisitReportsCompanion extends UpdateCompanion<VisitReport> {
  final Value<String> id;
  final Value<String> visitId;
  final Value<String> title;
  final Value<DateTime> reportDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VisitReportsCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.title = const Value.absent(),
    this.reportDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisitReportsCompanion.insert({
    required String id,
    required String visitId,
    required String title,
    required DateTime reportDate,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       visitId = Value(visitId),
       title = Value(title),
       reportDate = Value(reportDate),
       createdAt = Value(createdAt);
  static Insertable<VisitReport> custom({
    Expression<String>? id,
    Expression<String>? visitId,
    Expression<String>? title,
    Expression<DateTime>? reportDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (title != null) 'title': title,
      if (reportDate != null) 'report_date': reportDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisitReportsCompanion copyWith({
    Value<String>? id,
    Value<String>? visitId,
    Value<String>? title,
    Value<DateTime>? reportDate,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return VisitReportsCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      title: title ?? this.title,
      reportDate: reportDate ?? this.reportDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (reportDate.present) {
      map['report_date'] = Variable<DateTime>(reportDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitReportsCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('title: $title, ')
          ..write('reportDate: $reportDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportResultLinksTable extends ReportResultLinks
    with TableInfo<$ReportResultLinksTable, ReportResultLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportResultLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  @override
  late final GeneratedColumn<String> reportId = GeneratedColumn<String>(
    'report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES visit_reports (id)',
    ),
  );
  static const VerificationMeta _sourceKindMeta = const VerificationMeta(
    'sourceKind',
  );
  @override
  late final GeneratedColumn<String> sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultIdMeta = const VerificationMeta(
    'resultId',
  );
  @override
  late final GeneratedColumn<String> resultId = GeneratedColumn<String>(
    'result_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [reportId, sourceKind, resultId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_result_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportResultLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reportIdMeta);
    }
    if (data.containsKey('source_kind')) {
      context.handle(
        _sourceKindMeta,
        sourceKind.isAcceptableOrUnknown(data['source_kind']!, _sourceKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKindMeta);
    }
    if (data.containsKey('result_id')) {
      context.handle(
        _resultIdMeta,
        resultId.isAcceptableOrUnknown(data['result_id']!, _resultIdMeta),
      );
    } else if (isInserting) {
      context.missing(_resultIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sourceKind, resultId};
  @override
  ReportResultLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportResultLink(
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_id'],
      )!,
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
      resultId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_id'],
      )!,
    );
  }

  @override
  $ReportResultLinksTable createAlias(String alias) {
    return $ReportResultLinksTable(attachedDatabase, alias);
  }
}

class ReportResultLink extends DataClass
    implements Insertable<ReportResultLink> {
  final String reportId;
  final String sourceKind;
  final String resultId;
  const ReportResultLink({
    required this.reportId,
    required this.sourceKind,
    required this.resultId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['report_id'] = Variable<String>(reportId);
    map['source_kind'] = Variable<String>(sourceKind);
    map['result_id'] = Variable<String>(resultId);
    return map;
  }

  ReportResultLinksCompanion toCompanion(bool nullToAbsent) {
    return ReportResultLinksCompanion(
      reportId: Value(reportId),
      sourceKind: Value(sourceKind),
      resultId: Value(resultId),
    );
  }

  factory ReportResultLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportResultLink(
      reportId: serializer.fromJson<String>(json['reportId']),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
      resultId: serializer.fromJson<String>(json['resultId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'reportId': serializer.toJson<String>(reportId),
      'sourceKind': serializer.toJson<String>(sourceKind),
      'resultId': serializer.toJson<String>(resultId),
    };
  }

  ReportResultLink copyWith({
    String? reportId,
    String? sourceKind,
    String? resultId,
  }) => ReportResultLink(
    reportId: reportId ?? this.reportId,
    sourceKind: sourceKind ?? this.sourceKind,
    resultId: resultId ?? this.resultId,
  );
  ReportResultLink copyWithCompanion(ReportResultLinksCompanion data) {
    return ReportResultLink(
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      resultId: data.resultId.present ? data.resultId.value : this.resultId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportResultLink(')
          ..write('reportId: $reportId, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('resultId: $resultId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(reportId, sourceKind, resultId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportResultLink &&
          other.reportId == this.reportId &&
          other.sourceKind == this.sourceKind &&
          other.resultId == this.resultId);
}

class ReportResultLinksCompanion extends UpdateCompanion<ReportResultLink> {
  final Value<String> reportId;
  final Value<String> sourceKind;
  final Value<String> resultId;
  final Value<int> rowid;
  const ReportResultLinksCompanion({
    this.reportId = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.resultId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportResultLinksCompanion.insert({
    required String reportId,
    required String sourceKind,
    required String resultId,
    this.rowid = const Value.absent(),
  }) : reportId = Value(reportId),
       sourceKind = Value(sourceKind),
       resultId = Value(resultId);
  static Insertable<ReportResultLink> custom({
    Expression<String>? reportId,
    Expression<String>? sourceKind,
    Expression<String>? resultId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (reportId != null) 'report_id': reportId,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (resultId != null) 'result_id': resultId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportResultLinksCompanion copyWith({
    Value<String>? reportId,
    Value<String>? sourceKind,
    Value<String>? resultId,
    Value<int>? rowid,
  }) {
    return ReportResultLinksCompanion(
      reportId: reportId ?? this.reportId,
      sourceKind: sourceKind ?? this.sourceKind,
      resultId: resultId ?? this.resultId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (reportId.present) {
      map['report_id'] = Variable<String>(reportId.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    if (resultId.present) {
      map['result_id'] = Variable<String>(resultId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportResultLinksCompanion(')
          ..write('reportId: $reportId, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('resultId: $resultId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<String> strength = GeneratedColumn<String>(
    'strength',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
    'form',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    strength,
    form,
    purpose,
    notes,
    createdAt,
    updatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('form')) {
      context.handle(
        _formMeta,
        form.isAcceptableOrUnknown(data['form']!, _formMeta),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strength'],
      ),
      form: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form'],
      ),
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final String id;
  final String name;
  final String? strength;
  final String? form;
  final String? purpose;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const Medication({
    required this.id,
    required this.name,
    this.strength,
    this.form,
    this.purpose,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || strength != null) {
      map['strength'] = Variable<String>(strength);
    }
    if (!nullToAbsent || form != null) {
      map['form'] = Variable<String>(form);
    }
    if (!nullToAbsent || purpose != null) {
      map['purpose'] = Variable<String>(purpose);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      strength: strength == null && nullToAbsent
          ? const Value.absent()
          : Value(strength),
      form: form == null && nullToAbsent ? const Value.absent() : Value(form),
      purpose: purpose == null && nullToAbsent
          ? const Value.absent()
          : Value(purpose),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Medication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      strength: serializer.fromJson<String?>(json['strength']),
      form: serializer.fromJson<String?>(json['form']),
      purpose: serializer.fromJson<String?>(json['purpose']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'strength': serializer.toJson<String?>(strength),
      'form': serializer.toJson<String?>(form),
      'purpose': serializer.toJson<String?>(purpose),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Medication copyWith({
    String? id,
    String? name,
    Value<String?> strength = const Value.absent(),
    Value<String?> form = const Value.absent(),
    Value<String?> purpose = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => Medication(
    id: id ?? this.id,
    name: name ?? this.name,
    strength: strength.present ? strength.value : this.strength,
    form: form.present ? form.value : this.form,
    purpose: purpose.present ? purpose.value : this.purpose,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      strength: data.strength.present ? data.strength.value : this.strength,
      form: data.form.present ? data.form.value : this.form,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('strength: $strength, ')
          ..write('form: $form, ')
          ..write('purpose: $purpose, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    strength,
    form,
    purpose,
    notes,
    createdAt,
    updatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.name == this.name &&
          other.strength == this.strength &&
          other.form == this.form &&
          other.purpose == this.purpose &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> strength;
  final Value<String?> form;
  final Value<String?> purpose;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.strength = const Value.absent(),
    this.form = const Value.absent(),
    this.purpose = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String name,
    this.strength = const Value.absent(),
    this.form = const Value.absent(),
    this.purpose = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Medication> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? strength,
    Expression<String>? form,
    Expression<String>? purpose,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (strength != null) 'strength': strength,
      if (form != null) 'form': form,
      if (purpose != null) 'purpose': purpose,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? strength,
    Value<String?>? form,
    Value<String?>? purpose,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      strength: strength ?? this.strength,
      form: form ?? this.form,
      purpose: purpose ?? this.purpose,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (strength.present) {
      map['strength'] = Variable<String>(strength.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('strength: $strength, ')
          ..write('form: $form, ')
          ..write('purpose: $purpose, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationPlansTable extends MedicationPlans
    with TableInfo<$MedicationPlansTable, MedicationPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id)',
    ),
  );
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
    'dose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timesMeta = const VerificationMeta('times');
  @override
  late final GeneratedColumn<String> times = GeneratedColumn<String>(
    'times',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changeReasonMeta = const VerificationMeta(
    'changeReason',
  );
  @override
  late final GeneratedColumn<String> changeReason = GeneratedColumn<String>(
    'change_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    dose,
    frequency,
    times,
    startDate,
    endDate,
    changeReason,
    instructions,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('times')) {
      context.handle(
        _timesMeta,
        times.isAcceptableOrUnknown(data['times']!, _timesMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('change_reason')) {
      context.handle(
        _changeReasonMeta,
        changeReason.isAcceptableOrUnknown(
          data['change_reason']!,
          _changeReasonMeta,
        ),
      );
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      )!,
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      times: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}times'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      changeReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change_reason'],
      ),
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicationPlansTable createAlias(String alias) {
    return $MedicationPlansTable(attachedDatabase, alias);
  }
}

class MedicationPlan extends DataClass implements Insertable<MedicationPlan> {
  final String id;
  final String medicationId;
  final String dose;
  final String frequency;
  final String? times;
  final DateTime startDate;
  final DateTime? endDate;
  final String? changeReason;
  final String? instructions;
  final DateTime createdAt;
  const MedicationPlan({
    required this.id,
    required this.medicationId,
    required this.dose,
    required this.frequency,
    this.times,
    required this.startDate,
    this.endDate,
    this.changeReason,
    this.instructions,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['dose'] = Variable<String>(dose);
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || times != null) {
      map['times'] = Variable<String>(times);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || changeReason != null) {
      map['change_reason'] = Variable<String>(changeReason);
    }
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicationPlansCompanion toCompanion(bool nullToAbsent) {
    return MedicationPlansCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      dose: Value(dose),
      frequency: Value(frequency),
      times: times == null && nullToAbsent
          ? const Value.absent()
          : Value(times),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      changeReason: changeReason == null && nullToAbsent
          ? const Value.absent()
          : Value(changeReason),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      createdAt: Value(createdAt),
    );
  }

  factory MedicationPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationPlan(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      dose: serializer.fromJson<String>(json['dose']),
      frequency: serializer.fromJson<String>(json['frequency']),
      times: serializer.fromJson<String?>(json['times']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      changeReason: serializer.fromJson<String?>(json['changeReason']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'dose': serializer.toJson<String>(dose),
      'frequency': serializer.toJson<String>(frequency),
      'times': serializer.toJson<String?>(times),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'changeReason': serializer.toJson<String?>(changeReason),
      'instructions': serializer.toJson<String?>(instructions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MedicationPlan copyWith({
    String? id,
    String? medicationId,
    String? dose,
    String? frequency,
    Value<String?> times = const Value.absent(),
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<String?> changeReason = const Value.absent(),
    Value<String?> instructions = const Value.absent(),
    DateTime? createdAt,
  }) => MedicationPlan(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    dose: dose ?? this.dose,
    frequency: frequency ?? this.frequency,
    times: times.present ? times.value : this.times,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    changeReason: changeReason.present ? changeReason.value : this.changeReason,
    instructions: instructions.present ? instructions.value : this.instructions,
    createdAt: createdAt ?? this.createdAt,
  );
  MedicationPlan copyWithCompanion(MedicationPlansCompanion data) {
    return MedicationPlan(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      dose: data.dose.present ? data.dose.value : this.dose,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      times: data.times.present ? data.times.value : this.times,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      changeReason: data.changeReason.present
          ? data.changeReason.value
          : this.changeReason,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationPlan(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('dose: $dose, ')
          ..write('frequency: $frequency, ')
          ..write('times: $times, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('changeReason: $changeReason, ')
          ..write('instructions: $instructions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    dose,
    frequency,
    times,
    startDate,
    endDate,
    changeReason,
    instructions,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationPlan &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.dose == this.dose &&
          other.frequency == this.frequency &&
          other.times == this.times &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.changeReason == this.changeReason &&
          other.instructions == this.instructions &&
          other.createdAt == this.createdAt);
}

class MedicationPlansCompanion extends UpdateCompanion<MedicationPlan> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> dose;
  final Value<String> frequency;
  final Value<String?> times;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> changeReason;
  final Value<String?> instructions;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MedicationPlansCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.dose = const Value.absent(),
    this.frequency = const Value.absent(),
    this.times = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.changeReason = const Value.absent(),
    this.instructions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationPlansCompanion.insert({
    required String id,
    required String medicationId,
    required String dose,
    required String frequency,
    this.times = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.changeReason = const Value.absent(),
    this.instructions = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       dose = Value(dose),
       frequency = Value(frequency),
       startDate = Value(startDate),
       createdAt = Value(createdAt);
  static Insertable<MedicationPlan> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? dose,
    Expression<String>? frequency,
    Expression<String>? times,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? changeReason,
    Expression<String>? instructions,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (dose != null) 'dose': dose,
      if (frequency != null) 'frequency': frequency,
      if (times != null) 'times': times,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (changeReason != null) 'change_reason': changeReason,
      if (instructions != null) 'instructions': instructions,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<String>? dose,
    Value<String>? frequency,
    Value<String?>? times,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<String?>? changeReason,
    Value<String?>? instructions,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MedicationPlansCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      dose: dose ?? this.dose,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      changeReason: changeReason ?? this.changeReason,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (times.present) {
      map['times'] = Variable<String>(times.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (changeReason.present) {
      map['change_reason'] = Variable<String>(changeReason.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationPlansCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('dose: $dose, ')
          ..write('frequency: $frequency, ')
          ..write('times: $times, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('changeReason: $changeReason, ')
          ..write('instructions: $instructions, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LabCategoriesTable labCategories = $LabCategoriesTable(this);
  late final $LabTestsTable labTests = $LabTestsTable(this);
  late final $LabResultsTable labResults = $LabResultsTable(this);
  late final $HospitalsTable hospitals = $HospitalsTable(this);
  late final $ImportedLabResultsTable importedLabResults =
      $ImportedLabResultsTable(this);
  late final $VisitsTable visits = $VisitsTable(this);
  late final $VisitReportsTable visitReports = $VisitReportsTable(this);
  late final $ReportResultLinksTable reportResultLinks =
      $ReportResultLinksTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicationPlansTable medicationPlans = $MedicationPlansTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    labCategories,
    labTests,
    labResults,
    hospitals,
    importedLabResults,
    visits,
    visitReports,
    reportResultLinks,
    medications,
    medicationPlans,
  ];
}

typedef $$LabCategoriesTableCreateCompanionBuilder =
    LabCategoriesCompanion Function({
      required String id,
      required String code,
      required String nameZh,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$LabCategoriesTableUpdateCompanionBuilder =
    LabCategoriesCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> nameZh,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$LabCategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $LabCategoriesTable, LabCategory> {
  $$LabCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$LabTestsTable, List<LabTest>> _labTestsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.labTests,
    aliasName: 'lab_categories__id__lab_tests__category_id',
  );

  $$LabTestsTableProcessedTableManager get labTestsRefs {
    final manager = $$LabTestsTableTableManager(
      $_db,
      $_db.labTests,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_labTestsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LabCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $LabCategoriesTable> {
  $$LabCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> labTestsRefs(
    Expression<bool> Function($$LabTestsTableFilterComposer f) f,
  ) {
    final $$LabTestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.labTests,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabTestsTableFilterComposer(
            $db: $db,
            $table: $db.labTests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LabCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LabCategoriesTable> {
  $$LabCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LabCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabCategoriesTable> {
  $$LabCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameZh =>
      $composableBuilder(column: $table.nameZh, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> labTestsRefs<T extends Object>(
    Expression<T> Function($$LabTestsTableAnnotationComposer a) f,
  ) {
    final $$LabTestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.labTests,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabTestsTableAnnotationComposer(
            $db: $db,
            $table: $db.labTests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LabCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabCategoriesTable,
          LabCategory,
          $$LabCategoriesTableFilterComposer,
          $$LabCategoriesTableOrderingComposer,
          $$LabCategoriesTableAnnotationComposer,
          $$LabCategoriesTableCreateCompanionBuilder,
          $$LabCategoriesTableUpdateCompanionBuilder,
          (LabCategory, $$LabCategoriesTableReferences),
          LabCategory,
          PrefetchHooks Function({bool labTestsRefs})
        > {
  $$LabCategoriesTableTableManager(_$AppDatabase db, $LabCategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameZh = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabCategoriesCompanion(
                id: id,
                code: code,
                nameZh: nameZh,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String nameZh,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabCategoriesCompanion.insert(
                id: id,
                code: code,
                nameZh: nameZh,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LabCategoriesTable, LabCategory>(table),
                  $$LabCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({labTestsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (labTestsRefs) db.labTests],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (labTestsRefs)
                    await $_getPrefetchedData<
                      LabCategory,
                      $LabCategoriesTable,
                      LabTest
                    >(
                      currentTable: table,
                      referencedTable: $$LabCategoriesTableReferences
                          ._labTestsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LabCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).labTestsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LabCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabCategoriesTable,
      LabCategory,
      $$LabCategoriesTableFilterComposer,
      $$LabCategoriesTableOrderingComposer,
      $$LabCategoriesTableAnnotationComposer,
      $$LabCategoriesTableCreateCompanionBuilder,
      $$LabCategoriesTableUpdateCompanionBuilder,
      (LabCategory, $$LabCategoriesTableReferences),
      LabCategory,
      PrefetchHooks Function({bool labTestsRefs})
    >;
typedef $$LabTestsTableCreateCompanionBuilder = LabTestsCompanion Function({
  required String id,
  required String categoryId,
  required String code,
  required String nameZh,
  Value<String?> nameDe,
  required String canonicalUnit,
  Value<int> rowid,
});
typedef $$LabTestsTableUpdateCompanionBuilder = LabTestsCompanion Function({
  Value<String> id,
  Value<String> categoryId,
  Value<String> code,
  Value<String> nameZh,
  Value<String?> nameDe,
  Value<String> canonicalUnit,
  Value<int> rowid,
});

final class $$LabTestsTableReferences
    extends BaseReferences<_$AppDatabase, $LabTestsTable, LabTest> {
  $$LabTestsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LabCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .labCategories
      .createAlias('lab_tests__category_id__lab_categories__id');

  $$LabCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$LabCategoriesTableTableManager(
      $_db,
      $_db.labCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LabResultsTable, List<LabResult>>
  _labResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.labResults,
    aliasName: 'lab_tests__id__lab_results__test_id',
  );

  $$LabResultsTableProcessedTableManager get labResultsRefs {
    final manager = $$LabResultsTableTableManager(
      $_db,
      $_db.labResults,
    ).filter((f) => f.testId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_labResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LabTestsTableFilterComposer
    extends Composer<_$AppDatabase, $LabTestsTable> {
  $$LabTestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameDe => $composableBuilder(
    column: $table.nameDe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalUnit => $composableBuilder(
    column: $table.canonicalUnit,
    builder: (column) => ColumnFilters(column),
  );

  $$LabCategoriesTableFilterComposer get categoryId {
    final $$LabCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.labCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.labCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> labResultsRefs(
    Expression<bool> Function($$LabResultsTableFilterComposer f) f,
  ) {
    final $$LabResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.labResults,
      getReferencedColumn: (t) => t.testId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabResultsTableFilterComposer(
            $db: $db,
            $table: $db.labResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LabTestsTableOrderingComposer
    extends Composer<_$AppDatabase, $LabTestsTable> {
  $$LabTestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameDe => $composableBuilder(
    column: $table.nameDe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalUnit => $composableBuilder(
    column: $table.canonicalUnit,
    builder: (column) => ColumnOrderings(column),
  );

  $$LabCategoriesTableOrderingComposer get categoryId {
    final $$LabCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.labCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.labCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabTestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabTestsTable> {
  $$LabTestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameZh =>
      $composableBuilder(column: $table.nameZh, builder: (column) => column);

  GeneratedColumn<String> get nameDe =>
      $composableBuilder(column: $table.nameDe, builder: (column) => column);

  GeneratedColumn<String> get canonicalUnit => $composableBuilder(
    column: $table.canonicalUnit,
    builder: (column) => column,
  );

  $$LabCategoriesTableAnnotationComposer get categoryId {
    final $$LabCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.labCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.labCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> labResultsRefs<T extends Object>(
    Expression<T> Function($$LabResultsTableAnnotationComposer a) f,
  ) {
    final $$LabResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.labResults,
      getReferencedColumn: (t) => t.testId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.labResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LabTestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabTestsTable,
          LabTest,
          $$LabTestsTableFilterComposer,
          $$LabTestsTableOrderingComposer,
          $$LabTestsTableAnnotationComposer,
          $$LabTestsTableCreateCompanionBuilder,
          $$LabTestsTableUpdateCompanionBuilder,
          (LabTest, $$LabTestsTableReferences),
          LabTest,
          PrefetchHooks Function({bool categoryId, bool labResultsRefs})
        > {
  $$LabTestsTableTableManager(_$AppDatabase db, $LabTestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabTestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabTestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabTestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameZh = const Value.absent(),
                Value<String?> nameDe = const Value.absent(),
                Value<String> canonicalUnit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabTestsCompanion(
                id: id,
                categoryId: categoryId,
                code: code,
                nameZh: nameZh,
                nameDe: nameDe,
                canonicalUnit: canonicalUnit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryId,
                required String code,
                required String nameZh,
                Value<String?> nameDe = const Value.absent(),
                required String canonicalUnit,
                Value<int> rowid = const Value.absent(),
              }) => LabTestsCompanion.insert(
                id: id,
                categoryId: categoryId,
                code: code,
                nameZh: nameZh,
                nameDe: nameDe,
                canonicalUnit: canonicalUnit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LabTestsTable, LabTest>(table),
                  $$LabTestsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, labResultsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (labResultsRefs) db.labResults],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$LabTestsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$LabTestsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (labResultsRefs)
                        await $_getPrefetchedData<
                          LabTest,
                          $LabTestsTable,
                          LabResult
                        >(
                          currentTable: table,
                          referencedTable: $$LabTestsTableReferences
                              ._labResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LabTestsTableReferences(
                                db,
                                table,
                                p0,
                              ).labResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.testId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LabTestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabTestsTable,
      LabTest,
      $$LabTestsTableFilterComposer,
      $$LabTestsTableOrderingComposer,
      $$LabTestsTableAnnotationComposer,
      $$LabTestsTableCreateCompanionBuilder,
      $$LabTestsTableUpdateCompanionBuilder,
      (LabTest, $$LabTestsTableReferences),
      LabTest,
      PrefetchHooks Function({bool categoryId, bool labResultsRefs})
    >;
typedef $$LabResultsTableCreateCompanionBuilder = LabResultsCompanion Function({
  required String id,
  required String testId,
  required DateTime measuredAt,
  required double valueNumeric,
  required String unit,
  Value<double?> referenceLow,
  Value<double?> referenceHigh,
  Value<String?> note,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$LabResultsTableUpdateCompanionBuilder = LabResultsCompanion Function({
  Value<String> id,
  Value<String> testId,
  Value<DateTime> measuredAt,
  Value<double> valueNumeric,
  Value<String> unit,
  Value<double?> referenceLow,
  Value<double?> referenceHigh,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$LabResultsTableReferences
    extends BaseReferences<_$AppDatabase, $LabResultsTable, LabResult> {
  $$LabResultsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LabTestsTable _testIdTable(_$AppDatabase db) =>
      db.labTests.createAlias('lab_results__test_id__lab_tests__id');

  $$LabTestsTableProcessedTableManager get testId {
    final $_column = $_itemColumn<String>('test_id')!;

    final manager = $$LabTestsTableTableManager(
      $_db,
      $_db.labTests,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_testIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LabResultsTableFilterComposer
    extends Composer<_$AppDatabase, $LabResultsTable> {
  $$LabResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valueNumeric => $composableBuilder(
    column: $table.valueNumeric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get referenceLow => $composableBuilder(
    column: $table.referenceLow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get referenceHigh => $composableBuilder(
    column: $table.referenceHigh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LabTestsTableFilterComposer get testId {
    final $$LabTestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.testId,
      referencedTable: $db.labTests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabTestsTableFilterComposer(
            $db: $db,
            $table: $db.labTests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $LabResultsTable> {
  $$LabResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valueNumeric => $composableBuilder(
    column: $table.valueNumeric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get referenceLow => $composableBuilder(
    column: $table.referenceLow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get referenceHigh => $composableBuilder(
    column: $table.referenceHigh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LabTestsTableOrderingComposer get testId {
    final $$LabTestsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.testId,
      referencedTable: $db.labTests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabTestsTableOrderingComposer(
            $db: $db,
            $table: $db.labTests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabResultsTable> {
  $$LabResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get valueNumeric => $composableBuilder(
    column: $table.valueNumeric,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get referenceLow => $composableBuilder(
    column: $table.referenceLow,
    builder: (column) => column,
  );

  GeneratedColumn<double> get referenceHigh => $composableBuilder(
    column: $table.referenceHigh,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$LabTestsTableAnnotationComposer get testId {
    final $$LabTestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.testId,
      referencedTable: $db.labTests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabTestsTableAnnotationComposer(
            $db: $db,
            $table: $db.labTests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabResultsTable,
          LabResult,
          $$LabResultsTableFilterComposer,
          $$LabResultsTableOrderingComposer,
          $$LabResultsTableAnnotationComposer,
          $$LabResultsTableCreateCompanionBuilder,
          $$LabResultsTableUpdateCompanionBuilder,
          (LabResult, $$LabResultsTableReferences),
          LabResult,
          PrefetchHooks Function({bool testId})
        > {
  $$LabResultsTableTableManager(_$AppDatabase db, $LabResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> testId = const Value.absent(),
                Value<DateTime> measuredAt = const Value.absent(),
                Value<double> valueNumeric = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double?> referenceLow = const Value.absent(),
                Value<double?> referenceHigh = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabResultsCompanion(
                id: id,
                testId: testId,
                measuredAt: measuredAt,
                valueNumeric: valueNumeric,
                unit: unit,
                referenceLow: referenceLow,
                referenceHigh: referenceHigh,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String testId,
                required DateTime measuredAt,
                required double valueNumeric,
                required String unit,
                Value<double?> referenceLow = const Value.absent(),
                Value<double?> referenceHigh = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabResultsCompanion.insert(
                id: id,
                testId: testId,
                measuredAt: measuredAt,
                valueNumeric: valueNumeric,
                unit: unit,
                referenceLow: referenceLow,
                referenceHigh: referenceHigh,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LabResultsTable, LabResult>(table),
                  $$LabResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({testId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (testId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.testId,
                        referencedTable: $$LabResultsTableReferences
                            ._testIdTable(db),
                        referencedColumn: $$LabResultsTableReferences
                            ._testIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LabResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabResultsTable,
      LabResult,
      $$LabResultsTableFilterComposer,
      $$LabResultsTableOrderingComposer,
      $$LabResultsTableAnnotationComposer,
      $$LabResultsTableCreateCompanionBuilder,
      $$LabResultsTableUpdateCompanionBuilder,
      (LabResult, $$LabResultsTableReferences),
      LabResult,
      PrefetchHooks Function({bool testId})
    >;
typedef $$HospitalsTableCreateCompanionBuilder = HospitalsCompanion Function({
  required String id,
  required String name,
  Value<String?> city,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$HospitalsTableUpdateCompanionBuilder = HospitalsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> city,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$HospitalsTableReferences
    extends BaseReferences<_$AppDatabase, $HospitalsTable, Hospital> {
  $$HospitalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ImportedLabResultsTable, List<ImportedLabResult>>
  _importedLabResultsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.importedLabResults,
        aliasName: 'hospitals__id__imported_lab_results__hospital_id',
      );

  $$ImportedLabResultsTableProcessedTableManager get importedLabResultsRefs {
    final manager = $$ImportedLabResultsTableTableManager(
      $_db,
      $_db.importedLabResults,
    ).filter((f) => f.hospitalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _importedLabResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VisitsTable, List<Visit>> _visitsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.visits,
    aliasName: 'hospitals__id__visits__hospital_id',
  );

  $$VisitsTableProcessedTableManager get visitsRefs {
    final manager = $$VisitsTableTableManager(
      $_db,
      $_db.visits,
    ).filter((f) => f.hospitalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_visitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HospitalsTableFilterComposer
    extends Composer<_$AppDatabase, $HospitalsTable> {
  $$HospitalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> importedLabResultsRefs(
    Expression<bool> Function($$ImportedLabResultsTableFilterComposer f) f,
  ) {
    final $$ImportedLabResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importedLabResults,
      getReferencedColumn: (t) => t.hospitalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportedLabResultsTableFilterComposer(
            $db: $db,
            $table: $db.importedLabResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> visitsRefs(
    Expression<bool> Function($$VisitsTableFilterComposer f) f,
  ) {
    final $$VisitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.hospitalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableFilterComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HospitalsTableOrderingComposer
    extends Composer<_$AppDatabase, $HospitalsTable> {
  $$HospitalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HospitalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HospitalsTable> {
  $$HospitalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> importedLabResultsRefs<T extends Object>(
    Expression<T> Function($$ImportedLabResultsTableAnnotationComposer a) f,
  ) {
    final $$ImportedLabResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.importedLabResults,
          getReferencedColumn: (t) => t.hospitalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ImportedLabResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.importedLabResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> visitsRefs<T extends Object>(
    Expression<T> Function($$VisitsTableAnnotationComposer a) f,
  ) {
    final $$VisitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.hospitalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableAnnotationComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HospitalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HospitalsTable,
          Hospital,
          $$HospitalsTableFilterComposer,
          $$HospitalsTableOrderingComposer,
          $$HospitalsTableAnnotationComposer,
          $$HospitalsTableCreateCompanionBuilder,
          $$HospitalsTableUpdateCompanionBuilder,
          (Hospital, $$HospitalsTableReferences),
          Hospital,
          PrefetchHooks Function({bool importedLabResultsRefs, bool visitsRefs})
        > {
  $$HospitalsTableTableManager(_$AppDatabase db, $HospitalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HospitalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HospitalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HospitalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HospitalsCompanion(
                id: id,
                name: name,
                city: city,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> city = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => HospitalsCompanion.insert(
                id: id,
                name: name,
                city: city,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HospitalsTable, Hospital>(table),
                  $$HospitalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({importedLabResultsRefs = false, visitsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (importedLabResultsRefs) db.importedLabResults,
                    if (visitsRefs) db.visits,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (importedLabResultsRefs)
                        await $_getPrefetchedData<
                          Hospital,
                          $HospitalsTable,
                          ImportedLabResult
                        >(
                          currentTable: table,
                          referencedTable: $$HospitalsTableReferences
                              ._importedLabResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HospitalsTableReferences(
                                db,
                                table,
                                p0,
                              ).importedLabResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.hospitalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (visitsRefs)
                        await $_getPrefetchedData<
                          Hospital,
                          $HospitalsTable,
                          Visit
                        >(
                          currentTable: table,
                          referencedTable: $$HospitalsTableReferences
                              ._visitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HospitalsTableReferences(
                                db,
                                table,
                                p0,
                              ).visitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.hospitalId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$HospitalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HospitalsTable,
      Hospital,
      $$HospitalsTableFilterComposer,
      $$HospitalsTableOrderingComposer,
      $$HospitalsTableAnnotationComposer,
      $$HospitalsTableCreateCompanionBuilder,
      $$HospitalsTableUpdateCompanionBuilder,
      (Hospital, $$HospitalsTableReferences),
      Hospital,
      PrefetchHooks Function({bool importedLabResultsRefs, bool visitsRefs})
    >;
typedef $$ImportedLabResultsTableCreateCompanionBuilder =
    ImportedLabResultsCompanion Function({
      required String id,
      required String fileName,
      required String reportId,
      required String sampleDateRaw,
      required DateTime sampleDate,
      required String reportDateRaw,
      required String indicatorCode,
      required String indicatorNameCn,
      required String rawValue,
      Value<double?> numericValue,
      required String unit,
      required String referenceRange,
      required String category,
      required DateTime importedAt,
      Value<String?> originalSnapshot,
      Value<String?> note,
      Value<DateTime?> editedAt,
      Value<DateTime?> deletedAt,
      Value<String?> hospitalId,
      Value<int> rowid,
    });
typedef $$ImportedLabResultsTableUpdateCompanionBuilder =
    ImportedLabResultsCompanion Function({
      Value<String> id,
      Value<String> fileName,
      Value<String> reportId,
      Value<String> sampleDateRaw,
      Value<DateTime> sampleDate,
      Value<String> reportDateRaw,
      Value<String> indicatorCode,
      Value<String> indicatorNameCn,
      Value<String> rawValue,
      Value<double?> numericValue,
      Value<String> unit,
      Value<String> referenceRange,
      Value<String> category,
      Value<DateTime> importedAt,
      Value<String?> originalSnapshot,
      Value<String?> note,
      Value<DateTime?> editedAt,
      Value<DateTime?> deletedAt,
      Value<String?> hospitalId,
      Value<int> rowid,
    });

final class $$ImportedLabResultsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ImportedLabResultsTable,
          ImportedLabResult
        > {
  $$ImportedLabResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HospitalsTable _hospitalIdTable(_$AppDatabase db) => db.hospitals
      .createAlias('imported_lab_results__hospital_id__hospitals__id');

  $$HospitalsTableProcessedTableManager? get hospitalId {
    final $_column = $_itemColumn<String>('hospital_id');
    if ($_column == null) return null;
    final manager = $$HospitalsTableTableManager(
      $_db,
      $_db.hospitals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hospitalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ImportedLabResultsTableFilterComposer
    extends Composer<_$AppDatabase, $ImportedLabResultsTable> {
  $$ImportedLabResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportId => $composableBuilder(
    column: $table.reportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sampleDateRaw => $composableBuilder(
    column: $table.sampleDateRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sampleDate => $composableBuilder(
    column: $table.sampleDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportDateRaw => $composableBuilder(
    column: $table.reportDateRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get indicatorCode => $composableBuilder(
    column: $table.indicatorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get indicatorNameCn => $composableBuilder(
    column: $table.indicatorNameCn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawValue => $composableBuilder(
    column: $table.rawValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get numericValue => $composableBuilder(
    column: $table.numericValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceRange => $composableBuilder(
    column: $table.referenceRange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalSnapshot => $composableBuilder(
    column: $table.originalSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get editedAt => $composableBuilder(
    column: $table.editedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HospitalsTableFilterComposer get hospitalId {
    final $$HospitalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hospitalId,
      referencedTable: $db.hospitals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HospitalsTableFilterComposer(
            $db: $db,
            $table: $db.hospitals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportedLabResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportedLabResultsTable> {
  $$ImportedLabResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportId => $composableBuilder(
    column: $table.reportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sampleDateRaw => $composableBuilder(
    column: $table.sampleDateRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sampleDate => $composableBuilder(
    column: $table.sampleDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportDateRaw => $composableBuilder(
    column: $table.reportDateRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get indicatorCode => $composableBuilder(
    column: $table.indicatorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get indicatorNameCn => $composableBuilder(
    column: $table.indicatorNameCn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawValue => $composableBuilder(
    column: $table.rawValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get numericValue => $composableBuilder(
    column: $table.numericValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceRange => $composableBuilder(
    column: $table.referenceRange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalSnapshot => $composableBuilder(
    column: $table.originalSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get editedAt => $composableBuilder(
    column: $table.editedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HospitalsTableOrderingComposer get hospitalId {
    final $$HospitalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hospitalId,
      referencedTable: $db.hospitals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HospitalsTableOrderingComposer(
            $db: $db,
            $table: $db.hospitals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportedLabResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportedLabResultsTable> {
  $$ImportedLabResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get reportId =>
      $composableBuilder(column: $table.reportId, builder: (column) => column);

  GeneratedColumn<String> get sampleDateRaw => $composableBuilder(
    column: $table.sampleDateRaw,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sampleDate => $composableBuilder(
    column: $table.sampleDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reportDateRaw => $composableBuilder(
    column: $table.reportDateRaw,
    builder: (column) => column,
  );

  GeneratedColumn<String> get indicatorCode => $composableBuilder(
    column: $table.indicatorCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get indicatorNameCn => $composableBuilder(
    column: $table.indicatorNameCn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawValue =>
      $composableBuilder(column: $table.rawValue, builder: (column) => column);

  GeneratedColumn<double> get numericValue => $composableBuilder(
    column: $table.numericValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get referenceRange => $composableBuilder(
    column: $table.referenceRange,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalSnapshot => $composableBuilder(
    column: $table.originalSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get editedAt =>
      $composableBuilder(column: $table.editedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$HospitalsTableAnnotationComposer get hospitalId {
    final $$HospitalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hospitalId,
      referencedTable: $db.hospitals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HospitalsTableAnnotationComposer(
            $db: $db,
            $table: $db.hospitals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportedLabResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportedLabResultsTable,
          ImportedLabResult,
          $$ImportedLabResultsTableFilterComposer,
          $$ImportedLabResultsTableOrderingComposer,
          $$ImportedLabResultsTableAnnotationComposer,
          $$ImportedLabResultsTableCreateCompanionBuilder,
          $$ImportedLabResultsTableUpdateCompanionBuilder,
          (ImportedLabResult, $$ImportedLabResultsTableReferences),
          ImportedLabResult,
          PrefetchHooks Function({bool hospitalId})
        > {
  $$ImportedLabResultsTableTableManager(
    _$AppDatabase db,
    $ImportedLabResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportedLabResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportedLabResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportedLabResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> reportId = const Value.absent(),
                Value<String> sampleDateRaw = const Value.absent(),
                Value<DateTime> sampleDate = const Value.absent(),
                Value<String> reportDateRaw = const Value.absent(),
                Value<String> indicatorCode = const Value.absent(),
                Value<String> indicatorNameCn = const Value.absent(),
                Value<String> rawValue = const Value.absent(),
                Value<double?> numericValue = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> referenceRange = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<String?> originalSnapshot = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime?> editedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> hospitalId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportedLabResultsCompanion(
                id: id,
                fileName: fileName,
                reportId: reportId,
                sampleDateRaw: sampleDateRaw,
                sampleDate: sampleDate,
                reportDateRaw: reportDateRaw,
                indicatorCode: indicatorCode,
                indicatorNameCn: indicatorNameCn,
                rawValue: rawValue,
                numericValue: numericValue,
                unit: unit,
                referenceRange: referenceRange,
                category: category,
                importedAt: importedAt,
                originalSnapshot: originalSnapshot,
                note: note,
                editedAt: editedAt,
                deletedAt: deletedAt,
                hospitalId: hospitalId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fileName,
                required String reportId,
                required String sampleDateRaw,
                required DateTime sampleDate,
                required String reportDateRaw,
                required String indicatorCode,
                required String indicatorNameCn,
                required String rawValue,
                Value<double?> numericValue = const Value.absent(),
                required String unit,
                required String referenceRange,
                required String category,
                required DateTime importedAt,
                Value<String?> originalSnapshot = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime?> editedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> hospitalId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportedLabResultsCompanion.insert(
                id: id,
                fileName: fileName,
                reportId: reportId,
                sampleDateRaw: sampleDateRaw,
                sampleDate: sampleDate,
                reportDateRaw: reportDateRaw,
                indicatorCode: indicatorCode,
                indicatorNameCn: indicatorNameCn,
                rawValue: rawValue,
                numericValue: numericValue,
                unit: unit,
                referenceRange: referenceRange,
                category: category,
                importedAt: importedAt,
                originalSnapshot: originalSnapshot,
                note: note,
                editedAt: editedAt,
                deletedAt: deletedAt,
                hospitalId: hospitalId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImportedLabResultsTable, ImportedLabResult>(
                    table,
                  ),
                  $$ImportedLabResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({hospitalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (hospitalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.hospitalId,
                        referencedTable: $$ImportedLabResultsTableReferences
                            ._hospitalIdTable(db),
                        referencedColumn: $$ImportedLabResultsTableReferences
                            ._hospitalIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ImportedLabResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportedLabResultsTable,
      ImportedLabResult,
      $$ImportedLabResultsTableFilterComposer,
      $$ImportedLabResultsTableOrderingComposer,
      $$ImportedLabResultsTableAnnotationComposer,
      $$ImportedLabResultsTableCreateCompanionBuilder,
      $$ImportedLabResultsTableUpdateCompanionBuilder,
      (ImportedLabResult, $$ImportedLabResultsTableReferences),
      ImportedLabResult,
      PrefetchHooks Function({bool hospitalId})
    >;
typedef $$VisitsTableCreateCompanionBuilder = VisitsCompanion Function({
  required String id,
  required String hospitalId,
  required String visitType,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<String?> department,
  Value<String?> doctor,
  Value<String?> reason,
  Value<String?> diagnosis,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$VisitsTableUpdateCompanionBuilder = VisitsCompanion Function({
  Value<String> id,
  Value<String> hospitalId,
  Value<String> visitType,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<String?> department,
  Value<String?> doctor,
  Value<String?> reason,
  Value<String?> diagnosis,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$VisitsTableReferences
    extends BaseReferences<_$AppDatabase, $VisitsTable, Visit> {
  $$VisitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HospitalsTable _hospitalIdTable(_$AppDatabase db) =>
      db.hospitals.createAlias('visits__hospital_id__hospitals__id');

  $$HospitalsTableProcessedTableManager get hospitalId {
    final $_column = $_itemColumn<String>('hospital_id')!;

    final manager = $$HospitalsTableTableManager(
      $_db,
      $_db.hospitals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hospitalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VisitReportsTable, List<VisitReport>>
  _visitReportsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.visitReports,
    aliasName: 'visits__id__visit_reports__visit_id',
  );

  $$VisitReportsTableProcessedTableManager get visitReportsRefs {
    final manager = $$VisitReportsTableTableManager(
      $_db,
      $_db.visitReports,
    ).filter((f) => f.visitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_visitReportsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VisitsTableFilterComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitType => $composableBuilder(
    column: $table.visitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctor => $composableBuilder(
    column: $table.doctor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HospitalsTableFilterComposer get hospitalId {
    final $$HospitalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hospitalId,
      referencedTable: $db.hospitals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HospitalsTableFilterComposer(
            $db: $db,
            $table: $db.hospitals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> visitReportsRefs(
    Expression<bool> Function($$VisitReportsTableFilterComposer f) f,
  ) {
    final $$VisitReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visitReports,
      getReferencedColumn: (t) => t.visitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitReportsTableFilterComposer(
            $db: $db,
            $table: $db.visitReports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VisitsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitType => $composableBuilder(
    column: $table.visitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctor => $composableBuilder(
    column: $table.doctor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HospitalsTableOrderingComposer get hospitalId {
    final $$HospitalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hospitalId,
      referencedTable: $db.hospitals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HospitalsTableOrderingComposer(
            $db: $db,
            $table: $db.hospitals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get visitType =>
      $composableBuilder(column: $table.visitType, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctor =>
      $composableBuilder(column: $table.doctor, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get diagnosis =>
      $composableBuilder(column: $table.diagnosis, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HospitalsTableAnnotationComposer get hospitalId {
    final $$HospitalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hospitalId,
      referencedTable: $db.hospitals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HospitalsTableAnnotationComposer(
            $db: $db,
            $table: $db.hospitals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> visitReportsRefs<T extends Object>(
    Expression<T> Function($$VisitReportsTableAnnotationComposer a) f,
  ) {
    final $$VisitReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visitReports,
      getReferencedColumn: (t) => t.visitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.visitReports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VisitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitsTable,
          Visit,
          $$VisitsTableFilterComposer,
          $$VisitsTableOrderingComposer,
          $$VisitsTableAnnotationComposer,
          $$VisitsTableCreateCompanionBuilder,
          $$VisitsTableUpdateCompanionBuilder,
          (Visit, $$VisitsTableReferences),
          Visit,
          PrefetchHooks Function({bool hospitalId, bool visitReportsRefs})
        > {
  $$VisitsTableTableManager(_$AppDatabase db, $VisitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> hospitalId = const Value.absent(),
                Value<String> visitType = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<String?> doctor = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitsCompanion(
                id: id,
                hospitalId: hospitalId,
                visitType: visitType,
                startDate: startDate,
                endDate: endDate,
                department: department,
                doctor: doctor,
                reason: reason,
                diagnosis: diagnosis,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String hospitalId,
                required String visitType,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<String?> doctor = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => VisitsCompanion.insert(
                id: id,
                hospitalId: hospitalId,
                visitType: visitType,
                startDate: startDate,
                endDate: endDate,
                department: department,
                doctor: doctor,
                reason: reason,
                diagnosis: diagnosis,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VisitsTable, Visit>(table),
                  $$VisitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({hospitalId = false, visitReportsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (visitReportsRefs) db.visitReports,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (hospitalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.hospitalId,
                            referencedTable: $$VisitsTableReferences
                                ._hospitalIdTable(db),
                            referencedColumn: $$VisitsTableReferences
                                ._hospitalIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (visitReportsRefs)
                        await $_getPrefetchedData<
                          Visit,
                          $VisitsTable,
                          VisitReport
                        >(
                          currentTable: table,
                          referencedTable: $$VisitsTableReferences
                              ._visitReportsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VisitsTableReferences(
                                db,
                                table,
                                p0,
                              ).visitReportsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.visitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VisitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitsTable,
      Visit,
      $$VisitsTableFilterComposer,
      $$VisitsTableOrderingComposer,
      $$VisitsTableAnnotationComposer,
      $$VisitsTableCreateCompanionBuilder,
      $$VisitsTableUpdateCompanionBuilder,
      (Visit, $$VisitsTableReferences),
      Visit,
      PrefetchHooks Function({bool hospitalId, bool visitReportsRefs})
    >;
typedef $$VisitReportsTableCreateCompanionBuilder =
    VisitReportsCompanion Function({
      required String id,
      required String visitId,
      required String title,
      required DateTime reportDate,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$VisitReportsTableUpdateCompanionBuilder =
    VisitReportsCompanion Function({
      Value<String> id,
      Value<String> visitId,
      Value<String> title,
      Value<DateTime> reportDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$VisitReportsTableReferences
    extends BaseReferences<_$AppDatabase, $VisitReportsTable, VisitReport> {
  $$VisitReportsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VisitsTable _visitIdTable(_$AppDatabase db) =>
      db.visits.createAlias('visit_reports__visit_id__visits__id');

  $$VisitsTableProcessedTableManager get visitId {
    final $_column = $_itemColumn<String>('visit_id')!;

    final manager = $$VisitsTableTableManager(
      $_db,
      $_db.visits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_visitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReportResultLinksTable, List<ReportResultLink>>
  _reportResultLinksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.reportResultLinks,
        aliasName: 'visit_reports__id__report_result_links__report_id',
      );

  $$ReportResultLinksTableProcessedTableManager get reportResultLinksRefs {
    final manager = $$ReportResultLinksTableTableManager(
      $_db,
      $_db.reportResultLinks,
    ).filter((f) => f.reportId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reportResultLinksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VisitReportsTableFilterComposer
    extends Composer<_$AppDatabase, $VisitReportsTable> {
  $$VisitReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reportDate => $composableBuilder(
    column: $table.reportDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VisitsTableFilterComposer get visitId {
    final $$VisitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visitId,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableFilterComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reportResultLinksRefs(
    Expression<bool> Function($$ReportResultLinksTableFilterComposer f) f,
  ) {
    final $$ReportResultLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reportResultLinks,
      getReferencedColumn: (t) => t.reportId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportResultLinksTableFilterComposer(
            $db: $db,
            $table: $db.reportResultLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VisitReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitReportsTable> {
  $$VisitReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reportDate => $composableBuilder(
    column: $table.reportDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VisitsTableOrderingComposer get visitId {
    final $$VisitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visitId,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableOrderingComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitReportsTable> {
  $$VisitReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get reportDate => $composableBuilder(
    column: $table.reportDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VisitsTableAnnotationComposer get visitId {
    final $$VisitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visitId,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableAnnotationComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reportResultLinksRefs<T extends Object>(
    Expression<T> Function($$ReportResultLinksTableAnnotationComposer a) f,
  ) {
    final $$ReportResultLinksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.reportResultLinks,
          getReferencedColumn: (t) => t.reportId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReportResultLinksTableAnnotationComposer(
                $db: $db,
                $table: $db.reportResultLinks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$VisitReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitReportsTable,
          VisitReport,
          $$VisitReportsTableFilterComposer,
          $$VisitReportsTableOrderingComposer,
          $$VisitReportsTableAnnotationComposer,
          $$VisitReportsTableCreateCompanionBuilder,
          $$VisitReportsTableUpdateCompanionBuilder,
          (VisitReport, $$VisitReportsTableReferences),
          VisitReport,
          PrefetchHooks Function({bool visitId, bool reportResultLinksRefs})
        > {
  $$VisitReportsTableTableManager(_$AppDatabase db, $VisitReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> visitId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> reportDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitReportsCompanion(
                id: id,
                visitId: visitId,
                title: title,
                reportDate: reportDate,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String visitId,
                required String title,
                required DateTime reportDate,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => VisitReportsCompanion.insert(
                id: id,
                visitId: visitId,
                title: title,
                reportDate: reportDate,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VisitReportsTable, VisitReport>(table),
                  $$VisitReportsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({visitId = false, reportResultLinksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (reportResultLinksRefs) db.reportResultLinks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (visitId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.visitId,
                            referencedTable: $$VisitReportsTableReferences
                                ._visitIdTable(db),
                            referencedColumn: $$VisitReportsTableReferences
                                ._visitIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reportResultLinksRefs)
                        await $_getPrefetchedData<
                          VisitReport,
                          $VisitReportsTable,
                          ReportResultLink
                        >(
                          currentTable: table,
                          referencedTable: $$VisitReportsTableReferences
                              ._reportResultLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VisitReportsTableReferences(
                                db,
                                table,
                                p0,
                              ).reportResultLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.reportId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VisitReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitReportsTable,
      VisitReport,
      $$VisitReportsTableFilterComposer,
      $$VisitReportsTableOrderingComposer,
      $$VisitReportsTableAnnotationComposer,
      $$VisitReportsTableCreateCompanionBuilder,
      $$VisitReportsTableUpdateCompanionBuilder,
      (VisitReport, $$VisitReportsTableReferences),
      VisitReport,
      PrefetchHooks Function({bool visitId, bool reportResultLinksRefs})
    >;
typedef $$ReportResultLinksTableCreateCompanionBuilder =
    ReportResultLinksCompanion Function({
      required String reportId,
      required String sourceKind,
      required String resultId,
      Value<int> rowid,
    });
typedef $$ReportResultLinksTableUpdateCompanionBuilder =
    ReportResultLinksCompanion Function({
      Value<String> reportId,
      Value<String> sourceKind,
      Value<String> resultId,
      Value<int> rowid,
    });

final class $$ReportResultLinksTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReportResultLinksTable,
          ReportResultLink
        > {
  $$ReportResultLinksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VisitReportsTable _reportIdTable(_$AppDatabase db) => db.visitReports
      .createAlias('report_result_links__report_id__visit_reports__id');

  $$VisitReportsTableProcessedTableManager get reportId {
    final $_column = $_itemColumn<String>('report_id')!;

    final manager = $$VisitReportsTableTableManager(
      $_db,
      $_db.visitReports,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reportIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReportResultLinksTableFilterComposer
    extends Composer<_$AppDatabase, $ReportResultLinksTable> {
  $$ReportResultLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultId => $composableBuilder(
    column: $table.resultId,
    builder: (column) => ColumnFilters(column),
  );

  $$VisitReportsTableFilterComposer get reportId {
    final $$VisitReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.visitReports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitReportsTableFilterComposer(
            $db: $db,
            $table: $db.visitReports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportResultLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportResultLinksTable> {
  $$ReportResultLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultId => $composableBuilder(
    column: $table.resultId,
    builder: (column) => ColumnOrderings(column),
  );

  $$VisitReportsTableOrderingComposer get reportId {
    final $$VisitReportsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.visitReports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitReportsTableOrderingComposer(
            $db: $db,
            $table: $db.visitReports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportResultLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportResultLinksTable> {
  $$ReportResultLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultId =>
      $composableBuilder(column: $table.resultId, builder: (column) => column);

  $$VisitReportsTableAnnotationComposer get reportId {
    final $$VisitReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.visitReports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.visitReports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportResultLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportResultLinksTable,
          ReportResultLink,
          $$ReportResultLinksTableFilterComposer,
          $$ReportResultLinksTableOrderingComposer,
          $$ReportResultLinksTableAnnotationComposer,
          $$ReportResultLinksTableCreateCompanionBuilder,
          $$ReportResultLinksTableUpdateCompanionBuilder,
          (ReportResultLink, $$ReportResultLinksTableReferences),
          ReportResultLink,
          PrefetchHooks Function({bool reportId})
        > {
  $$ReportResultLinksTableTableManager(
    _$AppDatabase db,
    $ReportResultLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportResultLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportResultLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportResultLinksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> reportId = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
                Value<String> resultId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportResultLinksCompanion(
                reportId: reportId,
                sourceKind: sourceKind,
                resultId: resultId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String reportId,
                required String sourceKind,
                required String resultId,
                Value<int> rowid = const Value.absent(),
              }) => ReportResultLinksCompanion.insert(
                reportId: reportId,
                sourceKind: sourceKind,
                resultId: resultId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReportResultLinksTable, ReportResultLink>(table),
                  $$ReportResultLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reportId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (reportId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.reportId,
                        referencedTable: $$ReportResultLinksTableReferences
                            ._reportIdTable(db),
                        referencedColumn: $$ReportResultLinksTableReferences
                            ._reportIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReportResultLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportResultLinksTable,
      ReportResultLink,
      $$ReportResultLinksTableFilterComposer,
      $$ReportResultLinksTableOrderingComposer,
      $$ReportResultLinksTableAnnotationComposer,
      $$ReportResultLinksTableCreateCompanionBuilder,
      $$ReportResultLinksTableUpdateCompanionBuilder,
      (ReportResultLink, $$ReportResultLinksTableReferences),
      ReportResultLink,
      PrefetchHooks Function({bool reportId})
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      required String id,
      required String name,
      Value<String?> strength,
      Value<String?> form,
      Value<String?> purpose,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> strength,
      Value<String?> form,
      Value<String?> purpose,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicationPlansTable, List<MedicationPlan>>
  _medicationPlansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicationPlans,
    aliasName: 'medications__id__medication_plans__medication_id',
  );

  $$MedicationPlansTableProcessedTableManager get medicationPlansRefs {
    final manager = $$MedicationPlansTableTableManager(
      $_db,
      $_db.medicationPlans,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _medicationPlansRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> medicationPlansRefs(
    Expression<bool> Function($$MedicationPlansTableFilterComposer f) f,
  ) {
    final $$MedicationPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationPlans,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationPlansTableFilterComposer(
            $db: $db,
            $table: $db.medicationPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> medicationPlansRefs<T extends Object>(
    Expression<T> Function($$MedicationPlansTableAnnotationComposer a) f,
  ) {
    final $$MedicationPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationPlans,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          Medication,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (Medication, $$MedicationsTableReferences),
          Medication,
          PrefetchHooks Function({bool medicationPlansRefs})
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> strength = const Value.absent(),
                Value<String?> form = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                name: name,
                strength: strength,
                form: form,
                purpose: purpose,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> strength = const Value.absent(),
                Value<String?> form = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                name: name,
                strength: strength,
                form: form,
                purpose: purpose,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationsTable, Medication>(table),
                  $$MedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationPlansRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicationPlansRefs) db.medicationPlans,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicationPlansRefs)
                    await $_getPrefetchedData<
                      Medication,
                      $MedicationsTable,
                      MedicationPlan
                    >(
                      currentTable: table,
                      referencedTable: $$MedicationsTableReferences
                          ._medicationPlansRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MedicationsTableReferences(
                            db,
                            table,
                            p0,
                          ).medicationPlansRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.medicationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      Medication,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (Medication, $$MedicationsTableReferences),
      Medication,
      PrefetchHooks Function({bool medicationPlansRefs})
    >;
typedef $$MedicationPlansTableCreateCompanionBuilder =
    MedicationPlansCompanion Function({
      required String id,
      required String medicationId,
      required String dose,
      required String frequency,
      Value<String?> times,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<String?> changeReason,
      Value<String?> instructions,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MedicationPlansTableUpdateCompanionBuilder =
    MedicationPlansCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<String> dose,
      Value<String> frequency,
      Value<String?> times,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<String?> changeReason,
      Value<String?> instructions,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$MedicationPlansTableReferences
    extends
        BaseReferences<_$AppDatabase, $MedicationPlansTable, MedicationPlan> {
  $$MedicationPlansTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) => db
      .medications
      .createAlias('medication_plans__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationPlansTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationPlansTable> {
  $$MedicationPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get times => $composableBuilder(
    column: $table.times,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changeReason => $composableBuilder(
    column: $table.changeReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationPlansTable> {
  $$MedicationPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get times => $composableBuilder(
    column: $table.times,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changeReason => $composableBuilder(
    column: $table.changeReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationPlansTable> {
  $$MedicationPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get times =>
      $composableBuilder(column: $table.times, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get changeReason => $composableBuilder(
    column: $table.changeReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationPlansTable,
          MedicationPlan,
          $$MedicationPlansTableFilterComposer,
          $$MedicationPlansTableOrderingComposer,
          $$MedicationPlansTableAnnotationComposer,
          $$MedicationPlansTableCreateCompanionBuilder,
          $$MedicationPlansTableUpdateCompanionBuilder,
          (MedicationPlan, $$MedicationPlansTableReferences),
          MedicationPlan,
          PrefetchHooks Function({bool medicationId})
        > {
  $$MedicationPlansTableTableManager(
    _$AppDatabase db,
    $MedicationPlansTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String> dose = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String?> times = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<String?> changeReason = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationPlansCompanion(
                id: id,
                medicationId: medicationId,
                dose: dose,
                frequency: frequency,
                times: times,
                startDate: startDate,
                endDate: endDate,
                changeReason: changeReason,
                instructions: instructions,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required String dose,
                required String frequency,
                Value<String?> times = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<String?> changeReason = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicationPlansCompanion.insert(
                id: id,
                medicationId: medicationId,
                dose: dose,
                frequency: frequency,
                times: times,
                startDate: startDate,
                endDate: endDate,
                changeReason: changeReason,
                instructions: instructions,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationPlansTable, MedicationPlan>(table),
                  $$MedicationPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicationId,
                        referencedTable: $$MedicationPlansTableReferences
                            ._medicationIdTable(db),
                        referencedColumn: $$MedicationPlansTableReferences
                            ._medicationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicationPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationPlansTable,
      MedicationPlan,
      $$MedicationPlansTableFilterComposer,
      $$MedicationPlansTableOrderingComposer,
      $$MedicationPlansTableAnnotationComposer,
      $$MedicationPlansTableCreateCompanionBuilder,
      $$MedicationPlansTableUpdateCompanionBuilder,
      (MedicationPlan, $$MedicationPlansTableReferences),
      MedicationPlan,
      PrefetchHooks Function({bool medicationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LabCategoriesTableTableManager get labCategories =>
      $$LabCategoriesTableTableManager(_db, _db.labCategories);
  $$LabTestsTableTableManager get labTests =>
      $$LabTestsTableTableManager(_db, _db.labTests);
  $$LabResultsTableTableManager get labResults =>
      $$LabResultsTableTableManager(_db, _db.labResults);
  $$HospitalsTableTableManager get hospitals =>
      $$HospitalsTableTableManager(_db, _db.hospitals);
  $$ImportedLabResultsTableTableManager get importedLabResults =>
      $$ImportedLabResultsTableTableManager(_db, _db.importedLabResults);
  $$VisitsTableTableManager get visits =>
      $$VisitsTableTableManager(_db, _db.visits);
  $$VisitReportsTableTableManager get visitReports =>
      $$VisitReportsTableTableManager(_db, _db.visitReports);
  $$ReportResultLinksTableTableManager get reportResultLinks =>
      $$ReportResultLinksTableTableManager(_db, _db.reportResultLinks);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicationPlansTableTableManager get medicationPlans =>
      $$MedicationPlansTableTableManager(_db, _db.medicationPlans);
}
