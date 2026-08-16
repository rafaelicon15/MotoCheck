enum CalendarResult {
  success,
  permissionDenied,
  noWritableCalendar,
  unsupported,
  failed,
}

class CalendarSyncResult {
  final CalendarResult status;
  final String? eventId;

  const CalendarSyncResult(this.status, {this.eventId});
}
