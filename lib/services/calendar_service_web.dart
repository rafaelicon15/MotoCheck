import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'calendar_result.dart';

String _escapeIcs(String value) {
  return value
      .replaceAll('\\', '\\\\')
      .replaceAll(';', '\\;')
      .replaceAll(',', '\\,')
      .replaceAll('\n', '\\n');
}

String _formatUtc(DateTime value) {
  final utc = value.toUtc();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${utc.year}${two(utc.month)}${two(utc.day)}T${two(utc.hour)}${two(utc.minute)}${two(utc.second)}Z';
}

class CalendarService {
  static Future<CalendarSyncResult> addMaintenanceEvent({
    required String title,
    required DateTime start,
    required String description,
    String? location,
    String? eventId,
  }) async {
    final effectiveId =
        eventId ?? 'motocheck-${DateTime.now().millisecondsSinceEpoch}';
    final end = start.add(const Duration(minutes: 45));
    final ics = [
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//MotoCheck//Maintenance//ES',
      'CALSCALE:GREGORIAN',
      'BEGIN:VEVENT',
      'UID:${_escapeIcs(effectiveId)}',
      'DTSTAMP:${_formatUtc(DateTime.now())}',
      'DTSTART:${_formatUtc(start)}',
      'DTEND:${_formatUtc(end)}',
      'SUMMARY:${_escapeIcs(title)}',
      'DESCRIPTION:${_escapeIcs(description)}',
      if (location != null && location.isNotEmpty)
        'LOCATION:${_escapeIcs(location)}',
      'BEGIN:VALARM',
      'TRIGGER:-P1D',
      'ACTION:DISPLAY',
      'DESCRIPTION:${_escapeIcs(title)}',
      'END:VALARM',
      'END:VEVENT',
      'END:VCALENDAR',
    ].join('\r\n');

    final file = web.File(
      [ics.toJS].toJS,
      'motocheck-mantenimiento.ics',
      web.FilePropertyBag(type: 'text/calendar'),
    );
    final url = web.URL.createObjectURL(file);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = 'motocheck-mantenimiento.ics';
    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    web.URL.revokeObjectURL(url);
    return CalendarSyncResult(CalendarResult.success, eventId: effectiveId);
  }
}
