// Datos de ejemplo para capturas de la landing y de Google Play.
// No forma parte del APK: se compila aparte con
//   flutter build web -t lib/demo/main_demo.dart
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../app.dart';
import '../data/database/app_database.dart';
import '../shared/providers/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  final db = AppDatabase();
  await _seed(db);
  runApp(ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: const MotoCheckApp(),
  ));
}

Future<void> _seed(AppDatabase db) async {
  if (await db.getActiveMoto() != null) return; // ya sembrada

  final now = DateTime.now();
  DateTime daysAgo(int d) => now.subtract(Duration(days: d));
  const currentKm = 26507;

  final motoId = await db.insertMoto(MotoProfileCompanion.insert(
    brand: 'Bajaj',
    model: 'NS200',
    year: 2022,
    currentKm: currentKm,
    plate: const Value('MXR-482'),
    displacement: const Value(199),
    tankCapacity: const Value(12),
    engineType: const Value('4T'),
    fuelSystem: const Value('injection'),
    coolingType: const Value('liquid'),
    oilType: const Value('Sintético'),
    oilViscosity: const Value('10W-40'),
    transmissionType: const Value('chain'),
    rimType: const Value('alloy'),
    isActive: const Value(true),
    updatedAt: now,
  ));

  // Cargas de tanque lleno cada ~330 km, con rendimiento realista (33–38 km/L).
  const fills = [
    (62, 24520, 9.1, 'Regular'),
    (53, 24860, 9.4, 'Regular'),
    (44, 25190, 9.0, 'Premium'),
    (35, 25540, 9.2, 'Premium'),
    (24, 25870, 9.6, 'Regular'),
    (14, 26190, 9.3, 'Premium'),
    (4, 26507, 8.7, 'Premium'),
  ];
  for (final (d, km, liters, type) in fills) {
    await db.insertFuelRecord(FuelRecordsCompanion.insert(
      motoId: Value(motoId),
      date: daysAgo(d),
      liters: liters,
      pricePerLiter: Value(type == 'Premium' ? 26.4 : 24.1),
      odometerKm: km,
      fuelType: type,
    ));
  }

  await db.insertMaintenance(MaintenanceRecordsCompanion.insert(
    motoId: Value(motoId),
    date: daysAgo(58),
    odometerKm: 24000,
    type: 'Servicio general',
    description: 'Cambio de aceite y filtro, limpieza de filtro de aire',
    cost: const Value(1150),
    workshop: const Value('Taller Moto Sport'),
    oilType: const Value('Sintético'),
    oilViscosity: const Value('10W-40'),
    nextServiceKm: const Value(27000),
    nextServiceDate: Value(now.add(const Duration(days: 12))),
    maintenanceItems: const Value('Cambio de aceite,Cambio de filtro de aceite'),
  ));
  await db.insertMaintenance(MaintenanceRecordsCompanion.insert(
    motoId: Value(motoId),
    date: daysAgo(120),
    odometerKm: 22300,
    type: 'Transmisión',
    description: 'Kit de arrastre nuevo (cadena O-Ring, piñón y corona)',
    cost: const Value(2380),
    workshop: const Value('Taller Moto Sport'),
  ));

  final parts = [
    ('Aceite del motor', 'oil', 3000, 24000, 58),
    ('Filtro de aceite', 'oil_filter', 6000, 24000, 58),
    ('Cadena de transmisión', 'chain', 15000, 22300, 120),
    ('Piñón y corona', 'sprocket', 15000, 22300, 120),
    ('Balatas delanteras', 'brake_front', 10000, 17100, 210),
    ('Bujía', 'electrical', 10000, 18200, 190),
    ('Llanta trasera', 'tire', 15000, 13800, 300),
    ('Líquido refrigerante', 'coolant', 20000, 12000, 330),
  ];
  for (final (name, category, interval, km, d) in parts) {
    await db.insertPart(PartRecordsCompanion.insert(
      motoId: Value(motoId),
      name: name,
      intervalKm: interval,
      lastChangedKm: km,
      lastChangedDate: daysAgo(d),
      partCategory: Value(category),
      filterType: Value(category == 'oil_filter' ? 'replaceable' : null),
      chainType: Value(category == 'chain' ? 'o_ring' : null),
      requiresComboChange: Value(category == 'chain'),
    ));
  }

  await db.setSetting('onboarding_done', 'true');
  await db.setSetting('getting_started_dismissed', 'true');
  await db.setSetting('currency', 'MXN');
}
