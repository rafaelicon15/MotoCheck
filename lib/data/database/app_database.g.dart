// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FuelRecordsTable extends FuelRecords
    with TableInfo<$FuelRecordsTable, FuelRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _motoIdMeta = const VerificationMeta('motoId');
  @override
  late final GeneratedColumn<int> motoId = GeneratedColumn<int>(
    'moto_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _litersMeta = const VerificationMeta('liters');
  @override
  late final GeneratedColumn<double> liters = GeneratedColumn<double>(
    'liters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerLiterMeta = const VerificationMeta(
    'pricePerLiter',
  );
  @override
  late final GeneratedColumn<double> pricePerLiter = GeneratedColumn<double>(
    'price_per_liter',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _odometerKmMeta = const VerificationMeta(
    'odometerKm',
  );
  @override
  late final GeneratedColumn<int> odometerKm = GeneratedColumn<int>(
    'odometer_km',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelTypeMeta = const VerificationMeta(
    'fuelType',
  );
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
    'fuel_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usedOctaneBoosterMeta = const VerificationMeta(
    'usedOctaneBooster',
  );
  @override
  late final GeneratedColumn<bool> usedOctaneBooster = GeneratedColumn<bool>(
    'used_octane_booster',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("used_octane_booster" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _octaneBrandMeta = const VerificationMeta(
    'octaneBrand',
  );
  @override
  late final GeneratedColumn<String> octaneBrand = GeneratedColumn<String>(
    'octane_brand',
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
  static const VerificationMeta _isFullMeta = const VerificationMeta('isFull');
  @override
  late final GeneratedColumn<bool> isFull = GeneratedColumn<bool>(
    'is_full',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_full" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    motoId,
    date,
    liters,
    pricePerLiter,
    odometerKm,
    fuelType,
    usedOctaneBooster,
    octaneBrand,
    notes,
    isFull,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuel_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<FuelRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('moto_id')) {
      context.handle(
        _motoIdMeta,
        motoId.isAcceptableOrUnknown(data['moto_id']!, _motoIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('liters')) {
      context.handle(
        _litersMeta,
        liters.isAcceptableOrUnknown(data['liters']!, _litersMeta),
      );
    } else if (isInserting) {
      context.missing(_litersMeta);
    }
    if (data.containsKey('price_per_liter')) {
      context.handle(
        _pricePerLiterMeta,
        pricePerLiter.isAcceptableOrUnknown(
          data['price_per_liter']!,
          _pricePerLiterMeta,
        ),
      );
    }
    if (data.containsKey('odometer_km')) {
      context.handle(
        _odometerKmMeta,
        odometerKm.isAcceptableOrUnknown(data['odometer_km']!, _odometerKmMeta),
      );
    } else if (isInserting) {
      context.missing(_odometerKmMeta);
    }
    if (data.containsKey('fuel_type')) {
      context.handle(
        _fuelTypeMeta,
        fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelTypeMeta);
    }
    if (data.containsKey('used_octane_booster')) {
      context.handle(
        _usedOctaneBoosterMeta,
        usedOctaneBooster.isAcceptableOrUnknown(
          data['used_octane_booster']!,
          _usedOctaneBoosterMeta,
        ),
      );
    }
    if (data.containsKey('octane_brand')) {
      context.handle(
        _octaneBrandMeta,
        octaneBrand.isAcceptableOrUnknown(
          data['octane_brand']!,
          _octaneBrandMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_full')) {
      context.handle(
        _isFullMeta,
        isFull.isAcceptableOrUnknown(data['is_full']!, _isFullMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FuelRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuelRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      motoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moto_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      liters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}liters'],
      )!,
      pricePerLiter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_liter'],
      ),
      odometerKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometer_km'],
      )!,
      fuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_type'],
      )!,
      usedOctaneBooster: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}used_octane_booster'],
      )!,
      octaneBrand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}octane_brand'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isFull: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_full'],
      )!,
    );
  }

  @override
  $FuelRecordsTable createAlias(String alias) {
    return $FuelRecordsTable(attachedDatabase, alias);
  }
}

class FuelRecord extends DataClass implements Insertable<FuelRecord> {
  final int id;
  final int? motoId;
  final DateTime date;
  final double liters;
  final double? pricePerLiter;
  final int odometerKm;
  final String fuelType;
  final bool usedOctaneBooster;
  final String? octaneBrand;
  final String? notes;
  final bool isFull;
  const FuelRecord({
    required this.id,
    this.motoId,
    required this.date,
    required this.liters,
    this.pricePerLiter,
    required this.odometerKm,
    required this.fuelType,
    required this.usedOctaneBooster,
    this.octaneBrand,
    this.notes,
    required this.isFull,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || motoId != null) {
      map['moto_id'] = Variable<int>(motoId);
    }
    map['date'] = Variable<DateTime>(date);
    map['liters'] = Variable<double>(liters);
    if (!nullToAbsent || pricePerLiter != null) {
      map['price_per_liter'] = Variable<double>(pricePerLiter);
    }
    map['odometer_km'] = Variable<int>(odometerKm);
    map['fuel_type'] = Variable<String>(fuelType);
    map['used_octane_booster'] = Variable<bool>(usedOctaneBooster);
    if (!nullToAbsent || octaneBrand != null) {
      map['octane_brand'] = Variable<String>(octaneBrand);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_full'] = Variable<bool>(isFull);
    return map;
  }

  FuelRecordsCompanion toCompanion(bool nullToAbsent) {
    return FuelRecordsCompanion(
      id: Value(id),
      motoId: motoId == null && nullToAbsent
          ? const Value.absent()
          : Value(motoId),
      date: Value(date),
      liters: Value(liters),
      pricePerLiter: pricePerLiter == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerLiter),
      odometerKm: Value(odometerKm),
      fuelType: Value(fuelType),
      usedOctaneBooster: Value(usedOctaneBooster),
      octaneBrand: octaneBrand == null && nullToAbsent
          ? const Value.absent()
          : Value(octaneBrand),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isFull: Value(isFull),
    );
  }

