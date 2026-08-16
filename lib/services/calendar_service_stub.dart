import 'calendar_result.dart';

class CalendarService {
  static Future<CalendarSyncResult> addMaintenanceEvent({
    required String title,
    required DateTime start,
    required String description,
    String? location,
    String? eventId,
  }) async {
    return const CalendarSyncResult(CalendarResult.unsupported);
  }
}
