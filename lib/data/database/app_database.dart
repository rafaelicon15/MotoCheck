import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ─── Tablas ───────────────────────────────────────────────────────────────────

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class FuelRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get motoId => integer().nullable()();
  DateTimeColumn get date => dateTime()();
  RealColumn get liters => real()();
  RealColumn get pricePerLiter => real().nullable()();
  IntColumn get odometerKm => integer()();
  TextColumn get fuelType => text()(); // Regular / Premium
  BoolColumn get usedOctaneBooster =>
      boolean().withDefault(const Constant(false))();
  TextColumn get octaneBrand => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isFull => boolean().withDefault(const Constant(true))();
}

class MaintenanceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get motoId => integer().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get odometerKm => integer()();
  TextColumn get type => text()();
  TextColumn get description => text()();
  RealColumn get cost => real().nullable()();
  TextColumn get workshop => text().nullable()();
  DateTimeColumn get nextServiceDate => dateTime().nullable()();
  IntColumn get nextServiceKm => integer().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get oilType => text().nullable()();
  TextColumn get oilViscosity => text().nullable()();
  TextColumn get maintenanceItems =>
      text().nullable()(); // comma-separated selected items
  TextColumn get calendarEventId => text().nullable()();
}

class PartRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get motoId => integer().nullable()();
  TextColumn get name => text()();
  IntColumn get intervalKm => integer()();
  IntColumn get lastChangedKm => integer()();
  DateTimeColumn get lastChangedDate => dateTime()();
  RealColumn get cost => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get partCategory => text().nullable()();
  TextColumn get filterType =>
      text().nullable()(); // 'replaceable' | 'permanent'
  TextColumn get brakeType => text().nullable()(); // 'pads' | 'bands'
  TextColumn get tireType =>
      text().nullable()(); // 'standard' | 'sealant' | 'tube' | 'tubeless'
  TextColumn get chainType =>
      text().nullable()(); // 'standard' | 'o_ring' | 'x_ring' | 'w_ring'
  BoolColumn get requiresComboChange =>
      boolean().withDefault(const Constant(false))();
}

class PartHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer()();
  IntColumn get motoId => integer().nullable()();
  TextColumn get partName => text()();
  IntColumn get km => integer()();
  DateTimeColumn get changedAt => dateTime()();
  RealColumn get cost => real().nullable()();
  TextColumn get notes => text().nullable()();
}

class MotoProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  IntColumn get year => integer()();
  IntColumn get currentKm => integer()();
  TextColumn get plate => text().nullable()();
  // Motor
  TextColumn get engineType =>
      text().withDefault(const Constant('4T'))(); // '4T' | '2T'
  TextColumn get twoStrokeOilMethod =>
      text().nullable()(); // 'autolube' | 'premix' | null
  IntColumn get displacement => integer().nullable()(); // cilindrada en cc
  TextColumn get fuelSystem =>
      text().withDefault(const Constant('carb'))(); // 'carb' | 'injection'
  // Refrigeración
  TextColumn get coolingType =>
      text().withDefault(const Constant('air'))(); // 'air' | 'liquid'
  // Aceite (4T)
  TextColumn get oilType => text().nullable()();
  TextColumn get oilViscosity => text().nullable()();
  TextColumn get oilFilterType => text().withDefault(
    const Constant('replaceable'),
  )(); // 'replaceable' | 'permanent'
  // Transmisión
  TextColumn get transmissionType => text().withDefault(
    const Constant('chain'),
  )(); // 'chain' | 'shaft' | 'belt'
  // Rines
  TextColumn get rimType => text().withDefault(
    const Constant('alloy'),
  )(); // 'alloy' | 'spoke' | 'spoke_double_wall'
  // Tanque
  RealColumn get tankCapacity => real().nullable()(); // capacidad en litros
  // Estado
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();
}

