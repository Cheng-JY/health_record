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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LabCategoriesTable labCategories = $LabCategoriesTable(this);
  late final $LabTestsTable labTests = $LabTestsTable(this);
  late final $LabResultsTable labResults = $LabResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    labCategories,
    labTests,
    labResults,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LabCategoriesTableTableManager get labCategories =>
      $$LabCategoriesTableTableManager(_db, _db.labCategories);
  $$LabTestsTableTableManager get labTests =>
      $$LabTestsTableTableManager(_db, _db.labTests);
  $$LabResultsTableTableManager get labResults =>
      $$LabResultsTableTableManager(_db, _db.labResults);
}
