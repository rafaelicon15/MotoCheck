import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

final activeMotoProvider = StreamProvider<MotoProfileData?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchActiveMoto();
});

final allMotosProvider = StreamProvider<List<MotoProfileData>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllMotos();
});