// ─── Base de datos ────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [
    FuelRecords,
    MaintenanceRecords,
    PartRecords,
    MotoProfile,
    AppSettings,
    PartHistory,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Permite inyectar un executor en pruebas; en producción usa Drift local.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Historial documentado: v8 agregó PartHistory, v9 agregó isFull
      // a FuelRecords, v10 agregó rimType a MotoProfile y v11 agregó
      // calendarEventId a MaintenanceRecords. Todas son aditivas.
      if (from < 8) {
        await m.createTable(partHistory);
      }
      if (from < 9) {
        await m.addColumn(fuelRecords, fuelRecords.isFull);
      }
      if (from < 10) {
        await m.addColumn(motoProfile, motoProfile.rimType);
      }
      if (from < 11) {
        await m.addColumn(
          maintenanceRecords,
          maintenanceRecords.calendarEventId,
        );
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'motocheck_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  // ─── Moto Profile ──────────────────────────────────────────────────────────

  Stream<List<MotoProfileData>> watchAllMotos() =>
      (select(motoProfile)..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();

  Stream<MotoProfileData?> watchActiveMoto() =>
      (select(motoProfile)
            ..where((t) => t.isActive.equals(true))
            ..limit(1))
          .watchSingleOrNull();

  Future<MotoProfileData?> getActiveMoto() =>
      (select(motoProfile)
            ..where((t) => t.isActive.equals(true))
            ..limit(1))
          .getSingleOrNull();

  Future<void> setActiveMoto(int id) async {
    await (update(
      motoProfile,
    )).write(const MotoProfileCompanion(isActive: Value(false)));
    await (update(motoProfile)..where((t) => t.id.equals(id))).write(
      MotoProfileCompanion(
        isActive: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> insertMoto(MotoProfileCompanion m) => into(motoProfile).insert(m);

  Future<bool> updateMoto(MotoProfileData m) => update(motoProfile).replace(m);

  Future<void> updateMotoCurrentKmIfGreater(int? motoId, int currentKm) async {
    if (motoId == null) return;
    final moto = await (select(
      motoProfile,
    )..where((t) => t.id.equals(motoId))).getSingleOrNull();
    if (moto == null || currentKm <= moto.currentKm) return;

    await updateMoto(
      moto.copyWith(currentKm: currentKm, updatedAt: DateTime.now()),
    );
  }

  Future<int> deleteMoto(int id) async {
    return transaction(() async {
      final moto = await (select(
        motoProfile,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      final deleted = await (delete(
        motoProfile,
      )..where((t) => t.id.equals(id))).go();

      await (delete(partHistory)..where((t) => t.motoId.equals(id))).go();
      await (delete(partRecords)..where((t) => t.motoId.equals(id))).go();
      await (delete(
        maintenanceRecords,
      )..where((t) => t.motoId.equals(id))).go();
      await (delete(fuelRecords)..where((t) => t.motoId.equals(id))).go();

      if (moto?.isActive == true) {
        final nextMoto =
            await (select(motoProfile)
                  ..orderBy([(t) => OrderingTerm.asc(t.id)])
                  ..limit(1))
                .getSingleOrNull();
        if (nextMoto != null) {
          await setActiveMoto(nextMoto.id);
        }
      }

      return deleted;
    });
  }

  // ─── Fuel ──────────────────────────────────────────────────────────────────

  Stream<List<FuelRecord>> watchFuelRecords(int? motoId) {
    if (motoId == null) {
      return (select(
        fuelRecords,
      )..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();
    }
    return (select(fuelRecords)
          ..where((t) => t.motoId.equals(motoId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<int> insertFuelRecord(FuelRecordsCompanion record) =>
      into(fuelRecords).insert(record);

  Future<bool> updateFuelRecord(FuelRecord record) =>
      update(fuelRecords).replace(record);

  Future<int> deleteFuelRecord(int id) =>
      (delete(fuelRecords)..where((t) => t.id.equals(id))).go();

  Future<List<FuelRecord>> getLastTwoFuelRecords(int? motoId) {
    if (motoId == null) {
      return (select(fuelRecords)
            ..orderBy([(t) => OrderingTerm.desc(t.odometerKm)])
            ..limit(2))
          .get();
    }
    return (select(fuelRecords)
          ..where((t) => t.motoId.equals(motoId))
          ..orderBy([(t) => OrderingTerm.desc(t.odometerKm)])
          ..limit(2))
        .get();
  }

  // ─── Maintenance ───────────────────────────────────────────────────────────

  Stream<List<MaintenanceRecord>> watchMaintenanceRecords(int? motoId) {
    if (motoId == null) {
      return (select(
        maintenanceRecords,
      )..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();
    }
    return (select(maintenanceRecords)
          ..where((t) => t.motoId.equals(motoId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<int> insertMaintenance(MaintenanceRecordsCompanion record) =>
      into(maintenanceRecords).insert(record);

  Future<bool> updateMaintenance(MaintenanceRecord record) =>
      update(maintenanceRecords).replace(record);

  Future<int> deleteMaintenance(int id) =>
      (delete(maintenanceRecords)..where((t) => t.id.equals(id))).go();

  // ─── Parts ─────────────────────────────────────────────────────────────────

  Stream<List<PartRecord>> watchParts(int? motoId) {
    if (motoId == null) {
      return (select(
        partRecords,
      )..where((t) => t.isActive.equals(true))).watch();
    }
    return (select(
      partRecords,
    )..where((t) => t.isActive.equals(true) & t.motoId.equals(motoId))).watch();
  }

  Future<List<PartRecord>> getPartsByCategory(int? motoId, String category) {
    if (motoId == null) {
      return (select(partRecords)..where(
            (t) => t.isActive.equals(true) & t.partCategory.equals(category),
          ))
          .get();
    }
    return (select(partRecords)..where(
          (t) =>
              t.isActive.equals(true) &
              t.motoId.equals(motoId) &
              t.partCategory.equals(category),
        ))
        .get();
  }

  Future<int> markPartsServicedFromMaintenance({
    required int? motoId,
    required Iterable<String> maintenanceItems,
    required int odometerKm,
    required DateTime changedAt,
    double? cost,
  }) async {
    if (motoId == null || odometerKm <= 0) return 0;

    final parts = await (select(
      partRecords,
    )..where((t) => t.isActive.equals(true) & t.motoId.equals(motoId))).get();
    final matched = <int, PartRecord>{};

    bool hasAny(String text, List<String> needles) {
      final lower = text.toLowerCase();
      return needles.any(lower.contains);
    }

    for (final item in maintenanceItems) {
      final lower = item.toLowerCase();
      bool matches(PartRecord part) {
        final name = part.name.toLowerCase();
        final category = part.partCategory;

        if (lower == 'cambio de aceite') {
          return category == 'oil' ||
              hasAny(name, ['aceite del motor', 'aceite 2t']);
        }
        if (lower == 'cambio de filtro de aceite') {
          return category == 'oil_filter' && part.filterType != 'permanent';
        }
        if (lower.contains('buj')) return hasAny(name, ['buj']);
        if (lower.contains('filtro de aire')) {
          return hasAny(name, ['filtro de aire']);
        }
        if (lower.contains('filtro de gasolina')) {
          return category == 'fuel_filter';
        }
        if (lower.contains('empaque tapa de válvulas') ||
            lower.contains('empaque tapa de valvulas')) {
          return category == 'gasket' &&
              hasAny(name, ['tapa de válvulas', 'tapa de valvulas']);
        }
        if (lower.contains('líquido de frenos') ||
            lower.contains('liquido de frenos')) {
          return hasAny(name, ['líquido de frenos', 'liquido de frenos']);
        }
        if (lower.contains('pastillas') &&
            !lower.contains('válvula') &&
            !lower.contains('valvula') &&
            !lower.contains('shims')) {
          return part.brakeType == 'pads';
        }
        if (lower.contains('bandas')) return part.brakeType == 'bands';
        if (lower.contains('piñón') ||
            lower.contains('pinon') ||
            lower.contains('corona')) {
          return category == 'sprocket' ||
              hasAny(name, ['piñón', 'pinon', 'corona']);
        }
        if (lower.contains('cadena') &&
            lower.contains('cambio') &&
            !lower.contains('cadena de tiempo')) {
          return category == 'chain';
        }

        if (lower.contains('discos de clutch') ||
            lower.contains('discos de crochet')) {
          return category == 'clutch' && hasAny(name, ['discos']);
        }
        if (lower.contains('separadores')) {
          return category == 'clutch' && hasAny(name, ['separadores']);
        }
        if (lower.contains('estrella') || lower.contains('plato prensador')) {
          return category == 'clutch' &&
              hasAny(name, ['estrella', 'plato prensador']);
        }
        if (lower.contains('campana') || lower.contains('canasta')) {
          return category == 'clutch' && hasAny(name, ['campana', 'canasta']);
        }
        if (lower.contains('maza') || lower.contains('cubo')) {
          return category == 'clutch' && hasAny(name, ['maza', 'cubo']);
        }
        if (lower.contains('resortes de clutch')) {
          return category == 'clutch' && hasAny(name, ['resortes']);
        }

        if (lower.contains('árbol de levas') ||
            lower.contains('arbol de levas')) {
          return category == 'engine_timing' &&
              hasAny(name, ['árbol de levas', 'arbol de levas']);
        }
        if (lower.contains('tensor de cadena de tiempo')) {
          return category == 'engine_timing' && hasAny(name, ['tensor']);
        }
        if (lower.contains('guías') ||
            lower.contains('guias') ||
            lower.contains('patines')) {
          return category == 'engine_timing' &&
              hasAny(name, ['guías', 'guias', 'patines']);
        }
        if (lower.contains('cadena de tiempo')) {
          return category == 'engine_timing' && name == 'cadena de tiempo';
        }
        if (lower.contains('balancines') || lower.contains('seguidores')) {
          return category == 'valvetrain' &&
              hasAny(name, ['balancines', 'seguidores']);
        }
        if (lower.contains('pastillas') || lower.contains('shims')) {
          return category == 'valvetrain' &&
              hasAny(name, ['pastillas', 'shims']);
        }
        if (lower.contains('válvulas de admisión') ||
            lower.contains('valvulas de admision')) {
          return category == 'valvetrain' &&
              hasAny(name, ['admisión', 'admision']);
        }
        if (lower.contains('válvulas de escape') ||
            lower.contains('valvulas de escape')) {
          return category == 'valvetrain' && hasAny(name, ['escape']);
        }
        if (lower.contains('retenes de válvula') ||
            lower.contains('retenes de valvula')) {
          return category == 'valvetrain' && hasAny(name, ['retenes']);
        }
        if (lower.contains('calibración de válvulas') ||
            lower.contains('calibracion de valvulas') ||
            lower.contains('puntería') ||
            lower.contains('punteria')) {
          return category == 'valvetrain' &&
              hasAny(name, ['pastillas', 'shims', 'balancines', 'seguidores']);
        }

        if (lower.contains('pistón') || lower.contains('piston')) {
          return category == 'engine_internal' &&
              hasAny(name, ['pistón', 'piston']);
        }
        if (lower.contains('anillos') || lower.contains('segmentos')) {
          return category == 'engine_internal' &&
              hasAny(name, ['anillos', 'segmentos']);
        }
        if (lower.contains('cilindro') || lower.contains('camisa')) {
          return category == 'engine_internal' &&
              hasAny(name, ['cilindro', 'camisa']);
        }
        if (lower.contains('biela')) {
          return category == 'engine_internal' && hasAny(name, ['biela']);
        }
        if (lower.contains('retenes de cigüeñal') ||
            lower.contains('retenes de ciguenal')) {
          return category == 'engine_internal' && hasAny(name, ['retenes']);
        }
        if (lower.contains('cigüeñal') || lower.contains('ciguenal')) {
          return category == 'engine_internal' && name == 'cigüeñal';
        }
        if (lower.contains('bomba de aceite')) {
          return category == 'engine_internal' &&
              hasAny(name, ['bomba de aceite']);
        }
        if (lower.contains('bomba de agua') || lower.contains('refrigerante')) {
          return category == 'engine_internal' &&
              hasAny(name, ['bomba de agua', 'refrigerante']);
        }

        if (lower.contains('retenes de barras')) {
          return category == 'fork' && hasAny(name, ['reten']);
        }
        if (lower.contains('guardapolvos')) {
          return category == 'fork' && hasAny(name, ['guardapolvo']);
        }
        if (lower.contains('aceite de barras')) {
          return category == 'fork' && hasAny(name, ['aceite']);
        }
        if (lower.contains('bujes de barras')) {
          return category == 'fork' && hasAny(name, ['bujes']);
        }
        if (lower.contains('mantenimiento de barras')) {
          return category == 'fork';
        }

        if (lower.contains('rodamiento rueda delantera')) {
          return category == 'bearing' && hasAny(name, ['delantera']);
        }
        if (lower.contains('rodamiento rueda trasera')) {
          return category == 'bearing' && hasAny(name, ['trasera']);
        }
        if (lower.contains('rodamiento de dirección') ||
            lower.contains('rodamiento de direccion')) {
          return category == 'bearing' &&
              hasAny(name, ['dirección', 'direccion']);
        }
        if (lower.contains('rodamiento tijera') ||
            lower.contains('basculante')) {
          return category == 'bearing' &&
              hasAny(name, ['tijera', 'basculante']);
        }

        if (lower.contains('magneto') || lower.contains('estator')) {
          return category == 'electrical' &&
              hasAny(name, ['magneto', 'estator']);
        }
        if (lower.contains('cdi') || lower.contains('ecu')) {
          return category == 'electrical' && hasAny(name, ['cdi', 'ecu']);
        }
        if (lower.contains('regulador') || lower.contains('rectificador')) {
          return category == 'electrical' &&
              hasAny(name, ['regulador', 'rectificador']);
        }
        if (lower.contains('bobina')) {
          return category == 'electrical' && hasAny(name, ['bobina']);
        }
        if (lower.contains('capuchón') || lower.contains('capuchon')) {
          return category == 'electrical' && hasAny(name, ['capuch']);
        }

        return false;
      }

      for (final part in parts.where(matches)) {
        matched[part.id] = part;
      }
    }

    for (final part in matched.values) {
      await updatePart(
        part.copyWith(
          lastChangedKm: odometerKm,
          lastChangedDate: changedAt,
          cost: Value(cost),
        ),
      );
      await insertPartHistory(
        PartHistoryCompanion.insert(
          partId: part.id,
          motoId: Value(motoId),
          partName: part.name,
          km: odometerKm,
          changedAt: changedAt,
          cost: Value(cost),
          notes: const Value('Actualizado desde mantenimiento'),
        ),
      );
    }

    return matched.length;
  }

  Future<int> insertPart(PartRecordsCompanion part) =>
      into(partRecords).insert(part);

  Future<bool> updatePart(PartRecord part) => update(partRecords).replace(part);

  Future<int> deletePart(int id) =>
      (delete(partRecords)..where((t) => t.id.equals(id))).go();

  // ─── Part History ──────────────────────────────────────────────────────────

  Future<int> insertPartHistory(PartHistoryCompanion entry) =>
      into(partHistory).insert(entry);

  Future<bool> updatePartHistory(PartHistoryData entry) =>
      update(partHistory).replace(entry);

  Stream<List<PartHistoryData>> watchPartHistory(int? motoId) {
    if (motoId == null) {
      return (select(
        partHistory,
      )..orderBy([(t) => OrderingTerm.desc(t.changedAt)])).watch();
    }
    return (select(partHistory)
          ..where((t) => t.motoId.equals(motoId))
          ..orderBy([(t) => OrderingTerm.desc(t.changedAt)]))
        .watch();
  }

  Future<int> deletePartHistory(int id) =>
      (delete(partHistory)..where((t) => t.id.equals(id))).go();

  // ─── Backup / Restore ──────────────────────────────────────────────────────

  Future<Map<String, dynamic>> exportToJson() async {
    final motos = await select(motoProfile).get();
    final fuel = await select(fuelRecords).get();
    final maint = await select(maintenanceRecords).get();
    final parts = await select(partRecords).get();
    final history = await select(partHistory).get();
    final settings = await select(appSettings).get();

    return {
      'schemaVersion': schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'motos': motos
          .map(
            (m) => {
              'id': m.id,
              'brand': m.brand,
              'model': m.model,
              'year': m.year,
              'currentKm': m.currentKm,
              'plate': m.plate,
              'engineType': m.engineType,
              'twoStrokeOilMethod': m.twoStrokeOilMethod,
              'displacement': m.displacement,
              'fuelSystem': m.fuelSystem,
              'coolingType': m.coolingType,
              'oilType': m.oilType,
              'oilViscosity': m.oilViscosity,
              'oilFilterType': m.oilFilterType,
              'transmissionType': m.transmissionType,
              'rimType': m.rimType,
              'tankCapacity': m.tankCapacity,
              'isActive': m.isActive,
              'updatedAt': m.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'fuelRecords': fuel
          .map(
            (f) => {
              'id': f.id,
              'motoId': f.motoId,
              'date': f.date.toIso8601String(),
              'liters': f.liters,
              'pricePerLiter': f.pricePerLiter,
              'odometerKm': f.odometerKm,
              'fuelType': f.fuelType,
              'usedOctaneBooster': f.usedOctaneBooster,
              'octaneBrand': f.octaneBrand,
              'notes': f.notes,
              'isFull': f.isFull,
            },
          )
          .toList(),
      'maintenanceRecords': maint
          .map(
            (m) => {
              'id': m.id,
              'motoId': m.motoId,
              'date': m.date.toIso8601String(),
              'odometerKm': m.odometerKm,
              'type': m.type,
              'description': m.description,
              'cost': m.cost,
              'workshop': m.workshop,
              'nextServiceDate': m.nextServiceDate?.toIso8601String(),
              'nextServiceKm': m.nextServiceKm,
              'notes': m.notes,
              'oilType': m.oilType,
              'oilViscosity': m.oilViscosity,
              'maintenanceItems': m.maintenanceItems,
            },
          )
          .toList(),
      'partRecords': parts
          .map(
            (p) => {
              'id': p.id,
              'motoId': p.motoId,
              'name': p.name,
              'intervalKm': p.intervalKm,
              'lastChangedKm': p.lastChangedKm,
              'lastChangedDate': p.lastChangedDate.toIso8601String(),
              'cost': p.cost,
              'isActive': p.isActive,
              'partCategory': p.partCategory,
              'filterType': p.filterType,
              'brakeType': p.brakeType,
              'tireType': p.tireType,
              'chainType': p.chainType,
              'requiresComboChange': p.requiresComboChange,
            },
          )
          .toList(),
      'partHistory': history
          .map(
            (h) => {
              'id': h.id,
              'partId': h.partId,
              'motoId': h.motoId,
              'partName': h.partName,
              'km': h.km,
              'changedAt': h.changedAt.toIso8601String(),
              'cost': h.cost,
              'notes': h.notes,
            },
          )
          .toList(),
      'settings': settings
          .map((s) => {'key': s.key, 'value': s.value})
          .toList(),
    };
  }

  Future<void> importFromJson(Map<String, dynamic> data) async {
    await transaction(() async {
      await delete(partHistory).go();
      await delete(partRecords).go();
      await delete(maintenanceRecords).go();
      await delete(fuelRecords).go();
      await delete(motoProfile).go();
      await delete(appSettings).go();

      for (final raw in (data['motos'] as List<dynamic>)) {
        final m = raw as Map<String, dynamic>;
        await into(motoProfile).insert(
          MotoProfileCompanion(
            id: Value(m['id'] as int),
            brand: Value(m['brand'] as String),
            model: Value(m['model'] as String),
            year: Value(m['year'] as int),
            currentKm: Value(m['currentKm'] as int),
            updatedAt: Value(DateTime.parse(m['updatedAt'] as String)),
            plate: Value(m['plate'] as String?),
            engineType: Value(m['engineType'] as String? ?? '4T'),
            twoStrokeOilMethod: Value(m['twoStrokeOilMethod'] as String?),
            displacement: Value(m['displacement'] as int?),
            fuelSystem: Value(m['fuelSystem'] as String? ?? 'carb'),
            coolingType: Value(m['coolingType'] as String? ?? 'air'),
            oilType: Value(m['oilType'] as String?),
            oilViscosity: Value(m['oilViscosity'] as String?),
            oilFilterType: Value(
              m['oilFilterType'] as String? ?? 'replaceable',
            ),
            transmissionType: Value(
              m['transmissionType'] as String? ?? 'chain',
            ),
            rimType: Value(m['rimType'] as String? ?? 'alloy'),
            tankCapacity: Value((m['tankCapacity'] as num?)?.toDouble()),
            isActive: Value(m['isActive'] as bool? ?? false),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      for (final raw in (data['fuelRecords'] as List<dynamic>)) {
        final f = raw as Map<String, dynamic>;
        await into(fuelRecords).insert(
          FuelRecordsCompanion(
            id: Value(f['id'] as int),
            motoId: Value(f['motoId'] as int?),
            date: Value(DateTime.parse(f['date'] as String)),
            liters: Value((f['liters'] as num).toDouble()),
            pricePerLiter: Value((f['pricePerLiter'] as num?)?.toDouble()),
            odometerKm: Value(f['odometerKm'] as int),
            fuelType: Value(f['fuelType'] as String),
            usedOctaneBooster: Value(f['usedOctaneBooster'] as bool? ?? false),
            octaneBrand: Value(f['octaneBrand'] as String?),
            notes: Value(f['notes'] as String?),
            isFull: Value(f['isFull'] as bool? ?? true),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      for (final raw in (data['maintenanceRecords'] as List<dynamic>)) {
        final m = raw as Map<String, dynamic>;
        await into(maintenanceRecords).insert(
          MaintenanceRecordsCompanion(
            id: Value(m['id'] as int),
            motoId: Value(m['motoId'] as int?),
            date: Value(DateTime.parse(m['date'] as String)),
            odometerKm: Value(m['odometerKm'] as int),
            type: Value(m['type'] as String),
            description: Value(m['description'] as String),
            cost: Value((m['cost'] as num?)?.toDouble()),
            workshop: Value(m['workshop'] as String?),
            nextServiceDate: Value(
              m['nextServiceDate'] != null
                  ? DateTime.parse(m['nextServiceDate'] as String)
                  : null,
            ),
            nextServiceKm: Value(m['nextServiceKm'] as int?),
            notes: Value(m['notes'] as String?),
            oilType: Value(m['oilType'] as String?),
            oilViscosity: Value(m['oilViscosity'] as String?),
            maintenanceItems: Value(m['maintenanceItems'] as String?),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      for (final raw in (data['partRecords'] as List<dynamic>)) {
        final p = raw as Map<String, dynamic>;
        await into(partRecords).insert(
          PartRecordsCompanion(
            id: Value(p['id'] as int),
            motoId: Value(p['motoId'] as int?),
            name: Value(p['name'] as String),
            intervalKm: Value(p['intervalKm'] as int),
            lastChangedKm: Value(p['lastChangedKm'] as int),
            lastChangedDate: Value(
              DateTime.parse(p['lastChangedDate'] as String),
            ),
            cost: Value((p['cost'] as num?)?.toDouble()),
            isActive: Value(p['isActive'] as bool? ?? true),
            partCategory: Value(p['partCategory'] as String?),
            filterType: Value(p['filterType'] as String?),
            brakeType: Value(p['brakeType'] as String?),
            tireType: Value(p['tireType'] as String?),
            chainType: Value(p['chainType'] as String?),
            requiresComboChange: Value(
              p['requiresComboChange'] as bool? ?? false,
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      if (data['partHistory'] != null) {
        for (final raw in (data['partHistory'] as List<dynamic>)) {
          final h = raw as Map<String, dynamic>;
          await into(partHistory).insert(
            PartHistoryCompanion(
              id: Value(h['id'] as int),
              partId: Value(h['partId'] as int),
              motoId: Value(h['motoId'] as int?),
              partName: Value(h['partName'] as String),
              km: Value(h['km'] as int),
              changedAt: Value(DateTime.parse(h['changedAt'] as String)),
              cost: Value((h['cost'] as num?)?.toDouble()),
              notes: Value(h['notes'] as String?),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      }

      if (data['settings'] != null) {
        for (final raw in (data['settings'] as List<dynamic>)) {
          final s = raw as Map<String, dynamic>;
          await into(appSettings).insertOnConflictUpdate(
            AppSettingsCompanion.insert(
              key: s['key'] as String,
              value: s['value'] as String,
            ),
          );
        }
      }
    });
  }

  // ─── Settings ──────────────────────────────────────────────────────────────

  Future<String?> getSetting(String key) async {
    final row = await (select(
      appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(key: key, value: value),
    );
  }

  Stream<String?> watchSetting(String key) {
    return (select(appSettings)..where((t) => t.key.equals(key)))
        .watchSingleOrNull()
        .map((r) => r?.value);
  }
}
