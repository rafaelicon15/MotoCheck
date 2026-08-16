import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

import 'calendar_result.dart';

class CalendarService {
  static final DeviceCalendarPlugin _plugin = DeviceCalendarPlugin();

  static Future<CalendarSyncResult> addMaintenanceEvent({
    required String title,
    required DateTime start,
    required String description,
    String? location,
    String? eventId,
  }) async {
    try {
      final permission = await _plugin.requestPermissions();
      if (permission.data != true) {
        return const CalendarSyncResult(CalendarResult.permissionDenied);
      }

      final calendarsResult = await _plugin.retrieveCalendars();
      if (calendarsResult.hasErrors || calendarsResult.data == null) {
        return const CalendarSyncResult(CalendarResult.failed);
      }

      final calendars = calendarsResult.data!
          .where(
            (calendar) => calendar.id != null && calendar.isReadOnly != true,
          )
          .toList(growable: false);
      if (calendars.isEmpty) {
        return const CalendarSyncResult(CalendarResult.noWritableCalendar);
      }

      final selected = calendars.firstWhere(
        (calendar) => calendar.isDefault == true,
        orElse: () => calendars.first,
      );
      final startTime = tz.TZDateTime.from(start, tz.local);
      final event = Event(
        selected.id,
        eventId: eventId,
        title: title,
        description: description,
        location: location,
        start: startTime,
        end: startTime.add(const Duration(minutes: 45)),
        reminders: [Reminder(minutes: 1440)],
      );
      final result = await _plugin.createOrUpdateEvent(event);
      if (result == null || result.hasErrors || result.data == null) {
        return const CalendarSyncResult(CalendarResult.failed);
      }
      return CalendarSyncResult(CalendarResult.success, eventId: result.data);
    } catch (_) {
      return const CalendarSyncResult(CalendarResult.failed);
    }
  }
}