  factory FuelRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuelRecord(
      id: serializer.fromJson<int>(json['id']),
      motoId: serializer.fromJson<int?>(json['motoId']),
      date: serializer.fromJson<DateTime>(json['date']),
      liters: serializer.fromJson<double>(json['liters']),
      pricePerLiter: serializer.fromJson<double?>(json['pricePerLiter']),
      odometerKm: serializer.fromJson<int>(json['odometerKm']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      usedOctaneBooster: serializer.fromJson<bool>(json['usedOctaneBooster']),
      octaneBrand: serializer.fromJson<String?>(json['octaneBrand']),
      notes: serializer.fromJson<String?>(json['notes']),
      isFull: serializer.fromJson<bool>(json['isFull']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motoId': serializer.toJson<int?>(motoId),
      'date': serializer.toJson<DateTime>(date),
      'liters': serializer.toJson<double>(liters),
      'pricePerLiter': serializer.toJson<double?>(pricePerLiter),
      'odometerKm': serializer.toJson<int>(odometerKm),
      'fuelType': serializer.toJson<String>(fuelType),
      'usedOctaneBooster': serializer.toJson<bool>(usedOctaneBooster),
      'octaneBrand': serializer.toJson<String?>(octaneBrand),
      'notes': serializer.toJson<String?>(notes),
      'isFull': serializer.toJson<bool>(isFull),
    };
  }

  FuelRecord copyWith({
    int? id,
    Value<int?> motoId = const Value.absent(),
    DateTime? date,
    double? liters,
    Value<double?> pricePerLiter = const Value.absent(),
    int? odometerKm,
    String? fuelType,
    bool? usedOctaneBooster,
    Value<String?> octaneBrand = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isFull,
  }) => FuelRecord(
    id: id ?? this.id,
    motoId: motoId.present ? motoId.value : this.motoId,
    date: date ?? this.date,
    liters: liters ?? this.liters,
    pricePerLiter: pricePerLiter.present
        ? pricePerLiter.value
        : this.pricePerLiter,
    odometerKm: odometerKm ?? this.odometerKm,
    fuelType: fuelType ?? this.fuelType,
    usedOctaneBooster: usedOctaneBooster ?? this.usedOctaneBooster,
    octaneBrand: octaneBrand.present ? octaneBrand.value : this.octaneBrand,
    notes: notes.present ? notes.value : this.notes,
    isFull: isFull ?? this.isFull,
  );
  FuelRecord copyWithCompanion(FuelRecordsCompanion data) {
    return FuelRecord(
      id: data.id.present ? data.id.value : this.id,
      motoId: data.motoId.present ? data.motoId.value : this.motoId,
      date: data.date.present ? data.date.value : this.date,
      liters: data.liters.present ? data.liters.value : this.liters,
      pricePerLiter: data.pricePerLiter.present
          ? data.pricePerLiter.value
          : this.pricePerLiter,
      odometerKm: data.odometerKm.present
          ? data.odometerKm.value
          : this.odometerKm,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      usedOctaneBooster: data.usedOctaneBooster.present
          ? data.usedOctaneBooster.value
          : this.usedOctaneBooster,
      octaneBrand: data.octaneBrand.present
          ? data.octaneBrand.value
          : this.octaneBrand,
      notes: data.notes.present ? data.notes.value : this.notes,
      isFull: data.isFull.present ? data.isFull.value : this.isFull,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuelRecord(')
          ..write('id: $id, ')
          ..write('motoId: $motoId, ')
          ..write('date: $date, ')
          ..write('liters: $liters, ')
          ..write('pricePerLiter: $pricePerLiter, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('fuelType: $fuelType, ')
          ..write('usedOctaneBooster: $usedOctaneBooster, ')
          ..write('octaneBrand: $octaneBrand, ')
          ..write('notes: $notes, ')
          ..write('isFull: $isFull')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    motoId,
    date,
    liters,
    pricePerLiter,
    odometerKm,
    fuelType,
    usedOctaneBooster,
    octaneBrand,
    notes,
    isFull,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuelRecord &&
          other.id == this.id &&
          other.motoId == this.motoId &&
          other.date == this.date &&
          other.liters == this.liters &&
          other.pricePerLiter == this.pricePerLiter &&
          other.odometerKm == this.odometerKm &&
          other.fuelType == this.fuelType &&
          other.usedOctaneBooster == this.usedOctaneBooster &&
          other.octaneBrand == this.octaneBrand &&
          other.notes == this.notes &&
          other.isFull == this.isFull);
}

class FuelRecordsCompanion extends UpdateCompanion<FuelRecord> {
  final Value<int> id;
  final Value<int?> motoId;
  final Value<DateTime> date;
  final Value<double> liters;
  final Value<double?> pricePerLiter;
  final Value<int> odometerKm;
  final Value<String> fuelType;
  final Value<bool> usedOctaneBooster;
  final Value<String?> octaneBrand;
  final Value<String?> notes;
  final Value<bool> isFull;
  const FuelRecordsCompanion({
    this.id = const Value.absent(),
    this.motoId = const Value.absent(),
    this.date = const Value.absent(),
    this.liters = const Value.absent(),
    this.pricePerLiter = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.usedOctaneBooster = const Value.absent(),
    this.octaneBrand = const Value.absent(),
    this.notes = const Value.absent(),
    this.isFull = const Value.absent(),
  });
  FuelRecordsCompanion.insert({
    this.id = const Value.absent(),
    this.motoId = const Value.absent(),
    required DateTime date,
    required double liters,
    this.pricePerLiter = const Value.absent(),
    required int odometerKm,
    required String fuelType,
    this.usedOctaneBooster = const Value.absent(),
    this.octaneBrand = const Value.absent(),
    this.notes = const Value.absent(),
    this.isFull = const Value.absent(),
  }) : date = Value(date),
       liters = Value(liters),
       odometerKm = Value(odometerKm),
       fuelType = Value(fuelType);
  static Insertable<FuelRecord> custom({
    Expression<int>? id,
    Expression<int>? motoId,
    Expression<DateTime>? date,
    Expression<double>? liters,
    Expression<double>? pricePerLiter,
    Expression<int>? odometerKm,
    Expression<String>? fuelType,
    Expression<bool>? usedOctaneBooster,
    Expression<String>? octaneBrand,
    Expression<String>? notes,
    Expression<bool>? isFull,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motoId != null) 'moto_id': motoId,
      if (date != null) 'date': date,
      if (liters != null) 'liters': liters,
      if (pricePerLiter != null) 'price_per_liter': pricePerLiter,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (fuelType != null) 'fuel_type': fuelType,
      if (usedOctaneBooster != null) 'used_octane_booster': usedOctaneBooster,
      if (octaneBrand != null) 'octane_brand': octaneBrand,
      if (notes != null) 'notes': notes,
      if (isFull != null) 'is_full': isFull,
    });
  }

  FuelRecordsCompanion copyWith({
    Value<int>? id,
    Value<int?>? motoId,
    Value<DateTime>? date,
    Value<double>? liters,
    Value<double?>? pricePerLiter,
    Value<int>? odometerKm,
    Value<String>? fuelType,
    Value<bool>? usedOctaneBooster,
    Value<String?>? octaneBrand,
    Value<String?>? notes,
    Value<bool>? isFull,
  }) {
    return FuelRecordsCompanion(
      id: id ?? this.id,
      motoId: motoId ?? this.motoId,
      date: date ?? this.date,
      liters: liters ?? this.liters,
      pricePerLiter: pricePerLiter ?? this.pricePerLiter,
      odometerKm: odometerKm ?? this.odometerKm,
      fuelType: fuelType ?? this.fuelType,
      usedOctaneBooster: usedOctaneBooster ?? this.usedOctaneBooster,
      octaneBrand: octaneBrand ?? this.octaneBrand,
      notes: notes ?? this.notes,
      isFull: isFull ?? this.isFull,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motoId.present) {
      map['moto_id'] = Variable<int>(motoId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (liters.present) {
      map['liters'] = Variable<double>(liters.value);
    }
    if (pricePerLiter.present) {
      map['price_per_liter'] = Variable<double>(pricePerLiter.value);
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<int>(odometerKm.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (usedOctaneBooster.present) {
      map['used_octane_booster'] = Variable<bool>(usedOctaneBooster.value);
    }
    if (octaneBrand.present) {
      map['octane_brand'] = Variable<String>(octaneBrand.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isFull.present) {
      map['is_full'] = Variable<bool>(isFull.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuelRecordsCompanion(')
          ..write('id: $id, ')
          ..write('motoId: $motoId, ')
          ..write('date: $date, ')
          ..write('liters: $liters, ')
          ..write('pricePerLiter: $pricePerLiter, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('fuelType: $fuelType, ')
          ..write('usedOctaneBooster: $usedOctaneBooster, ')
          ..write('octaneBrand: $octaneBrand, ')
          ..write('notes: $notes, ')
          ..write('isFull: $isFull')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceRecordsTable extends MaintenanceRecords
    with TableInfo<$MaintenanceRecordsTable, MaintenanceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _motoIdMeta = const VerificationMeta('motoId');
  @override
  late final GeneratedColumn<int> motoId = GeneratedColumn<int>(
    'moto_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerKmMeta = const VerificationMeta(
    'odometerKm',
  );
  @override
  late final GeneratedColumn<int> odometerKm = GeneratedColumn<int>(
    'odometer_km',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workshopMeta = const VerificationMeta(
    'workshop',
  );
  @override
  late final GeneratedColumn<String> workshop = GeneratedColumn<String>(
    'workshop',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextServiceDateMeta = const VerificationMeta(
    'nextServiceDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextServiceDate =
      GeneratedColumn<DateTime>(
        'next_service_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextServiceKmMeta = const VerificationMeta(
    'nextServiceKm',
  );
  @override
  late final GeneratedColumn<int> nextServiceKm = GeneratedColumn<int>(
    'next_service_km',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  static const VerificationMeta _oilTypeMeta = const VerificationMeta(
    'oilType',
  );
  @override
  late final GeneratedColumn<String> oilType = GeneratedColumn<String>(
    'oil_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oilViscosityMeta = const VerificationMeta(
    'oilViscosity',
  );
  @override
  late final GeneratedColumn<String> oilViscosity = GeneratedColumn<String>(
    'oil_viscosity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maintenanceItemsMeta = const VerificationMeta(
    'maintenanceItems',
  );
  @override
  late final GeneratedColumn<String> maintenanceItems = GeneratedColumn<String>(
    'maintenance_items',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calendarEventIdMeta = const VerificationMeta(
    'calendarEventId',
  );
  @override
  late final GeneratedColumn<String> calendarEventId = GeneratedColumn<String>(
    'calendar_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    motoId,
    date,
    odometerKm,
    type,
    description,
    cost,
    workshop,
    nextServiceDate,
    nextServiceKm,
    notes,
    oilType,
    oilViscosity,
    maintenanceItems,
    calendarEventId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('moto_id')) {
      context.handle(
        _motoIdMeta,
        motoId.isAcceptableOrUnknown(data['moto_id']!, _motoIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('odometer_km')) {
      context.handle(
        _odometerKmMeta,
        odometerKm.isAcceptableOrUnknown(data['odometer_km']!, _odometerKmMeta),
      );
    } else if (isInserting) {
      context.missing(_odometerKmMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('workshop')) {
      context.handle(
        _workshopMeta,
        workshop.isAcceptableOrUnknown(data['workshop']!, _workshopMeta),
      );
    }
    if (data.containsKey('next_service_date')) {
      context.handle(
        _nextServiceDateMeta,
        nextServiceDate.isAcceptableOrUnknown(
          data['next_service_date']!,
          _nextServiceDateMeta,
        ),
      );
    }
    if (data.containsKey('next_service_km')) {
      context.handle(
        _nextServiceKmMeta,
        nextServiceKm.isAcceptableOrUnknown(
          data['next_service_km']!,
          _nextServiceKmMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('oil_type')) {
      context.handle(
        _oilTypeMeta,
        oilType.isAcceptableOrUnknown(data['oil_type']!, _oilTypeMeta),
      );
    }
    if (data.containsKey('oil_viscosity')) {
      context.handle(
        _oilViscosityMeta,
        oilViscosity.isAcceptableOrUnknown(
          data['oil_viscosity']!,
          _oilViscosityMeta,
        ),
      );
    }
    if (data.containsKey('maintenance_items')) {
      context.handle(
        _maintenanceItemsMeta,
        maintenanceItems.isAcceptableOrUnknown(
          data['maintenance_items']!,
          _maintenanceItemsMeta,
        ),
      );
    }
    if (data.containsKey('calendar_event_id')) {
      context.handle(
        _calendarEventIdMeta,
        calendarEventId.isAcceptableOrUnknown(
          data['calendar_event_id']!,
          _calendarEventIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      motoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moto_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      odometerKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometer_km'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      ),
      workshop: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workshop'],
      ),
      nextServiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_service_date'],
      ),
      nextServiceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_service_km'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      oilType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oil_type'],
      ),
      oilViscosity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oil_viscosity'],
      ),
      maintenanceItems: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}maintenance_items'],
      ),
      calendarEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_event_id'],
      ),
    );
  }

  @override
  $MaintenanceRecordsTable createAlias(String alias) {
    return $MaintenanceRecordsTable(attachedDatabase, alias);
  }
}

class MaintenanceRecord extends DataClass
    implements Insertable<MaintenanceRecord> {
  final int id;
  final int? motoId;
  final DateTime date;
  final int odometerKm;
  final String type;
  final String description;
  final double? cost;
  final String? workshop;
  final DateTime? nextServiceDate;
  final int? nextServiceKm;
  final String? notes;
  final String? oilType;
  final String? oilViscosity;
  final String? maintenanceItems;
  final String? calendarEventId;
  const MaintenanceRecord({
    required this.id,
    this.motoId,
    required this.date,
    required this.odometerKm,
    required this.type,
    required this.description,
    this.cost,
    this.workshop,
    this.nextServiceDate,
    this.nextServiceKm,
    this.notes,
    this.oilType,
    this.oilViscosity,
    this.maintenanceItems,
    this.calendarEventId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || motoId != null) {
      map['moto_id'] = Variable<int>(motoId);
    }
    map['date'] = Variable<DateTime>(date);
    map['odometer_km'] = Variable<int>(odometerKm);
    map['type'] = Variable<String>(type);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<double>(cost);
    }
    if (!nullToAbsent || workshop != null) {
      map['workshop'] = Variable<String>(workshop);
    }
    if (!nullToAbsent || nextServiceDate != null) {
      map['next_service_date'] = Variable<DateTime>(nextServiceDate);
    }
    if (!nullToAbsent || nextServiceKm != null) {
      map['next_service_km'] = Variable<int>(nextServiceKm);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || oilType != null) {
      map['oil_type'] = Variable<String>(oilType);
    }
    if (!nullToAbsent || oilViscosity != null) {
      map['oil_viscosity'] = Variable<String>(oilViscosity);
    }
    if (!nullToAbsent || maintenanceItems != null) {
      map['maintenance_items'] = Variable<String>(maintenanceItems);
    }
    if (!nullToAbsent || calendarEventId != null) {
      map['calendar_event_id'] = Variable<String>(calendarEventId);
    }
    return map;
  }

  MaintenanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceRecordsCompanion(
      id: Value(id),
      motoId: motoId == null && nullToAbsent
          ? const Value.absent()
          : Value(motoId),
      date: Value(date),
      odometerKm: Value(odometerKm),
      type: Value(type),
      description: Value(description),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      workshop: workshop == null && nullToAbsent
          ? const Value.absent()
          : Value(workshop),
      nextServiceDate: nextServiceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextServiceDate),
      nextServiceKm: nextServiceKm == null && nullToAbsent
          ? const Value.absent()
          : Value(nextServiceKm),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      oilType: oilType == null && nullToAbsent
          ? const Value.absent()
          : Value(oilType),
      oilViscosity: oilViscosity == null && nullToAbsent
          ? const Value.absent()
          : Value(oilViscosity),
      maintenanceItems: maintenanceItems == null && nullToAbsent
          ? const Value.absent()
          : Value(maintenanceItems),
      calendarEventId: calendarEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(calendarEventId),
    );
  }

  factory MaintenanceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceRecord(
      id: serializer.fromJson<int>(json['id']),
      motoId: serializer.fromJson<int?>(json['motoId']),
      date: serializer.fromJson<DateTime>(json['date']),
      odometerKm: serializer.fromJson<int>(json['odometerKm']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
      cost: serializer.fromJson<double?>(json['cost']),
      workshop: serializer.fromJson<String?>(json['workshop']),
      nextServiceDate: serializer.fromJson<DateTime?>(json['nextServiceDate']),
      nextServiceKm: serializer.fromJson<int?>(json['nextServiceKm']),
      notes: serializer.fromJson<String?>(json['notes']),
      oilType: serializer.fromJson<String?>(json['oilType']),
      oilViscosity: serializer.fromJson<String?>(json['oilViscosity']),
      maintenanceItems: serializer.fromJson<String?>(json['maintenanceItems']),
      calendarEventId: serializer.fromJson<String?>(json['calendarEventId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motoId': serializer.toJson<int?>(motoId),
      'date': serializer.toJson<DateTime>(date),
      'odometerKm': serializer.toJson<int>(odometerKm),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
      'cost': serializer.toJson<double?>(cost),
      'workshop': serializer.toJson<String?>(workshop),
      'nextServiceDate': serializer.toJson<DateTime?>(nextServiceDate),
      'nextServiceKm': serializer.toJson<int?>(nextServiceKm),
      'notes': serializer.toJson<String?>(notes),
      'oilType': serializer.toJson<String?>(oilType),
      'oilViscosity': serializer.toJson<String?>(oilViscosity),
      'maintenanceItems': serializer.toJson<String?>(maintenanceItems),
      'calendarEventId': serializer.toJson<String?>(calendarEventId),
    };
  }

  MaintenanceRecord copyWith({
    int? id,
    Value<int?> motoId = const Value.absent(),
    DateTime? date,
    int? odometerKm,
    String? type,
    String? description,
    Value<double?> cost = const Value.absent(),
    Value<String?> workshop = const Value.absent(),
    Value<DateTime?> nextServiceDate = const Value.absent(),
    Value<int?> nextServiceKm = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> oilType = const Value.absent(),
    Value<String?> oilViscosity = const Value.absent(),
    Value<String?> maintenanceItems = const Value.absent(),
    Value<String?> calendarEventId = const Value.absent(),
  }) => MaintenanceRecord(
    id: id ?? this.id,
    motoId: motoId.present ? motoId.value : this.motoId,
    date: date ?? this.date,
    odometerKm: odometerKm ?? this.odometerKm,
    type: type ?? this.type,
    description: description ?? this.description,
    cost: cost.present ? cost.value : this.cost,
    workshop: workshop.present ? workshop.value : this.workshop,
    nextServiceDate: nextServiceDate.present
        ? nextServiceDate.value
        : this.nextServiceDate,
    nextServiceKm: nextServiceKm.present
        ? nextServiceKm.value
        : this.nextServiceKm,
    notes: notes.present ? notes.value : this.notes,
    oilType: oilType.present ? oilType.value : this.oilType,
    oilViscosity: oilViscosity.present ? oilViscosity.value : this.oilViscosity,
    maintenanceItems: maintenanceItems.present
        ? maintenanceItems.value
        : this.maintenanceItems,
    calendarEventId: calendarEventId.present
        ? calendarEventId.value
        : this.calendarEventId,
  );
  MaintenanceRecord copyWithCompanion(MaintenanceRecordsCompanion data) {
    return MaintenanceRecord(
      id: data.id.present ? data.id.value : this.id,
      motoId: data.motoId.present ? data.motoId.value : this.motoId,
      date: data.date.present ? data.date.value : this.date,
      odometerKm: data.odometerKm.present
          ? data.odometerKm.value
          : this.odometerKm,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      cost: data.cost.present ? data.cost.value : this.cost,
      workshop: data.workshop.present ? data.workshop.value : this.workshop,
      nextServiceDate: data.nextServiceDate.present
          ? data.nextServiceDate.value
          : this.nextServiceDate,
      nextServiceKm: data.nextServiceKm.present
          ? data.nextServiceKm.value
          : this.nextServiceKm,
      notes: data.notes.present ? data.notes.value : this.notes,
      oilType: data.oilType.present ? data.oilType.value : this.oilType,
      oilViscosity: data.oilViscosity.present
          ? data.oilViscosity.value
          : this.oilViscosity,
      maintenanceItems: data.maintenanceItems.present
          ? data.maintenanceItems.value
          : this.maintenanceItems,
      calendarEventId: data.calendarEventId.present
          ? data.calendarEventId.value
          : this.calendarEventId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRecord(')
          ..write('id: $id, ')
          ..write('motoId: $motoId, ')
          ..write('date: $date, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('cost: $cost, ')
          ..write('workshop: $workshop, ')
          ..write('nextServiceDate: $nextServiceDate, ')
          ..write('nextServiceKm: $nextServiceKm, ')
          ..write('notes: $notes, ')
          ..write('oilType: $oilType, ')
          ..write('oilViscosity: $oilViscosity, ')
          ..write('maintenanceItems: $maintenanceItems, ')
          ..write('calendarEventId: $calendarEventId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    motoId,
    date,
    odometerKm,
    type,
    description,
    cost,
    workshop,
    nextServiceDate,
    nextServiceKm,
    notes,
    oilType,
    oilViscosity,
    maintenanceItems,
    calendarEventId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceRecord &&
          other.id == this.id &&
          other.motoId == this.motoId &&
          other.date == this.date &&
          other.odometerKm == this.odometerKm &&
          other.type == this.type &&
          other.description == this.description &&
          other.cost == this.cost &&
          other.workshop == this.workshop &&
          other.nextServiceDate == this.nextServiceDate &&
          other.nextServiceKm == this.nextServiceKm &&
          other.notes == this.notes &&
          other.oilType == this.oilType &&
          other.oilViscosity == this.oilViscosity &&
          other.maintenanceItems == this.maintenanceItems &&
          other.calendarEventId == this.calendarEventId);
}

class MaintenanceRecordsCompanion extends UpdateCompanion<MaintenanceRecord> {
  final Value<int> id;
  final Value<int?> motoId;
  final Value<DateTime> date;
  final Value<int> odometerKm;
  final Value<String> type;
  final Value<String> description;
  final Value<double?> cost;
  final Value<String?> workshop;
  final Value<DateTime?> nextServiceDate;
  final Value<int?> nextServiceKm;
  final Value<String?> notes;
  final Value<String?> oilType;
  final Value<String?> oilViscosity;
  final Value<String?> maintenanceItems;
  final Value<String?> calendarEventId;
  const MaintenanceRecordsCompanion({
    this.id = const Value.absent(),
    this.motoId = const Value.absent(),
    this.date = const Value.absent(),
    this.odometerKm = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.cost = const Value.absent(),
    this.workshop = const Value.absent(),
    this.nextServiceDate = const Value.absent(),
    this.nextServiceKm = const Value.absent(),
    this.notes = const Value.absent(),
    this.oilType = const Value.absent(),
    this.oilViscosity = const Value.absent(),
    this.maintenanceItems = const Value.absent(),
    this.calendarEventId = const Value.absent(),
  });
  MaintenanceRecordsCompanion.insert({
    this.id = const Value.absent(),
    this.motoId = const Value.absent(),
    required DateTime date,
    required int odometerKm,
    required String type,
    required String description,
    this.cost = const Value.absent(),
    this.workshop = const Value.absent(),
    this.nextServiceDate = const Value.absent(),
    this.nextServiceKm = const Value.absent(),
    this.notes = const Value.absent(),
    this.oilType = const Value.absent(),
    this.oilViscosity = const Value.absent(),
    this.maintenanceItems = const Value.absent(),
    this.calendarEventId = const Value.absent(),
  }) : date = Value(date),
       odometerKm = Value(odometerKm),
       type = Value(type),
       description = Value(description);
  static Insertable<MaintenanceRecord> custom({
    Expression<int>? id,
    Expression<int>? motoId,
    Expression<DateTime>? date,
    Expression<int>? odometerKm,
    Expression<String>? type,
    Expression<String>? description,
    Expression<double>? cost,
    Expression<String>? workshop,
    Expression<DateTime>? nextServiceDate,
    Expression<int>? nextServiceKm,
    Expression<String>? notes,
    Expression<String>? oilType,
    Expression<String>? oilViscosity,
    Expression<String>? maintenanceItems,
    Expression<String>? calendarEventId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motoId != null) 'moto_id': motoId,
      if (date != null) 'date': date,
      if (odometerKm != null) 'odometer_km': odometerKm,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (cost != null) 'cost': cost,
      if (workshop != null) 'workshop': workshop,
      if (nextServiceDate != null) 'next_service_date': nextServiceDate,
      if (nextServiceKm != null) 'next_service_km': nextServiceKm,
      if (notes != null) 'notes': notes,
      if (oilType != null) 'oil_type': oilType,
      if (oilViscosity != null) 'oil_viscosity': oilViscosity,
      if (maintenanceItems != null) 'maintenance_items': maintenanceItems,
      if (calendarEventId != null) 'calendar_event_id': calendarEventId,
    });
  }

  MaintenanceRecordsCompanion copyWith({
    Value<int>? id,
    Value<int?>? motoId,
    Value<DateTime>? date,
    Value<int>? odometerKm,
    Value<String>? type,
    Value<String>? description,
    Value<double?>? cost,
    Value<String?>? workshop,
    Value<DateTime?>? nextServiceDate,
    Value<int?>? nextServiceKm,
    Value<String?>? notes,
    Value<String?>? oilType,
    Value<String?>? oilViscosity,
    Value<String?>? maintenanceItems,
    Value<String?>? calendarEventId,
  }) {
    return MaintenanceRecordsCompanion(
      id: id ?? this.id,
      motoId: motoId ?? this.motoId,
      date: date ?? this.date,
      odometerKm: odometerKm ?? this.odometerKm,
      type: type ?? this.type,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      workshop: workshop ?? this.workshop,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
      nextServiceKm: nextServiceKm ?? this.nextServiceKm,
      notes: notes ?? this.notes,
      oilType: oilType ?? this.oilType,
      oilViscosity: oilViscosity ?? this.oilViscosity,
      maintenanceItems: maintenanceItems ?? this.maintenanceItems,
      calendarEventId: calendarEventId ?? this.calendarEventId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motoId.present) {
      map['moto_id'] = Variable<int>(motoId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (odometerKm.present) {
      map['odometer_km'] = Variable<int>(odometerKm.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (workshop.present) {
      map['workshop'] = Variable<String>(workshop.value);
    }
    if (nextServiceDate.present) {
      map['next_service_date'] = Variable<DateTime>(nextServiceDate.value);
    }
    if (nextServiceKm.present) {
      map['next_service_km'] = Variable<int>(nextServiceKm.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (oilType.present) {
      map['oil_type'] = Variable<String>(oilType.value);
    }
    if (oilViscosity.present) {
      map['oil_viscosity'] = Variable<String>(oilViscosity.value);
    }
    if (maintenanceItems.present) {
      map['maintenance_items'] = Variable<String>(maintenanceItems.value);
    }
    if (calendarEventId.present) {
      map['calendar_event_id'] = Variable<String>(calendarEventId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('motoId: $motoId, ')
          ..write('date: $date, ')
          ..write('odometerKm: $odometerKm, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('cost: $cost, ')
          ..write('workshop: $workshop, ')
          ..write('nextServiceDate: $nextServiceDate, ')
          ..write('nextServiceKm: $nextServiceKm, ')
          ..write('notes: $notes, ')
          ..write('oilType: $oilType, ')
          ..write('oilViscosity: $oilViscosity, ')
          ..write('maintenanceItems: $maintenanceItems, ')
          ..write('calendarEventId: $calendarEventId')
          ..write(')'))
        .toString();
  }
}

class $PartRecordsTable extends PartRecords
    with TableInfo<$PartRecordsTable, PartRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _motoIdMeta = const VerificationMeta('motoId');
  @override
  late final GeneratedColumn<int> motoId = GeneratedColumn<int>(
    'moto_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _intervalKmMeta = const VerificationMeta(
    'intervalKm',
  );
  @override
  late final GeneratedColumn<int> intervalKm = GeneratedColumn<int>(
    'interval_km',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastChangedKmMeta = const VerificationMeta(
    'lastChangedKm',
  );
  @override
  late final GeneratedColumn<int> lastChangedKm = GeneratedColumn<int>(
    'last_changed_km',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastChangedDateMeta = const VerificationMeta(
    'lastChangedDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastChangedDate =
      GeneratedColumn<DateTime>(
        'last_changed_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _partCategoryMeta = const VerificationMeta(
    'partCategory',
  );
  @override
  late final GeneratedColumn<String> partCategory = GeneratedColumn<String>(
    'part_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filterTypeMeta = const VerificationMeta(
    'filterType',
  );
  @override
  late final GeneratedColumn<String> filterType = GeneratedColumn<String>(
    'filter_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brakeTypeMeta = const VerificationMeta(
    'brakeType',
  );
  @override
  late final GeneratedColumn<String> brakeType = GeneratedColumn<String>(
    'brake_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tireTypeMeta = const VerificationMeta(
    'tireType',
  );
  @override
  late final GeneratedColumn<String> tireType = GeneratedColumn<String>(
    'tire_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chainTypeMeta = const VerificationMeta(
    'chainType',
  );
  @override
  late final GeneratedColumn<String> chainType = GeneratedColumn<String>(
    'chain_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requiresComboChangeMeta =
      const VerificationMeta('requiresComboChange');
  @override
  late final GeneratedColumn<bool> requiresComboChange = GeneratedColumn<bool>(
    'requires_combo_change',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_combo_change" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    motoId,
    name,
    intervalKm,
    lastChangedKm,
    lastChangedDate,
    cost,
    isActive,
    partCategory,
    filterType,
    brakeType,
    tireType,
    chainType,
    requiresComboChange,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'part_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('moto_id')) {
      context.handle(
        _motoIdMeta,
        motoId.isAcceptableOrUnknown(data['moto_id']!, _motoIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('interval_km')) {
      context.handle(
        _intervalKmMeta,
        intervalKm.isAcceptableOrUnknown(data['interval_km']!, _intervalKmMeta),
      );
    } else if (isInserting) {
      context.missing(_intervalKmMeta);
    }
    if (data.containsKey('last_changed_km')) {
      context.handle(
        _lastChangedKmMeta,
        lastChangedKm.isAcceptableOrUnknown(
          data['last_changed_km']!,
          _lastChangedKmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastChangedKmMeta);
    }
    if (data.containsKey('last_changed_date')) {
      context.handle(
        _lastChangedDateMeta,
        lastChangedDate.isAcceptableOrUnknown(
          data['last_changed_date']!,
          _lastChangedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastChangedDateMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('part_category')) {
      context.handle(
        _partCategoryMeta,
        partCategory.isAcceptableOrUnknown(
          data['part_category']!,
          _partCategoryMeta,
        ),
      );
    }
    if (data.containsKey('filter_type')) {
      context.handle(
        _filterTypeMeta,
        filterType.isAcceptableOrUnknown(data['filter_type']!, _filterTypeMeta),
      );
    }
    if (data.containsKey('brake_type')) {
      context.handle(
        _brakeTypeMeta,
        brakeType.isAcceptableOrUnknown(data['brake_type']!, _brakeTypeMeta),
      );
    }
    if (data.containsKey('tire_type')) {
      context.handle(
        _tireTypeMeta,
        tireType.isAcceptableOrUnknown(data['tire_type']!, _tireTypeMeta),
      );
    }
    if (data.containsKey('chain_type')) {
      context.handle(
        _chainTypeMeta,
        chainType.isAcceptableOrUnknown(data['chain_type']!, _chainTypeMeta),
      );
    }
    if (data.containsKey('requires_combo_change')) {
      context.handle(
        _requiresComboChangeMeta,
        requiresComboChange.isAcceptableOrUnknown(
          data['requires_combo_change']!,
          _requiresComboChangeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      motoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moto_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      intervalKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_km'],
      )!,
      lastChangedKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_changed_km'],
      )!,
      lastChangedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_changed_date'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      partCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_category'],
      ),
      filterType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filter_type'],
      ),
      brakeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brake_type'],
      ),
      tireType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tire_type'],
      ),
      chainType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chain_type'],
      ),
      requiresComboChange: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_combo_change'],
      )!,
    );
  }

  @override
  $PartRecordsTable createAlias(String alias) {
    return $PartRecordsTable(attachedDatabase, alias);
  }
}

class PartRecord extends DataClass implements Insertable<PartRecord> {
  final int id;
  final int? motoId;
  final String name;
  final int intervalKm;
  final int lastChangedKm;
  final DateTime lastChangedDate;
  final double? cost;
  final bool isActive;
  final String? partCategory;
  final String? filterType;
  final String? brakeType;
  final String? tireType;
  final String? chainType;
  final bool requiresComboChange;
  const PartRecord({
    required this.id,
    this.motoId,
    required this.name,
    required this.intervalKm,
    required this.lastChangedKm,
    required this.lastChangedDate,
    this.cost,
    required this.isActive,
    this.partCategory,
    this.filterType,
    this.brakeType,
    this.tireType,
    this.chainType,
    required this.requiresComboChange,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || motoId != null) {
      map['moto_id'] = Variable<int>(motoId);
    }
    map['name'] = Variable<String>(name);
    map['interval_km'] = Variable<int>(intervalKm);
    map['last_changed_km'] = Variable<int>(lastChangedKm);
    map['last_changed_date'] = Variable<DateTime>(lastChangedDate);
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<double>(cost);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || partCategory != null) {
      map['part_category'] = Variable<String>(partCategory);
    }
    if (!nullToAbsent || filterType != null) {
      map['filter_type'] = Variable<String>(filterType);
    }
    if (!nullToAbsent || brakeType != null) {
      map['brake_type'] = Variable<String>(brakeType);
    }
    if (!nullToAbsent || tireType != null) {
      map['tire_type'] = Variable<String>(tireType);
    }
    if (!nullToAbsent || chainType != null) {
      map['chain_type'] = Variable<String>(chainType);
    }
    map['requires_combo_change'] = Variable<bool>(requiresComboChange);
    return map;
  }

  PartRecordsCompanion toCompanion(bool nullToAbsent) {
    return PartRecordsCompanion(
      id: Value(id),
      motoId: motoId == null && nullToAbsent
          ? const Value.absent()
          : Value(motoId),
      name: Value(name),
      intervalKm: Value(intervalKm),
      lastChangedKm: Value(lastChangedKm),
      lastChangedDate: Value(lastChangedDate),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      isActive: Value(isActive),
      partCategory: partCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(partCategory),
      filterType: filterType == null && nullToAbsent
          ? const Value.absent()
          : Value(filterType),
      brakeType: brakeType == null && nullToAbsent
          ? const Value.absent()
          : Value(brakeType),
      tireType: tireType == null && nullToAbsent
          ? const Value.absent()
          : Value(tireType),
      chainType: chainType == null && nullToAbsent
          ? const Value.absent()
          : Value(chainType),
      requiresComboChange: Value(requiresComboChange),
    );
  }

  factory PartRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartRecord(
      id: serializer.fromJson<int>(json['id']),
      motoId: serializer.fromJson<int?>(json['motoId']),
      name: serializer.fromJson<String>(json['name']),
      intervalKm: serializer.fromJson<int>(json['intervalKm']),
      lastChangedKm: serializer.fromJson<int>(json['lastChangedKm']),
      lastChangedDate: serializer.fromJson<DateTime>(json['lastChangedDate']),
      cost: serializer.fromJson<double?>(json['cost']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      partCategory: serializer.fromJson<String?>(json['partCategory']),
      filterType: serializer.fromJson<String?>(json['filterType']),
      brakeType: serializer.fromJson<String?>(json['brakeType']),
      tireType: serializer.fromJson<String?>(json['tireType']),
      chainType: serializer.fromJson<String?>(json['chainType']),
      requiresComboChange: serializer.fromJson<bool>(
        json['requiresComboChange'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motoId': serializer.toJson<int?>(motoId),
      'name': serializer.toJson<String>(name),
      'intervalKm': serializer.toJson<int>(intervalKm),
      'lastChangedKm': serializer.toJson<int>(lastChangedKm),
      'lastChangedDate': serializer.toJson<DateTime>(lastChangedDate),
      'cost': serializer.toJson<double?>(cost),
      'isActive': serializer.toJson<bool>(isActive),
      'partCategory': serializer.toJson<String?>(partCategory),
      'filterType': serializer.toJson<String?>(filterType),
      'brakeType': serializer.toJson<String?>(brakeType),
      'tireType': serializer.toJson<String?>(tireType),
      'chainType': serializer.toJson<String?>(chainType),
      'requiresComboChange': serializer.toJson<bool>(requiresComboChange),
    };
  }

  PartRecord copyWith({
    int? id,
    Value<int?> motoId = const Value.absent(),
    String? name,
    int? intervalKm,
    int? lastChangedKm,
    DateTime? lastChangedDate,
    Value<double?> cost = const Value.absent(),
    bool? isActive,
    Value<String?> partCategory = const Value.absent(),
    Value<String?> filterType = const Value.absent(),
    Value<String?> brakeType = const Value.absent(),
    Value<String?> tireType = const Value.absent(),
    Value<String?> chainType = const Value.absent(),
    bool? requiresComboChange,
  }) => PartRecord(
    id: id ?? this.id,
    motoId: motoId.present ? motoId.value : this.motoId,
    name: name ?? this.name,
    intervalKm: intervalKm ?? this.intervalKm,
    lastChangedKm: lastChangedKm ?? this.lastChangedKm,
    lastChangedDate: lastChangedDate ?? this.lastChangedDate,
    cost: cost.present ? cost.value : this.cost,
    isActive: isActive ?? this.isActive,
    partCategory: partCategory.present ? partCategory.value : this.partCategory,
    filterType: filterType.present ? filterType.value : this.filterType,
    brakeType: brakeType.present ? brakeType.value : this.brakeType,
    tireType: tireType.present ? tireType.value : this.tireType,
    chainType: chainType.present ? chainType.value : this.chainType,
    requiresComboChange: requiresComboChange ?? this.requiresComboChange,
  );
  PartRecord copyWithCompanion(PartRecordsCompanion data) {
    return PartRecord(
      id: data.id.present ? data.id.value : this.id,
      motoId: data.motoId.present ? data.motoId.value : this.motoId,
      name: data.name.present ? data.name.value : this.name,
      intervalKm: data.intervalKm.present
          ? data.intervalKm.value
          : this.intervalKm,
      lastChangedKm: data.lastChangedKm.present
          ? data.lastChangedKm.value
          : this.lastChangedKm,
      lastChangedDate: data.lastChangedDate.present
          ? data.lastChangedDate.value
          : this.lastChangedDate,
      cost: data.cost.present ? data.cost.value : this.cost,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      partCategory: data.partCategory.present
          ? data.partCategory.value
          : this.partCategory,
      filterType: data.filterType.present
          ? data.filterType.value
          : this.filterType,
      brakeType: data.brakeType.present ? data.brakeType.value : this.brakeType,
      tireType: data.tireType.present ? data.tireType.value : this.tireType,
      chainType: data.chainType.present ? data.chainType.value : this.chainType,
      requiresComboChange: data.requiresComboChange.present
          ? data.requiresComboChange.value
          : this.requiresComboChange,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartRecord(')
          ..write('id: $id, ')
          ..write('motoId: $motoId, ')
          ..write('name: $name, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('lastChangedKm: $lastChangedKm, ')
          ..write('lastChangedDate: $lastChangedDate, ')
          ..write('cost: $cost, ')
          ..write('isActive: $isActive, ')
          ..write('partCategory: $partCategory, ')
          ..write('filterType: $filterType, ')
          ..write('brakeType: $brakeType, ')
          ..write('tireType: $tireType, ')
          ..write('chainType: $chainType, ')
          ..write('requiresComboChange: $requiresComboChange')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    motoId,
    name,
    intervalKm,
    lastChangedKm,
    lastChangedDate,
    cost,
    isActive,
    partCategory,
    filterType,
    brakeType,
    tireType,
    chainType,
    requiresComboChange,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartRecord &&
          other.id == this.id &&
          other.motoId == this.motoId &&
          other.name == this.name &&
          other.intervalKm == this.intervalKm &&
          other.lastChangedKm == this.lastChangedKm &&
          other.lastChangedDate == this.lastChangedDate &&
          other.cost == this.cost &&
          other.isActive == this.isActive &&
          other.partCategory == this.partCategory &&
          other.filterType == this.filterType &&
          other.brakeType == this.brakeType &&
          other.tireType == this.tireType &&
          other.chainType == this.chainType &&
          other.requiresComboChange == this.requiresComboChange);
}

class PartRecordsCompanion extends UpdateCompanion<PartRecord> {
  final Value<int> id;
  final Value<int?> motoId;
  final Value<String> name;
  final Value<int> intervalKm;
  final Value<int> lastChangedKm;
  final Value<DateTime> lastChangedDate;
  final Value<double?> cost;
  final Value<bool> isActive;
  final Value<String?> partCategory;
  final Value<String?> filterType;
  final Value<String?> brakeType;
  final Value<String?> tireType;
  final Value<String?> chainType;
  final Value<bool> requiresComboChange;
  const PartRecordsCompanion({
    this.id = const Value.absent(),
    this.motoId = const Value.absent(),
    this.name = const Value.absent(),
    this.intervalKm = const Value.absent(),
    this.lastChangedKm = const Value.absent(),
    this.lastChangedDate = const Value.absent(),
    this.cost = const Value.absent(),
    this.isActive = const Value.absent(),
    this.partCategory = const Value.absent(),
    this.filterType = const Value.absent(),
    this.brakeType = const Value.absent(),
    this.tireType = const Value.absent(),
    this.chainType = const Value.absent(),
    this.requiresComboChange = const Value.absent(),
  });
  PartRecordsCompanion.insert({
    this.id = const Value.absent(),
    this.motoId = const Value.absent(),
    required String name,
    required int intervalKm,
    required int lastChangedKm,
    required DateTime lastChangedDate,
    this.cost = const Value.absent(),
    this.isActive = const Value.absent(),
    this.partCategory = const Value.absent(),
    this.filterType = const Value.absent(),
    this.brakeType = const Value.absent(),
    this.tireType = const Value.absent(),
    this.chainType = const Value.absent(),
    this.requiresComboChange = const Value.absent(),
  }) : name = Value(name),
       intervalKm = Value(intervalKm),
       lastChangedKm = Value(lastChangedKm),
       lastChangedDate = Value(lastChangedDate);
  static Insertable<PartRecord> custom({
    Expression<int>? id,
    Expression<int>? motoId,
    Expression<String>? name,
    Expression<int>? intervalKm,
    Expression<int>? lastChangedKm,
    Expression<DateTime>? lastChangedDate,
    Expression<double>? cost,
    Expression<bool>? isActive,
    Expression<String>? partCategory,
    Expression<String>? filterType,
    Expression<String>? brakeType,
    Expression<String>? tireType,
    Expression<String>? chainType,
    Expression<bool>? requiresComboChange,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motoId != null) 'moto_id': motoId,
      if (name != null) 'name': name,
      if (intervalKm != null) 'interval_km': intervalKm,
      if (lastChangedKm != null) 'last_changed_km': lastChangedKm,
      if (lastChangedDate != null) 'last_changed_date': lastChangedDate,
      if (cost != null) 'cost': cost,
      if (isActive != null) 'is_active': isActive,
      if (partCategory != null) 'part_category': partCategory,
      if (filterType != null) 'filter_type': filterType,
      if (brakeType != null) 'brake_type': brakeType,
      if (tireType != null) 'tire_type': tireType,
      if (chainType != null) 'chain_type': chainType,
      if (requiresComboChange != null)
        'requires_combo_change': requiresComboChange,
    });
  }

  PartRecordsCompanion copyWith({
    Value<int>? id,
    Value<int?>? motoId,
    Value<String>? name,
    Value<int>? intervalKm,
    Value<int>? lastChangedKm,
    Value<DateTime>? lastChangedDate,
    Value<double?>? cost,
    Value<bool>? isActive,
    Value<String?>? partCategory,
    Value<String?>? filterType,
    Value<String?>? brakeType,
    Value<String?>? tireType,
    Value<String?>? chainType,
    Value<bool>? requiresComboChange,
  }) {
    return PartRecordsCompanion(
      id: id ?? this.id,
      motoId: motoId ?? this.motoId,
      name: name ?? this.name,
      intervalKm: intervalKm ?? this.intervalKm,
      lastChangedKm: lastChangedKm ?? this.lastChangedKm,
      lastChangedDate: lastChangedDate ?? this.lastChangedDate,
      cost: cost ?? this.cost,
      isActive: isActive ?? this.isActive,
      partCategory: partCategory ?? this.partCategory,
      filterType: filterType ?? this.filterType,
      brakeType: brakeType ?? this.brakeType,
      tireType: tireType ?? this.tireType,
      chainType: chainType ?? this.chainType,
      requiresComboChange: requiresComboChange ?? this.requiresComboChange,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motoId.present) {
      map['moto_id'] = Variable<int>(motoId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (intervalKm.present) {
      map['interval_km'] = Variable<int>(intervalKm.value);
    }
    if (lastChangedKm.present) {
      map['last_changed_km'] = Variable<int>(lastChangedKm.value);
    }
    if (lastChangedDate.present) {
      map['last_changed_date'] = Variable<DateTime>(lastChangedDate.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (partCategory.present) {
      map['part_category'] = Variable<String>(partCategory.value);
    }
    if (filterType.present) {
      map['filter_type'] = Variable<String>(filterType.value);
    }
    if (brakeType.present) {
      map['brake_type'] = Variable<String>(brakeType.value);
    }
    if (tireType.present) {
      map['tire_type'] = Variable<String>(tireType.value);
    }
    if (chainType.present) {
      map['chain_type'] = Variable<String>(chainType.value);
    }
    if (requiresComboChange.present) {
      map['requires_combo_change'] = Variable<bool>(requiresComboChange.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartRecordsCompanion(')
          ..write('id: $id, ')
          ..write('motoId: $motoId, ')
          ..write('name: $name, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('lastChangedKm: $lastChangedKm, ')
          ..write('lastChangedDate: $lastChangedDate, ')
          ..write('cost: $cost, ')
          ..write('isActive: $isActive, ')
          ..write('partCategory: $partCategory, ')
          ..write('filterType: $filterType, ')
          ..write('brakeType: $brakeType, ')
          ..write('tireType: $tireType, ')
          ..write('chainType: $chainType, ')
          ..write('requiresComboChange: $requiresComboChange')
          ..write(')'))
        .toString();
  }
}

class $MotoProfileTable extends MotoProfile
    with TableInfo<$MotoProfileTable, MotoProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MotoProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentKmMeta = const VerificationMeta(
    'currentKm',
  );
  @override
  late final GeneratedColumn<int> currentKm = GeneratedColumn<int>(
    'current_km',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plateMeta = const VerificationMeta('plate');
  @override
  late final GeneratedColumn<String> plate = GeneratedColumn<String>(
    'plate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _engineTypeMeta = const VerificationMeta(
    'engineType',
  );
  @override
  late final GeneratedColumn<String> engineType = GeneratedColumn<String>(
    'engine_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('4T'),
  );
  static const VerificationMeta _twoStrokeOilMethodMeta =
      const VerificationMeta('twoStrokeOilMethod');
  @override
  late final GeneratedColumn<String> twoStrokeOilMethod =
      GeneratedColumn<String>(
        'two_stroke_oil_method',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _displacementMeta = const VerificationMeta(
    'displacement',
  );
  @override
  late final GeneratedColumn<int> displacement = GeneratedColumn<int>(
    'displacement',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelSystemMeta = const VerificationMeta(
    'fuelSystem',
  );
  @override
  late final GeneratedColumn<String> fuelSystem = GeneratedColumn<String>(
    'fuel_system',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('carb'),
  );
  static const VerificationMeta _coolingTypeMeta = const VerificationMeta(
    'coolingType',
  );
  @override
  late final GeneratedColumn<String> coolingType = GeneratedColumn<String>(
    'cooling_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('air'),
  );
  static const VerificationMeta _oilTypeMeta = const VerificationMeta(
    'oilType',
  );
  @override
  late final GeneratedColumn<String> oilType = GeneratedColumn<String>(
    'oil_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oilViscosityMeta = const VerificationMeta(
    'oilViscosity',
  );
  @override
  late final GeneratedColumn<String> oilViscosity = GeneratedColumn<String>(
    'oil_viscosity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oilFilterTypeMeta = const VerificationMeta(
    'oilFilterType',
  );
  @override
  late final GeneratedColumn<String> oilFilterType = GeneratedColumn<String>(
    'oil_filter_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('replaceable'),
  );
  static const VerificationMeta _transmissionTypeMeta = const VerificationMeta(
    'transmissionType',
  );
  @override
  late final GeneratedColumn<String> transmissionType = GeneratedColumn<String>(
    'transmission_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('chain'),
  );
  static const VerificationMeta _rimTypeMeta = const VerificationMeta(
    'rimType',
  );
  @override
  late final GeneratedColumn<String> rimType = GeneratedColumn<String>(
    'rim_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('alloy'),
  );
  static const VerificationMeta _tankCapacityMeta = const VerificationMeta(
    'tankCapacity',
  );
  @override
  late final GeneratedColumn<double> tankCapacity = GeneratedColumn<double>(
    'tank_capacity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    brand,
    model,
    year,
    currentKm,
    plate,
    engineType,
    twoStrokeOilMethod,
    displacement,
    fuelSystem,
    coolingType,
    oilType,
    oilViscosity,
    oilFilterType,
    transmissionType,
    rimType,
    tankCapacity,
    isActive,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moto_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<MotoProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('current_km')) {
      context.handle(
        _currentKmMeta,
        currentKm.isAcceptableOrUnknown(data['current_km']!, _currentKmMeta),
      );
    } else if (isInserting) {
      context.missing(_currentKmMeta);
    }
    if (data.containsKey('plate')) {
      context.handle(
        _plateMeta,
        plate.isAcceptableOrUnknown(data['plate']!, _plateMeta),
      );
    }
    if (data.containsKey('engine_type')) {
      context.handle(
        _engineTypeMeta,
        engineType.isAcceptableOrUnknown(data['engine_type']!, _engineTypeMeta),
      );
    }
    if (data.containsKey('two_stroke_oil_method')) {
      context.handle(
        _twoStrokeOilMethodMeta,
        twoStrokeOilMethod.isAcceptableOrUnknown(
          data['two_stroke_oil_method']!,
          _twoStrokeOilMethodMeta,
        ),
      );
    }
    if (data.containsKey('displacement')) {
      context.handle(
        _displacementMeta,
        displacement.isAcceptableOrUnknown(
          data['displacement']!,
          _displacementMeta,
        ),
      );
    }
    if (data.containsKey('fuel_system')) {
      context.handle(
        _fuelSystemMeta,
        fuelSystem.isAcceptableOrUnknown(data['fuel_system']!, _fuelSystemMeta),
      );
    }
    if (data.containsKey('cooling_type')) {
      context.handle(
        _coolingTypeMeta,
        coolingType.isAcceptableOrUnknown(
          data['cooling_type']!,
          _coolingTypeMeta,
        ),
      );
    }
    if (data.containsKey('oil_type')) {
      context.handle(
        _oilTypeMeta,
        oilType.isAcceptableOrUnknown(data['oil_type']!, _oilTypeMeta),
      );
    }
    if (data.containsKey('oil_viscosity')) {
      context.handle(
        _oilViscosityMeta,
        oilViscosity.isAcceptableOrUnknown(
          data['oil_viscosity']!,
          _oilViscosityMeta,
        ),
      );
    }
    if (data.containsKey('oil_filter_type')) {
      context.handle(
        _oilFilterTypeMeta,
        oilFilterType.isAcceptableOrUnknown(
          data['oil_filter_type']!,
          _oilFilterTypeMeta,
        ),
      );
    }
    if (data.containsKey('transmission_type')) {
      context.handle(
        _transmissionTypeMeta,
        transmissionType.isAcceptableOrUnknown(
          data['transmission_type']!,
          _transmissionTypeMeta,
        ),
      );
    }
    if (data.containsKey('rim_type')) {
      context.handle(
        _rimTypeMeta,
        rimType.isAcceptableOrUnknown(data['rim_type']!, _rimTypeMeta),
      );
    }
    if (data.containsKey('tank_capacity')) {
      context.handle(
        _tankCapacityMeta,
        tankCapacity.isAcceptableOrUnknown(
          data['tank_capacity']!,
          _tankCapacityMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
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
  MotoProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MotoProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      currentKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_km'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      ),
      engineType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine_type'],
      )!,
      twoStrokeOilMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}two_stroke_oil_method'],
      ),
      displacement: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}displacement'],
      ),
      fuelSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_system'],
      )!,
      coolingType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cooling_type'],
      )!,
      oilType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oil_type'],
      ),
      oilViscosity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oil_viscosity'],
      ),
      oilFilterType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oil_filter_type'],
      )!,
      transmissionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transmission_type'],
      )!,
      rimType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rim_type'],
      )!,
      tankCapacity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tank_capacity'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MotoProfileTable createAlias(String alias) {
    return $MotoProfileTable(attachedDatabase, alias);
  }
}

class MotoProfileData extends DataClass implements Insertable<MotoProfileData> {
  final int id;
  final String brand;
  final String model;
  final int year;
  final int currentKm;
  final String? plate;
  final String engineType;
  final String? twoStrokeOilMethod;
  final int? displacement;
  final String fuelSystem;
  final String coolingType;
  final String? oilType;
  final String? oilViscosity;
  final String oilFilterType;
  final String transmissionType;
  final String rimType;
  final double? tankCapacity;
  final bool isActive;
  final DateTime updatedAt;
  const MotoProfileData({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.currentKm,
    this.plate,
    required this.engineType,
    this.twoStrokeOilMethod,
    this.displacement,
    required this.fuelSystem,
    required this.coolingType,
    this.oilType,
    this.oilViscosity,
    required this.oilFilterType,
    required this.transmissionType,
    required this.rimType,
    this.tankCapacity,
    required this.isActive,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    map['year'] = Variable<int>(year);
    map['current_km'] = Variable<int>(currentKm);
    if (!nullToAbsent || plate != null) {
      map['plate'] = Variable<String>(plate);
    }
    map['engine_type'] = Variable<String>(engineType);
    if (!nullToAbsent || twoStrokeOilMethod != null) {
      map['two_stroke_oil_method'] = Variable<String>(twoStrokeOilMethod);
    }
    if (!nullToAbsent || displacement != null) {
      map['displacement'] = Variable<int>(displacement);
    }
    map['fuel_system'] = Variable<String>(fuelSystem);
    map['cooling_type'] = Variable<String>(coolingType);
    if (!nullToAbsent || oilType != null) {
      map['oil_type'] = Variable<String>(oilType);
    }
    if (!nullToAbsent || oilViscosity != null) {
      map['oil_viscosity'] = Variable<String>(oilViscosity);
    }
    map['oil_filter_type'] = Variable<String>(oilFilterType);
    map['transmission_type'] = Variable<String>(transmissionType);
    map['rim_type'] = Variable<String>(rimType);
    if (!nullToAbsent || tankCapacity != null) {
      map['tank_capacity'] = Variable<double>(tankCapacity);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MotoProfileCompanion toCompanion(bool nullToAbsent) {
    return MotoProfileCompanion(
      id: Value(id),
      brand: Value(brand),
      model: Value(model),
      year: Value(year),
      currentKm: Value(currentKm),
      plate: plate == null && nullToAbsent
          ? const Value.absent()
          : Value(plate),
      engineType: Value(engineType),
      twoStrokeOilMethod: twoStrokeOilMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(twoStrokeOilMethod),
      displacement: displacement == null && nullToAbsent
          ? const Value.absent()
          : Value(displacement),
      fuelSystem: Value(fuelSystem),
      coolingType: Value(coolingType),
      oilType: oilType == null && nullToAbsent
          ? const Value.absent()
          : Value(oilType),
      oilViscosity: oilViscosity == null && nullToAbsent
          ? const Value.absent()
          : Value(oilViscosity),
      oilFilterType: Value(oilFilterType),
      transmissionType: Value(transmissionType),
      rimType: Value(rimType),
      tankCapacity: tankCapacity == null && nullToAbsent
          ? const Value.absent()
          : Value(tankCapacity),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
    );
  }

  factory MotoProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MotoProfileData(
      id: serializer.fromJson<int>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      year: serializer.fromJson<int>(json['year']),
      currentKm: serializer.fromJson<int>(json['currentKm']),
      plate: serializer.fromJson<String?>(json['plate']),
      engineType: serializer.fromJson<String>(json['engineType']),
      twoStrokeOilMethod: serializer.fromJson<String?>(
        json['twoStrokeOilMethod'],
      ),
      displacement: serializer.fromJson<int?>(json['displacement']),
      fuelSystem: serializer.fromJson<String>(json['fuelSystem']),
      coolingType: serializer.fromJson<String>(json['coolingType']),
      oilType: serializer.fromJson<String?>(json['oilType']),
      oilViscosity: serializer.fromJson<String?>(json['oilViscosity']),
      oilFilterType: serializer.fromJson<String>(json['oilFilterType']),
      transmissionType: serializer.fromJson<String>(json['transmissionType']),
      rimType: serializer.fromJson<String>(json['rimType']),
      tankCapacity: serializer.fromJson<double?>(json['tankCapacity']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'year': serializer.toJson<int>(year),
      'currentKm': serializer.toJson<int>(currentKm),
      'plate': serializer.toJson<String?>(plate),
      'engineType': serializer.toJson<String>(engineType),
      'twoStrokeOilMethod': serializer.toJson<String?>(twoStrokeOilMethod),
      'displacement': serializer.toJson<int?>(displacement),
      'fuelSystem': serializer.toJson<String>(fuelSystem),
      'coolingType': serializer.toJson<String>(coolingType),
      'oilType': serializer.toJson<String?>(oilType),
      'oilViscosity': serializer.toJson<String?>(oilViscosity),
      'oilFilterType': serializer.toJson<String>(oilFilterType),
      'transmissionType': serializer.toJson<String>(transmissionType),
      'rimType': serializer.toJson<String>(rimType),
      'tankCapacity': serializer.toJson<double?>(tankCapacity),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MotoProfileData copyWith({
    int? id,
    String? brand,
    String? model,
    int? year,
    int? currentKm,
    Value<String?> plate = const Value.absent(),
    String? engineType,
    Value<String?> twoStrokeOilMethod = const Value.absent(),
    Value<int?> displacement = const Value.absent(),
    String? fuelSystem,
    String? coolingType,
    Value<String?> oilType = const Value.absent(),
    Value<String?> oilViscosity = const Value.absent(),
    String? oilFilterType,
    String? transmissionType,
    String? rimType,
    Value<double?> tankCapacity = const Value.absent(),
    bool? isActive,
    DateTime? updatedAt,
  }) => MotoProfileData(
    id: id ?? this.id,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    year: year ?? this.year,
    currentKm: currentKm ?? this.currentKm,
    plate: plate.present ? plate.value : this.plate,
    engineType: engineType ?? this.engineType,
    twoStrokeOilMethod: twoStrokeOilMethod.present
        ? twoStrokeOilMethod.value
        : this.twoStrokeOilMethod,
    displacement: displacement.present ? displacement.value : this.displacement,
    fuelSystem: fuelSystem ?? this.fuelSystem,
    coolingType: coolingType ?? this.coolingType,
    oilType: oilType.present ? oilType.value : this.oilType,
    oilViscosity: oilViscosity.present ? oilViscosity.value : this.oilViscosity,
    oilFilterType: oilFilterType ?? this.oilFilterType,
    transmissionType: transmissionType ?? this.transmissionType,
    rimType: rimType ?? this.rimType,
    tankCapacity: tankCapacity.present ? tankCapacity.value : this.tankCapacity,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MotoProfileData copyWithCompanion(MotoProfileCompanion data) {
    return MotoProfileData(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      currentKm: data.currentKm.present ? data.currentKm.value : this.currentKm,
      plate: data.plate.present ? data.plate.value : this.plate,
      engineType: data.engineType.present
          ? data.engineType.value
          : this.engineType,
      twoStrokeOilMethod: data.twoStrokeOilMethod.present
          ? data.twoStrokeOilMethod.value
          : this.twoStrokeOilMethod,
      displacement: data.displacement.present
          ? data.displacement.value
          : this.displacement,
      fuelSystem: data.fuelSystem.present
          ? data.fuelSystem.value
          : this.fuelSystem,
      coolingType: data.coolingType.present
          ? data.coolingType.value
          : this.coolingType,
      oilType: data.oilType.present ? data.oilType.value : this.oilType,
      oilViscosity: data.oilViscosity.present
          ? data.oilViscosity.value
          : this.oilViscosity,
      oilFilterType: data.oilFilterType.present
          ? data.oilFilterType.value
          : this.oilFilterType,
      transmissionType: data.transmissionType.present
          ? data.transmissionType.value
          : this.transmissionType,
      rimType: data.rimType.present ? data.rimType.value : this.rimType,
      tankCapacity: data.tankCapacity.present
          ? data.tankCapacity.value
          : this.tankCapacity,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MotoProfileData(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('currentKm: $currentKm, ')
          ..write('plate: $plate, ')
          ..write('engineType: $engineType, ')
          ..write('twoStrokeOilMethod: $twoStrokeOilMethod, ')
          ..write('displacement: $displacement, ')
          ..write('fuelSystem: $fuelSystem, ')
          ..write('coolingType: $coolingType, ')
          ..write('oilType: $oilType, ')
          ..write('oilViscosity: $oilViscosity, ')
          ..write('oilFilterType: $oilFilterType, ')
          ..write('transmissionType: $transmissionType, ')
          ..write('rimType: $rimType, ')
          ..write('tankCapacity: $tankCapacity, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brand,
    model,
    year,
    currentKm,
    plate,
    engineType,
    twoStrokeOilMethod,
    displacement,
    fuelSystem,
    coolingType,
    oilType,
    oilViscosity,
    oilFilterType,
    transmissionType,
    rimType,
    tankCapacity,
    isActive,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MotoProfileData &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.year == this.year &&
          other.currentKm == this.currentKm &&
          other.plate == this.plate &&
          other.engineType == this.engineType &&
          other.twoStrokeOilMethod == this.twoStrokeOilMethod &&
          other.displacement == this.displacement &&
          other.fuelSystem == this.fuelSystem &&
          other.coolingType == this.coolingType &&
          other.oilType == this.oilType &&
          other.oilViscosity == this.oilViscosity &&
          other.oilFilterType == this.oilFilterType &&
          other.transmissionType == this.transmissionType &&
          other.rimType == this.rimType &&
          other.tankCapacity == this.tankCapacity &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt);
}

class MotoProfileCompanion extends UpdateCompanion<MotoProfileData> {
  final Value<int> id;
  final Value<String> brand;
  final Value<String> model;
  final Value<int> year;
  final Value<int> currentKm;
  final Value<String?> plate;
  final Value<String> engineType;
  final Value<String?> twoStrokeOilMethod;
  final Value<int?> displacement;
  final Value<String> fuelSystem;
  final Value<String> coolingType;
  final Value<String?> oilType;
  final Value<String?> oilViscosity;
  final Value<String> oilFilterType;
  final Value<String> transmissionType;
  final Value<String> rimType;
  final Value<double?> tankCapacity;
  final Value<bool> isActive;
  final Value<DateTime> updatedAt;
  const MotoProfileCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.currentKm = const Value.absent(),
    this.plate = const Value.absent(),
    this.engineType = const Value.absent(),
    this.twoStrokeOilMethod = const Value.absent(),
    this.displacement = const Value.absent(),
    this.fuelSystem = const Value.absent(),
    this.coolingType = const Value.absent(),
    this.oilType = const Value.absent(),
    this.oilViscosity = const Value.absent(),
    this.oilFilterType = const Value.absent(),
    this.transmissionType = const Value.absent(),
    this.rimType = const Value.absent(),
    this.tankCapacity = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MotoProfileCompanion.insert({
    this.id = const Value.absent(),
    required String brand,
    required String model,
    required int year,
    required int currentKm,
    this.plate = const Value.absent(),
    this.engineType = const Value.absent(),
    this.twoStrokeOilMethod = const Value.absent(),
    this.displacement = const Value.absent(),
    this.fuelSystem = const Value.absent(),
    this.coolingType = const Value.absent(),
    this.oilType = const Value.absent(),
    this.oilViscosity = const Value.absent(),
    this.oilFilterType = const Value.absent(),
    this.transmissionType = const Value.absent(),
    this.rimType = const Value.absent(),
    this.tankCapacity = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime updatedAt,
  }) : brand = Value(brand),
       model = Value(model),
       year = Value(year),
       currentKm = Value(currentKm),
       updatedAt = Value(updatedAt);
  static Insertable<MotoProfileData> custom({
    Expression<int>? id,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? year,
    Expression<int>? currentKm,
    Expression<String>? plate,
    Expression<String>? engineType,
    Expression<String>? twoStrokeOilMethod,
    Expression<int>? displacement,
    Expression<String>? fuelSystem,
    Expression<String>? coolingType,
    Expression<String>? oilType,
    Expression<String>? oilViscosity,
    Expression<String>? oilFilterType,
    Expression<String>? transmissionType,
    Expression<String>? rimType,
    Expression<double>? tankCapacity,
    Expression<bool>? isActive,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (currentKm != null) 'current_km': currentKm,
      if (plate != null) 'plate': plate,
      if (engineType != null) 'engine_type': engineType,
      if (twoStrokeOilMethod != null)
        'two_stroke_oil_method': twoStrokeOilMethod,
      if (displacement != null) 'displacement': displacement,
      if (fuelSystem != null) 'fuel_system': fuelSystem,
      if (coolingType != null) 'cooling_type': coolingType,
      if (oilType != null) 'oil_type': oilType,
      if (oilViscosity != null) 'oil_viscosity': oilViscosity,
      if (oilFilterType != null) 'oil_filter_type': oilFilterType,
      if (transmissionType != null) 'transmission_type': transmissionType,
      if (rimType != null) 'rim_type': rimType,
      if (tankCapacity != null) 'tank_capacity': tankCapacity,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MotoProfileCompanion copyWith({
    Value<int>? id,
    Value<String>? brand,
    Value<String>? model,
    Value<int>? year,
    Value<int>? currentKm,
    Value<String?>? plate,
    Value<String>? engineType,
    Value<String?>? twoStrokeOilMethod,
    Value<int?>? displacement,
    Value<String>? fuelSystem,
    Value<String>? coolingType,
    Value<String?>? oilType,
    Value<String?>? oilViscosity,
    Value<String>? oilFilterType,
    Value<String>? transmissionType,
    Value<String>? rimType,
    Value<double?>? tankCapacity,
    Value<bool>? isActive,
    Value<DateTime>? updatedAt,
  }) {
    return MotoProfileCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      currentKm: currentKm ?? this.currentKm,
      plate: plate ?? this.plate,
      engineType: engineType ?? this.engineType,
      twoStrokeOilMethod: twoStrokeOilMethod ?? this.twoStrokeOilMethod,
      displacement: displacement ?? this.displacement,
      fuelSystem: fuelSystem ?? this.fuelSystem,
      coolingType: coolingType ?? this.coolingType,
      oilType: oilType ?? this.oilType,
      oilViscosity: oilViscosity ?? this.oilViscosity,
      oilFilterType: oilFilterType ?? this.oilFilterType,
      transmissionType: transmissionType ?? this.transmissionType,
      rimType: rimType ?? this.rimType,
      tankCapacity: tankCapacity ?? this.tankCapacity,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (currentKm.present) {
      map['current_km'] = Variable<int>(currentKm.value);
    }
    if (plate.present) {
      map['plate'] = Variable<String>(plate.value);
    }
    if (engineType.present) {
      map['engine_type'] = Variable<String>(engineType.value);
    }
    if (twoStrokeOilMethod.present) {
      map['two_stroke_oil_method'] = Variable<String>(twoStrokeOilMethod.value);
    }
    if (displacement.present) {
      map['displacement'] = Variable<int>(displacement.value);
    }
    if (fuelSystem.present) {
      map['fuel_system'] = Variable<String>(fuelSystem.value);
    }
    if (coolingType.present) {
      map['cooling_type'] = Variable<String>(coolingType.value);
    }
    if (oilType.present) {
      map['oil_type'] = Variable<String>(oilType.value);
    }
    if (oilViscosity.present) {
      map['oil_viscosity'] = Variable<String>(oilViscosity.value);
    }
    if (oilFilterType.present) {
      map['oil_filter_type'] = Variable<String>(oilFilterType.value);
    }
    if (transmissionType.present) {
      map['transmission_type'] = Variable<String>(transmissionType.value);
    }
    if (rimType.present) {
      map['rim_type'] = Variable<String>(rimType.value);
    }
    if (tankCapacity.present) {
      map['tank_capacity'] = Variable<double>(tankCapacity.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MotoProfileCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('currentKm: $currentKm, ')
          ..write('plate: $plate, ')
          ..write('engineType: $engineType, ')
          ..write('twoStrokeOilMethod: $twoStrokeOilMethod, ')
          ..write('displacement: $displacement, ')
          ..write('fuelSystem: $fuelSystem, ')
          ..write('coolingType: $coolingType, ')
          ..write('oilType: $oilType, ')
          ..write('oilViscosity: $oilViscosity, ')
          ..write('oilFilterType: $oilFilterType, ')
          ..write('transmissionType: $transmissionType, ')
          ..write('rimType: $rimType, ')
          ..write('tankCapacity: $tankCapacity, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartHistoryTable extends PartHistory
    with TableInfo<$PartHistoryTable, PartHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motoIdMeta = const VerificationMeta('motoId');
  @override
  late final GeneratedColumn<int> motoId = GeneratedColumn<int>(
    'moto_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partNameMeta = const VerificationMeta(
    'partName',
  );
  @override
  late final GeneratedColumn<String> partName = GeneratedColumn<String>(
    'part_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kmMeta = const VerificationMeta('km');
  @override
  late final GeneratedColumn<int> km = GeneratedColumn<int>(
    'km',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    partId,
    motoId,
    partName,
    km,
    changedAt,
    cost,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'part_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('moto_id')) {
      context.handle(
        _motoIdMeta,
        motoId.isAcceptableOrUnknown(data['moto_id']!, _motoIdMeta),
      );
    }
    if (data.containsKey('part_name')) {
      context.handle(
        _partNameMeta,
        partName.isAcceptableOrUnknown(data['part_name']!, _partNameMeta),
      );
    } else if (isInserting) {
      context.missing(_partNameMeta);
    }
    if (data.containsKey('km')) {
      context.handle(_kmMeta, km.isAcceptableOrUnknown(data['km']!, _kmMeta));
    } else if (isInserting) {
      context.missing(_kmMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}part_id'],
      )!,
      motoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moto_id'],
      ),
      partName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_name'],
      )!,
      km: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}km'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $PartHistoryTable createAlias(String alias) {
    return $PartHistoryTable(attachedDatabase, alias);
  }
}

class PartHistoryData extends DataClass implements Insertable<PartHistoryData> {
  final int id;
  final int partId;
  final int? motoId;
  final String partName;
  final int km;
  final DateTime changedAt;
  final double? cost;
  final String? notes;
  const PartHistoryData({
    required this.id,
    required this.partId,
    this.motoId,
    required this.partName,
    required this.km,
    required this.changedAt,
    this.cost,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['part_id'] = Variable<int>(partId);
    if (!nullToAbsent || motoId != null) {
      map['moto_id'] = Variable<int>(motoId);
    }
    map['part_name'] = Variable<String>(partName);
    map['km'] = Variable<int>(km);
    map['changed_at'] = Variable<DateTime>(changedAt);
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<double>(cost);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PartHistoryCompanion toCompanion(bool nullToAbsent) {
    return PartHistoryCompanion(
      id: Value(id),
      partId: Value(partId),
      motoId: motoId == null && nullToAbsent
          ? const Value.absent()
          : Value(motoId),
      partName: Value(partName),
      km: Value(km),
      changedAt: Value(changedAt),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory PartHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartHistoryData(
      id: serializer.fromJson<int>(json['id']),
      partId: serializer.fromJson<int>(json['partId']),
      motoId: serializer.fromJson<int?>(json['motoId']),
      partName: serializer.fromJson<String>(json['partName']),
      km: serializer.fromJson<int>(json['km']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
      cost: serializer.fromJson<double?>(json['cost']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partId': serializer.toJson<int>(partId),
      'motoId': serializer.toJson<int?>(motoId),
      'partName': serializer.toJson<String>(partName),
      'km': serializer.toJson<int>(km),
      'changedAt': serializer.toJson<DateTime>(changedAt),
      'cost': serializer.toJson<double?>(cost),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PartHistoryData copyWith({
    int? id,
    int? partId,
    Value<int?> motoId = const Value.absent(),
    String? partName,
    int? km,
    DateTime? changedAt,
    Value<double?> cost = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => PartHistoryData(
    id: id ?? this.id,
    partId: partId ?? this.partId,
    motoId: motoId.present ? motoId.value : this.motoId,
    partName: partName ?? this.partName,
    km: km ?? this.km,
    changedAt: changedAt ?? this.changedAt,
    cost: cost.present ? cost.value : this.cost,
    notes: notes.present ? notes.value : this.notes,
  );
  PartHistoryData copyWithCompanion(PartHistoryCompanion data) {
    return PartHistoryData(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      motoId: data.motoId.present ? data.motoId.value : this.motoId,
      partName: data.partName.present ? data.partName.value : this.partName,
      km: data.km.present ? data.km.value : this.km,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
      cost: data.cost.present ? data.cost.value : this.cost,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartHistoryData(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('motoId: $motoId, ')
          ..write('partName: $partName, ')
          ..write('km: $km, ')
          ..write('changedAt: $changedAt, ')
          ..write('cost: $cost, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, partId, motoId, partName, km, changedAt, cost, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartHistoryData &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.motoId == this.motoId &&
          other.partName == this.partName &&
          other.km == this.km &&
          other.changedAt == this.changedAt &&
          other.cost == this.cost &&
          other.notes == this.notes);
}

class PartHistoryCompanion extends UpdateCompanion<PartHistoryData> {
  final Value<int> id;
  final Value<int> partId;
  final Value<int?> motoId;
  final Value<String> partName;
  final Value<int> km;
  final Value<DateTime> changedAt;
  final Value<double?> cost;
  final Value<String?> notes;
  const PartHistoryCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.motoId = const Value.absent(),
    this.partName = const Value.absent(),
    this.km = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.cost = const Value.absent(),
    this.notes = const Value.absent(),
  });
  PartHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int partId,
    this.motoId = const Value.absent(),
    required String partName,
    required int km,
    required DateTime changedAt,
    this.cost = const Value.absent(),
    this.notes = const Value.absent(),
  }) : partId = Value(partId),
       partName = Value(partName),
       km = Value(km),
       changedAt = Value(changedAt);
  static Insertable<PartHistoryData> custom({
    Expression<int>? id,
    Expression<int>? partId,
    Expression<int>? motoId,
    Expression<String>? partName,
    Expression<int>? km,
    Expression<DateTime>? changedAt,
    Expression<double>? cost,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (motoId != null) 'moto_id': motoId,
      if (partName != null) 'part_name': partName,
      if (km != null) 'km': km,
      if (changedAt != null) 'changed_at': changedAt,
      if (cost != null) 'cost': cost,
      if (notes != null) 'notes': notes,
    });
  }

  PartHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? partId,
    Value<int?>? motoId,
    Value<String>? partName,
    Value<int>? km,
    Value<DateTime>? changedAt,
    Value<double?>? cost,
    Value<String?>? notes,
  }) {
    return PartHistoryCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      motoId: motoId ?? this.motoId,
      partName: partName ?? this.partName,
      km: km ?? this.km,
      changedAt: changedAt ?? this.changedAt,
      cost: cost ?? this.cost,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (motoId.present) {
      map['moto_id'] = Variable<int>(motoId.value);
    }
    if (partName.present) {
      map['part_name'] = Variable<String>(partName.value);
    }
    if (km.present) {
      map['km'] = Variable<int>(km.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartHistoryCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('motoId: $motoId, ')
          ..write('partName: $partName, ')
          ..write('km: $km, ')
          ..write('changedAt: $changedAt, ')
          ..write('cost: $cost, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FuelRecordsTable fuelRecords = $FuelRecordsTable(this);
  late final $MaintenanceRecordsTable maintenanceRecords =
      $MaintenanceRecordsTable(this);
  late final $PartRecordsTable partRecords = $PartRecordsTable(this);
  late final $MotoProfileTable motoProfile = $MotoProfileTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $PartHistoryTable partHistory = $PartHistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    fuelRecords,
    maintenanceRecords,
    partRecords,
    motoProfile,
    appSettings,
    partHistory,
  ];
}

typedef $$FuelRecordsTableCreateCompanionBuilder =
    FuelRecordsCompanion Function({
      Value<int> id,
      Value<int?> motoId,
      required DateTime date,
      required double liters,
      Value<double?> pricePerLiter,
      required int odometerKm,
      required String fuelType,
      Value<bool> usedOctaneBooster,
      Value<String?> octaneBrand,
      Value<String?> notes,
      Value<bool> isFull,
    });
typedef $$FuelRecordsTableUpdateCompanionBuilder =
    FuelRecordsCompanion Function({
      Value<int> id,
      Value<int?> motoId,
      Value<DateTime> date,
      Value<double> liters,
      Value<double?> pricePerLiter,
      Value<int> odometerKm,
      Value<String> fuelType,
      Value<bool> usedOctaneBooster,
      Value<String?> octaneBrand,
      Value<String?> notes,
      Value<bool> isFull,
    });

class $$FuelRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $FuelRecordsTable> {
  $$FuelRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get motoId => $composableBuilder(
    column: $table.motoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get usedOctaneBooster => $composableBuilder(
    column: $table.usedOctaneBooster,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get octaneBrand => $composableBuilder(
    column: $table.octaneBrand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFull => $composableBuilder(
    column: $table.isFull,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FuelRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelRecordsTable> {
  $$FuelRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get motoId => $composableBuilder(
    column: $table.motoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get usedOctaneBooster => $composableBuilder(
    column: $table.usedOctaneBooster,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get octaneBrand => $composableBuilder(
    column: $table.octaneBrand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFull => $composableBuilder(
    column: $table.isFull,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FuelRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelRecordsTable> {
  $$FuelRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get motoId =>
      $composableBuilder(column: $table.motoId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get liters =>
      $composableBuilder(column: $table.liters, builder: (column) => column);

  GeneratedColumn<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<bool> get usedOctaneBooster => $composableBuilder(
    column: $table.usedOctaneBooster,
    builder: (column) => column,
  );

  GeneratedColumn<String> get octaneBrand => $composableBuilder(
    column: $table.octaneBrand,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isFull =>
      $composableBuilder(column: $table.isFull, builder: (column) => column);
}

class $$FuelRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FuelRecordsTable,
          FuelRecord,
          $$FuelRecordsTableFilterComposer,
          $$FuelRecordsTableOrderingComposer,
          $$FuelRecordsTableAnnotationComposer,
          $$FuelRecordsTableCreateCompanionBuilder,
          $$FuelRecordsTableUpdateCompanionBuilder,
          (
            FuelRecord,
            BaseReferences<_$AppDatabase, $FuelRecordsTable, FuelRecord>,
          ),
          FuelRecord,
          PrefetchHooks Function()
        > {
  $$FuelRecordsTableTableManager(_$AppDatabase db, $FuelRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> motoId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> liters = const Value.absent(),
                Value<double?> pricePerLiter = const Value.absent(),
                Value<int> odometerKm = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                Value<bool> usedOctaneBooster = const Value.absent(),
                Value<String?> octaneBrand = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isFull = const Value.absent(),
              }) => FuelRecordsCompanion(
                id: id,
                motoId: motoId,
                date: date,
                liters: liters,
                pricePerLiter: pricePerLiter,
                odometerKm: odometerKm,
                fuelType: fuelType,
                usedOctaneBooster: usedOctaneBooster,
                octaneBrand: octaneBrand,
                notes: notes,
                isFull: isFull,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> motoId = const Value.absent(),
                required DateTime date,
                required double liters,
                Value<double?> pricePerLiter = const Value.absent(),
                required int odometerKm,
                required String fuelType,
                Value<bool> usedOctaneBooster = const Value.absent(),
                Value<String?> octaneBrand = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isFull = const Value.absent(),
              }) => FuelRecordsCompanion.insert(
                id: id,
                motoId: motoId,
                date: date,
                liters: liters,
                pricePerLiter: pricePerLiter,
                odometerKm: odometerKm,
                fuelType: fuelType,
                usedOctaneBooster: usedOctaneBooster,
                octaneBrand: octaneBrand,
                notes: notes,
                isFull: isFull,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FuelRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FuelRecordsTable,
      FuelRecord,
      $$FuelRecordsTableFilterComposer,
      $$FuelRecordsTableOrderingComposer,
      $$FuelRecordsTableAnnotationComposer,
      $$FuelRecordsTableCreateCompanionBuilder,
      $$FuelRecordsTableUpdateCompanionBuilder,
      (
        FuelRecord,
        BaseReferences<_$AppDatabase, $FuelRecordsTable, FuelRecord>,
      ),
      FuelRecord,
      PrefetchHooks Function()
    >;
typedef $$MaintenanceRecordsTableCreateCompanionBuilder =
    MaintenanceRecordsCompanion Function({
      Value<int> id,
      Value<int?> motoId,
      required DateTime date,
      required int odometerKm,
      required String type,
      required String description,
      Value<double?> cost,
      Value<String?> workshop,
      Value<DateTime?> nextServiceDate,
      Value<int?> nextServiceKm,
      Value<String?> notes,
      Value<String?> oilType,
      Value<String?> oilViscosity,
      Value<String?> maintenanceItems,
      Value<String?> calendarEventId,
    });
typedef $$MaintenanceRecordsTableUpdateCompanionBuilder =
    MaintenanceRecordsCompanion Function({
      Value<int> id,
      Value<int?> motoId,
      Value<DateTime> date,
      Value<int> odometerKm,
      Value<String> type,
      Value<String> description,
      Value<double?> cost,
      Value<String?> workshop,
      Value<DateTime?> nextServiceDate,
      Value<int?> nextServiceKm,
      Value<String?> notes,
      Value<String?> oilType,
      Value<String?> oilViscosity,
      Value<String?> maintenanceItems,
      Value<String?> calendarEventId,
    });

class $$MaintenanceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get motoId => $composableBuilder(
    column: $table.motoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workshop => $composableBuilder(
    column: $table.workshop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextServiceKm => $composableBuilder(
    column: $table.nextServiceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oilType => $composableBuilder(
    column: $table.oilType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oilViscosity => $composableBuilder(
    column: $table.oilViscosity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maintenanceItems => $composableBuilder(
    column: $table.maintenanceItems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MaintenanceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get motoId => $composableBuilder(
    column: $table.motoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workshop => $composableBuilder(
    column: $table.workshop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextServiceKm => $composableBuilder(
    column: $table.nextServiceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oilType => $composableBuilder(
    column: $table.oilType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oilViscosity => $composableBuilder(
    column: $table.oilViscosity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maintenanceItems => $composableBuilder(
    column: $table.maintenanceItems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MaintenanceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get motoId =>
      $composableBuilder(column: $table.motoId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get odometerKm => $composableBuilder(
    column: $table.odometerKm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get workshop =>
      $composableBuilder(column: $table.workshop, builder: (column) => column);

  GeneratedColumn<DateTime> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextServiceKm => $composableBuilder(
    column: $table.nextServiceKm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get oilType =>
      $composableBuilder(column: $table.oilType, builder: (column) => column);

  GeneratedColumn<String> get oilViscosity => $composableBuilder(
    column: $table.oilViscosity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get maintenanceItems => $composableBuilder(
    column: $table.maintenanceItems,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => column,
  );
}

class $$MaintenanceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceRecordsTable,
          MaintenanceRecord,
          $$MaintenanceRecordsTableFilterComposer,
          $$MaintenanceRecordsTableOrderingComposer,
          $$MaintenanceRecordsTableAnnotationComposer,
          $$MaintenanceRecordsTableCreateCompanionBuilder,
          $$MaintenanceRecordsTableUpdateCompanionBuilder,
          (
            MaintenanceRecord,
            BaseReferences<
              _$AppDatabase,
              $MaintenanceRecordsTable,
              MaintenanceRecord
            >,
          ),
          MaintenanceRecord,
          PrefetchHooks Function()
        > {
  $$MaintenanceRecordsTableTableManager(
    _$AppDatabase db,
    $MaintenanceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> motoId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> odometerKm = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                Value<String?> workshop = const Value.absent(),
                Value<DateTime?> nextServiceDate = const Value.absent(),
                Value<int?> nextServiceKm = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> oilType = const Value.absent(),
                Value<String?> oilViscosity = const Value.absent(),
                Value<String?> maintenanceItems = const Value.absent(),
                Value<String?> calendarEventId = const Value.absent(),
              }) => MaintenanceRecordsCompanion(
                id: id,
                motoId: motoId,
                date: date,
                odometerKm: odometerKm,
                type: type,
                description: description,
                cost: cost,
                workshop: workshop,
                nextServiceDate: nextServiceDate,
                nextServiceKm: nextServiceKm,
                notes: notes,
                oilType: oilType,
                oilViscosity: oilViscosity,
                maintenanceItems: maintenanceItems,
                calendarEventId: calendarEventId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> motoId = const Value.absent(),
                required DateTime date,
                required int odometerKm,
                required String type,
                required String description,
                Value<double?> cost = const Value.absent(),
                Value<String?> workshop = const Value.absent(),
                Value<DateTime?> nextServiceDate = const Value.absent(),
                Value<int?> nextServiceKm = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> oilType = const Value.absent(),
                Value<String?> oilViscosity = const Value.absent(),
                Value<String?> maintenanceItems = const Value.absent(),
                Value<String?> calendarEventId = const Value.absent(),
              }) => MaintenanceRecordsCompanion.insert(
                id: id,
                motoId: motoId,
                date: date,
                odometerKm: odometerKm,
                type: type,
                description: description,
                cost: cost,
                workshop: workshop,
                nextServiceDate: nextServiceDate,
                nextServiceKm: nextServiceKm,
                notes: notes,
                oilType: oilType,
                oilViscosity: oilViscosity,
                maintenanceItems: maintenanceItems,
                calendarEventId: calendarEventId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MaintenanceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceRecordsTable,
      MaintenanceRecord,
      $$MaintenanceRecordsTableFilterComposer,
      $$MaintenanceRecordsTableOrderingComposer,
      $$MaintenanceRecordsTableAnnotationComposer,
      $$MaintenanceRecordsTableCreateCompanionBuilder,
      $$MaintenanceRecordsTableUpdateCompanionBuilder,
      (
        MaintenanceRecord,
        BaseReferences<
          _$AppDatabase,
          $MaintenanceRecordsTable,
          MaintenanceRecord
        >,
      ),
      MaintenanceRecord,
      PrefetchHooks Function()
    >;
typedef $$PartRecordsTableCreateCompanionBuilder =
    PartRecordsCompanion Function({
      Value<int> id,
      Value<int?> motoId,
      required String name,
      required int intervalKm,
      required int lastChangedKm,
      required DateTime lastChangedDate,
      Value<double?> cost,
      Value<bool> isActive,
      Value<String?> partCategory,
      Value<String?> filterType,
      Value<String?> brakeType,
      Value<String?> tireType,
      Value<String?> chainType,
      Value<bool> requiresComboChange,
    });
typedef $$PartRecordsTableUpdateCompanionBuilder =
    PartRecordsCompanion Function({
      Value<int> id,
      Value<int?> motoId,
      Value<String> name,
      Value<int> intervalKm,
      Value<int> lastChangedKm,
      Value<DateTime> lastChangedDate,
      Value<double?> cost,
      Value<bool> isActive,
      Value<String?> partCategory,
      Value<String?> filterType,
      Value<String?> brakeType,
      Value<String?> tireType,
      Value<String?> chainType,
      Value<bool> requiresComboChange,
    });

class $$PartRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PartRecordsTable> {
  $$PartRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get motoId => $composableBuilder(
    column: $table.motoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalKm => $composableBuilder(
    column: $table.intervalKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastChangedKm => $composableBuilder(
    column: $table.lastChangedKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastChangedDate => $composableBuilder(
    column: $table.lastChangedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partCategory => $composableBuilder(
    column: $table.partCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filterType => $composableBuilder(
    column: $table.filterType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brakeType => $composableBuilder(
    column: $table.brakeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tireType => $composableBuilder(
    column: $table.tireType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chainType => $composableBuilder(
    column: $table.chainType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresComboChange => $composableBuilder(
    column: $table.requiresComboChange,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PartRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartRecordsTable> {
  $$PartRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get motoId => $composableBuilder(
    column: $table.motoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalKm => $composableBuilder(
    column: $table.intervalKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastChangedKm => $composableBuilder(
    column: $table.lastChangedKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastChangedDate => $composableBuilder(
    column: $table.lastChangedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partCategory => $composableBuilder(
    column: $table.partCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filterType => $composableBuilder(
    column: $table.filterType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brakeType => $composableBuilder(
    column: $table.brakeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tireType => $composableBuilder(
    column: $table.tireType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chainType => $composableBuilder(
    column: $table.chainType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresComboChange => $composableBuilder(
    column: $table.requiresComboChange,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartRecordsTable> {
  $$PartRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get motoId =>
      $composableBuilder(column: $table.motoId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get intervalKm => $composableBuilder(
    column: $table.intervalKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastChangedKm => $composableBuilder(
    column: $table.lastChangedKm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastChangedDate => $composableBuilder(
    column: $table.lastChangedDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get partCategory => $composableBuilder(
    column: $table.partCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filterType => $composableBuilder(
    column: $table.filterType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brakeType =>
      $composableBuilder(column: $table.brakeType, builder: (column) => column);

  GeneratedColumn<String> get tireType =>
      $composableBuilder(column: $table.tireType, builder: (column) => column);

  GeneratedColumn<String> get chainType =>
      $composableBuilder(column: $table.chainType, builder: (column) => column);

  GeneratedColumn<bool> get requiresComboChange => $composableBuilder(
    column: $table.requiresComboChange,
    builder: (column) => column,
  );
}

class $$PartRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartRecordsTable,
          PartRecord,
          $$PartRecordsTableFilterComposer,
          $$PartRecordsTableOrderingComposer,
          $$PartRecordsTableAnnotationComposer,
          $$PartRecordsTableCreateCompanionBuilder,
          $$PartRecordsTableUpdateCompanionBuilder,
          (
            PartRecord,
            BaseReferences<_$AppDatabase, $PartRecordsTable, PartRecord>,
          ),
          PartRecord,
          PrefetchHooks Function()
        > {
  $$PartRecordsTableTableManager(_$AppDatabase db, $PartRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> motoId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> intervalKm = const Value.absent(),
                Value<int> lastChangedKm = const Value.absent(),
                Value<DateTime> lastChangedDate = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> partCategory = const Value.absent(),
                Value<String?> filterType = const Value.absent(),
                Value<String?> brakeType = const Value.absent(),
                Value<String?> tireType = const Value.absent(),
                Value<String?> chainType = const Value.absent(),
                Value<bool> requiresComboChange = const Value.absent(),
              }) => PartRecordsCompanion(
                id: id,
                motoId: motoId,
                name: name,
                intervalKm: intervalKm,
                lastChangedKm: lastChangedKm,
                lastChangedDate: lastChangedDate,
                cost: cost,
                isActive: isActive,
                partCategory: partCategory,
                filterType: filterType,
                brakeType: brakeType,
                tireType: tireType,
                chainType: chainType,
                requiresComboChange: requiresComboChange,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> motoId = const Value.absent(),
                required String name,
                required int intervalKm,
                required int lastChangedKm,
                required DateTime lastChangedDate,
                Value<double?> cost = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> partCategory = const Value.absent(),
                Value<String?> filterType = const Value.absent(),
                Value<String?> brakeType = const Value.absent(),
                Value<String?> tireType = const Value.absent(),
                Value<String?> chainType = const Value.absent(),
                Value<bool> requiresComboChange = const Value.absent(),
              }) => PartRecordsCompanion.insert(
                id: id,
                motoId: motoId,
                name: name,
                intervalKm: intervalKm,
                lastChangedKm: lastChangedKm,
                lastChangedDate: lastChangedDate,
                cost: cost,
                isActive: isActive,
                partCategory: partCategory,
                filterType: filterType,
                brakeType: brakeType,
                tireType: tireType,
                chainType: chainType,
                requiresComboChange: requiresComboChange,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PartRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartRecordsTable,
      PartRecord,
      $$PartRecordsTableFilterComposer,
      $$PartRecordsTableOrderingComposer,
      $$PartRecordsTableAnnotationComposer,
      $$PartRecordsTableCreateCompanionBuilder,
      $$PartRecordsTableUpdateCompanionBuilder,
      (
        PartRecord,
        BaseReferences<_$AppDatabase, $PartRecordsTable, PartRecord>,
      ),
      PartRecord,
      PrefetchHooks Function()
    >;
typedef $$MotoProfileTableCreateCompanionBuilder =
    MotoProfileCompanion Function({
      Value<int> id,
      required String brand,
      required String model,
      required int year,
      required int currentKm,
      Value<String?> plate,
      Value<String> engineType,
      Value<String?> twoStrokeOilMethod,
      Value<int?> displacement,
      Value<String> fuelSystem,
      Value<String> coolingType,
      Value<String?> oilType,
      Value<String?> oilViscosity,
      Value<String> oilFilterType,
      Value<String> transmissionType,
      Value<String> rimType,
      Value<double?> tankCapacity,
      Value<bool> isActive,
      required DateTime updatedAt,
    });
typedef $$MotoProfileTableUpdateCompanionBuilder =
    MotoProfileCompanion Function({
      Value<int> id,
      Value<String> brand,
      Value<String> model,
      Value<int> year,
      Value<int> currentKm,
      Value<String?> plate,
      Value<String> engineType,
      Value<String?> twoStrokeOilMethod,
      Value<int?> displacement,
      Value<String> fuelSystem,
      Value<String> coolingType,
      Value<String?> oilType,
      Value<String?> oilViscosity,
      Value<String> oilFilterType,
      Value<String> transmissionType,
      Value<String> rimType,
      Value<double?> tankCapacity,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
    });

class $$MotoProfileTableFilterComposer
    extends Composer<_$AppDatabase, $MotoProfileTable> {
  $$MotoProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentKm => $composableBuilder(
    column: $table.currentKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get twoStrokeOilMethod => $composableBuilder(
    column: $table.twoStrokeOilMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displacement => $composableBuilder(
    column: $table.displacement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelSystem => $composableBuilder(
    column: $table.fuelSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coolingType => $composableBuilder(
    column: $table.coolingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oilType => $composableBuilder(
    column: $table.oilType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oilViscosity => $composableBuilder(
    column: $table.oilViscosity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oilFilterType => $composableBuilder(
    column: $table.oilFilterType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transmissionType => $composableBuilder(
    column: $table.transmissionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rimType => $composableBuilder(
    column: $table.rimType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MotoProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $MotoProfileTable> {
  $$MotoProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentKm => $composableBuilder(
    column: $table.currentKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get twoStrokeOilMethod => $composableBuilder(
    column: $table.twoStrokeOilMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displacement => $composableBuilder(
    column: $table.displacement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelSystem => $composableBuilder(
    column: $table.fuelSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coolingType => $composableBuilder(
    column: $table.coolingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oilType => $composableBuilder(
    column: $table.oilType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oilViscosity => $composableBuilder(
    column: $table.oilViscosity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oilFilterType => $composableBuilder(
    column: $table.oilFilterType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transmissionType => $composableBuilder(
    column: $table.transmissionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rimType => $composableBuilder(
    column: $table.rimType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MotoProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $MotoProfileTable> {
  $$MotoProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get currentKm =>
      $composableBuilder(column: $table.currentKm, builder: (column) => column);

  GeneratedColumn<String> get plate =>
      $composableBuilder(column: $table.plate, builder: (column) => column);

  GeneratedColumn<String> get engineType => $composableBuilder(
    column: $table.engineType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get twoStrokeOilMethod => $composableBuilder(
    column: $table.twoStrokeOilMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displacement => $composableBuilder(
    column: $table.displacement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fuelSystem => $composableBuilder(
    column: $table.fuelSystem,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coolingType => $composableBuilder(
    column: $table.coolingType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get oilType =>
      $composableBuilder(column: $table.oilType, builder: (column) => column);

  GeneratedColumn<String> get oilViscosity => $composableBuilder(
    column: $table.oilViscosity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get oilFilterType => $composableBuilder(
    column: $table.oilFilterType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transmissionType => $composableBuilder(
    column: $table.transmissionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rimType =>
      $composableBuilder(column: $table.rimType, builder: (column) => column);

  GeneratedColumn<double> get tankCapacity => $composableBuilder(
    column: $table.tankCapacity,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MotoProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MotoProfileTable,
          MotoProfileData,
          $$MotoProfileTableFilterComposer,
          $$MotoProfileTableOrderingComposer,
          $$MotoProfileTableAnnotationComposer,
          $$MotoProfileTableCreateCompanionBuilder,
          $$MotoProfileTableUpdateCompanionBuilder,
          (
            MotoProfileData,
            BaseReferences<_$AppDatabase, $MotoProfileTable, MotoProfileData>,
          ),
          MotoProfileData,
          PrefetchHooks Function()
        > {
  $$MotoProfileTableTableManager(_$AppDatabase db, $MotoProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MotoProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MotoProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MotoProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> currentKm = const Value.absent(),
                Value<String?> plate = const Value.absent(),
                Value<String> engineType = const Value.absent(),
                Value<String?> twoStrokeOilMethod = const Value.absent(),
                Value<int?> displacement = const Value.absent(),
                Value<String> fuelSystem = const Value.absent(),
                Value<String> coolingType = const Value.absent(),
                Value<String?> oilType = const Value.absent(),
                Value<String?> oilViscosity = const Value.absent(),
                Value<String> oilFilterType = const Value.absent(),
                Value<String> transmissionType = const Value.absent(),
                Value<String> rimType = const Value.absent(),
                Value<double?> tankCapacity = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MotoProfileCompanion(
                id: id,
                brand: brand,
                model: model,
                year: year,
                currentKm: currentKm,
                plate: plate,
                engineType: engineType,
                twoStrokeOilMethod: twoStrokeOilMethod,
                displacement: displacement,
                fuelSystem: fuelSystem,
                coolingType: coolingType,
                oilType: oilType,
                oilViscosity: oilViscosity,
                oilFilterType: oilFilterType,
                transmissionType: transmissionType,
                rimType: rimType,
                tankCapacity: tankCapacity,
                isActive: isActive,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String brand,
                required String model,
                required int year,
                required int currentKm,
                Value<String?> plate = const Value.absent(),
                Value<String> engineType = const Value.absent(),
                Value<String?> twoStrokeOilMethod = const Value.absent(),
                Value<int?> displacement = const Value.absent(),
                Value<String> fuelSystem = const Value.absent(),
                Value<String> coolingType = const Value.absent(),
                Value<String?> oilType = const Value.absent(),
                Value<String?> oilViscosity = const Value.absent(),
                Value<String> oilFilterType = const Value.absent(),
                Value<String> transmissionType = const Value.absent(),
                Value<String> rimType = const Value.absent(),
                Value<double?> tankCapacity = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime updatedAt,
              }) => MotoProfileCompanion.insert(
                id: id,
                brand: brand,
                model: model,
                year: year,
                currentKm: currentKm,
                plate: plate,
                engineType: engineType,
                twoStrokeOilMethod: twoStrokeOilMethod,
                displacement: displacement,
                fuelSystem: fuelSystem,
                coolingType: coolingType,
                oilType: oilType,
                oilViscosity: oilViscosity,
                oilFilterType: oilFilterType,
                transmissionType: transmissionType,
                rimType: rimType,
                tankCapacity: tankCapacity,
                isActive: isActive,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MotoProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MotoProfileTable,
      MotoProfileData,
      $$MotoProfileTableFilterComposer,
      $$MotoProfileTableOrderingComposer,
      $$MotoProfileTableAnnotationComposer,
      $$MotoProfileTableCreateCompanionBuilder,
      $$MotoProfileTableUpdateCompanionBuilder,
      (
        MotoProfileData,
        BaseReferences<_$AppDatabase, $MotoProfileTable, MotoProfileData>,
      ),
      MotoProfileData,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$PartHistoryTableCreateCompanionBuilder =
    PartHistoryCompanion Function({
      Value<int> id,
      required int partId,
      Value<int?> motoId,
      required String partName,
      required int km,
      required DateTime changedAt,
      Value<double?> cost,
      Value<String?> notes,
    });
typedef $$PartHistoryTableUpdateCompanionBuilder =
    PartHistoryCompanion Function({
      Value<int> id,
      Value<int> partId,
      Value<int?> motoId,
      Value<String> partName,
      Value<int> km,
      Value<DateTime> changedAt,
      Value<double?> cost,
      Value<String?> notes,
    });

class $$PartHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PartHistoryTable> {
  $$PartHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get motoId => $composableBuilder(
    column: $table.motoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partName => $composableBuilder(
    column: $table.partName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get km => $composableBuilder(
    column: $table.km,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PartHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PartHistoryTable> {
  $$PartHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get motoId => $composableBuilder(
    column: $table.motoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partName => $composableBuilder(
    column: $table.partName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get km => $composableBuilder(
    column: $table.km,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartHistoryTable> {
  $$PartHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get partId =>
      $composableBuilder(column: $table.partId, builder: (column) => column);

  GeneratedColumn<int> get motoId =>
      $composableBuilder(column: $table.motoId, builder: (column) => column);

  GeneratedColumn<String> get partName =>
      $composableBuilder(column: $table.partName, builder: (column) => column);

  GeneratedColumn<int> get km =>
      $composableBuilder(column: $table.km, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$PartHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartHistoryTable,
          PartHistoryData,
          $$PartHistoryTableFilterComposer,
          $$PartHistoryTableOrderingComposer,
          $$PartHistoryTableAnnotationComposer,
          $$PartHistoryTableCreateCompanionBuilder,
          $$PartHistoryTableUpdateCompanionBuilder,
          (
            PartHistoryData,
            BaseReferences<_$AppDatabase, $PartHistoryTable, PartHistoryData>,
          ),
          PartHistoryData,
          PrefetchHooks Function()
        > {
  $$PartHistoryTableTableManager(_$AppDatabase db, $PartHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> partId = const Value.absent(),
                Value<int?> motoId = const Value.absent(),
                Value<String> partName = const Value.absent(),
                Value<int> km = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => PartHistoryCompanion(
                id: id,
                partId: partId,
                motoId: motoId,
                partName: partName,
                km: km,
                changedAt: changedAt,
                cost: cost,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int partId,
                Value<int?> motoId = const Value.absent(),
                required String partName,
                required int km,
                required DateTime changedAt,
                Value<double?> cost = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => PartHistoryCompanion.insert(
                id: id,
                partId: partId,
                motoId: motoId,
                partName: partName,
                km: km,
                changedAt: changedAt,
                cost: cost,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PartHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartHistoryTable,
      PartHistoryData,
      $$PartHistoryTableFilterComposer,
      $$PartHistoryTableOrderingComposer,
      $$PartHistoryTableAnnotationComposer,
      $$PartHistoryTableCreateCompanionBuilder,
      $$PartHistoryTableUpdateCompanionBuilder,
      (
        PartHistoryData,
        BaseReferences<_$AppDatabase, $PartHistoryTable, PartHistoryData>,
      ),
      PartHistoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FuelRecordsTableTableManager get fuelRecords =>
      $$FuelRecordsTableTableManager(_db, _db.fuelRecords);
  $$MaintenanceRecordsTableTableManager get maintenanceRecords =>
      $$MaintenanceRecordsTableTableManager(_db, _db.maintenanceRecords);
  $$PartRecordsTableTableManager get partRecords =>
      $$PartRecordsTableTableManager(_db, _db.partRecords);
  $$MotoProfileTableTableManager get motoProfile =>
      $$MotoProfileTableTableManager(_db, _db.motoProfile);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$PartHistoryTableTableManager get partHistory =>
      $$PartHistoryTableTableManager(_db, _db.partHistory);
}
