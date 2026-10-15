import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../data/database/app_database.dart';

/// Recordatorios locales de mantenimiento.
///
/// - Servicios con fecha: se programan 3 días antes y el mismo día a las 9:00.
/// - Refacciones y servicios por km: aviso agrupado inmediato cuando entran en
///   rango de alerta (mismo umbral que el dashboard), una sola vez por estado.
class NotificationService {
  static const _alertKmThreshold = 500;
  static const _notifiedKey = 'notified_km_alerts';
  static const _kmAlertId = 1;
  static const _scheduledBaseId = 1000;
  static const _reminderHour = 9;

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'maintenance_reminders',
      'Recordatorios de mantenimiento',
      channelDescription: 'Avisos de servicios y refacciones próximas',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  static bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static Future<void> init() async {
    if (!_supported || _ready) return;
    try {
      tz_data.initializeTimeZones();
      await _plugin.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ));
      _ready = true;
    } catch (_) {
      // Las notificaciones nunca deben impedir que la app arranque.
    }
  }

  static Future<void> requestPermission() async {
    if (!_ready) return;
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (_) {}
  }

  /// Recalcula todos los recordatorios a partir del estado actual de la base.
  static Future<void> sync(AppDatabase db) async {
    if (!_ready) return;
    try {
      final motos = await db.select(db.motoProfile).get();
      final motoById = {for (final m in motos) m.id: m};
      final latest = _latestPerType(await db.select(db.maintenanceRecords).get());

      await _scheduleDateReminders(latest, motoById);
      await _notifyKmAlerts(db, latest, motoById);
    } catch (_) {}
  }

  /// Solo el registro más reciente de cada tipo por moto define el próximo servicio.
  static List<MaintenanceRecord> _latestPerType(List<MaintenanceRecord> records) {
    final byKey = <String, MaintenanceRecord>{};
    for (final r in records) {
      final key = '${r.motoId}|${r.type}';
      final current = byKey[key];
      if (current == null || r.date.isAfter(current.date)) byKey[key] = r;
    }
    return byKey.values.toList();
  }

  static String _motoName(MotoProfileData? moto) =>
      moto == null ? 'tu moto' : '${moto.brand} ${moto.model}';

  static Future<void> _scheduleDateReminders(
    List<MaintenanceRecord> latest,
    Map<int, MotoProfileData> motoById,
  ) async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final p in pending) {
      if (p.id >= _scheduledBaseId) await _plugin.cancel(p.id);
    }

    final now = DateTime.now();
    for (final r in latest) {
      final due = r.nextServiceDate;
      if (due == null) continue;
      final dueDay = DateTime(due.year, due.month, due.day, _reminderHour);
      final moto = _motoName(motoById[r.motoId]);
      final reminders = [
        (dueDay.subtract(const Duration(days: 3)), 'En 3 días: ${r.type}'),
        (dueDay, 'Hoy toca: ${r.type}'),
      ];
      for (var i = 0; i < reminders.length; i++) {
        final (fireAt, title) = reminders[i];
        if (!fireAt.isAfter(now)) continue;
        await _plugin.zonedSchedule(
          _scheduledBaseId + r.id * 2 + i,
          title,
          'Servicio programado para $moto.',
          tz.TZDateTime.from(fireAt, tz.UTC),
          _details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  static Future<void> _notifyKmAlerts(
    AppDatabase db,
    List<MaintenanceRecord> latest,
    Map<int, MotoProfileData> motoById,
  ) async {
    // Clave por estado: vuelve a avisar si la pieza se cambia y vence de nuevo,
    // o si pasa de "próxima" a "vencida".
    final alerts = <String, String>{};

    final parts = await (db.select(db.partRecords)
          ..where((t) => t.isActive.equals(true)))
        .get();
    for (final p in parts) {
      if (p.filterType == 'permanent') continue;
      final moto = motoById[p.motoId];
      if (moto == null) continue;
      final remaining = p.lastChangedKm + p.intervalKm - moto.currentKm;
      if (remaining > _alertKmThreshold) continue;
      alerts['p${p.id}:${p.lastChangedKm}:${remaining <= 0 ? 1 : 0}'] = p.name;
    }

    for (final r in latest) {
      final nextKm = r.nextServiceKm;
      final moto = motoById[r.motoId];
      if (nextKm == null || moto == null) continue;
      final remaining = nextKm - moto.currentKm;
      if (remaining > _alertKmThreshold) continue;
      alerts['m${r.id}:$nextKm:${remaining <= 0 ? 1 : 0}'] = r.type;
    }

    final notified = (await db.getSetting(_notifiedKey) ?? '')
        .split(',')
        .where((s) => s.isNotEmpty)
        .toSet();
    final fresh = alerts.keys.where((k) => !notified.contains(k)).toList();

    if (fresh.isNotEmpty) {
      final names = fresh.map((k) => alerts[k]!).toSet().toList();
      final title = names.length == 1
          ? '${names.first} requiere atención'
          : '${names.length} pendientes de mantenimiento';
      final shown = names.take(4).join(', ');
      final extra = names.length > 4 ? ' y ${names.length - 4} más' : '';
      await _plugin.show(
        _kmAlertId,
        title,
        'Revisa en MotoCheck: $shown$extra.',
        _details,
      );
    }

    // Solo se guardan las alertas vigentes para no crecer sin límite.
    await db.setSetting(_notifiedKey, alerts.keys.join(','));
  }
}
