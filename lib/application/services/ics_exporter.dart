import 'dart:convert';

import '../../data/models/booking_model.dart';

class IcsExporter {
  const IcsExporter();

  String exportFromBookings(List<BookingModel> bookings) {
    final buffer = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('VERSION:2.0')
      ..writeln('PRODID:-//Gym Passport//EN');
    for (final booking in bookings) {
      buffer
        ..writeln('BEGIN:VEVENT')
        ..writeln('UID:${booking.id}')
        ..writeln('SUMMARY:${_escape(booking.title ?? 'Class')}')
        ..writeln('DTSTAMP:${_formatDate(DateTime.now())}');
      if (booking.startTime != null) {
        buffer.writeln('DTSTART:${_formatDate(booking.startTime!)}');
      }
      if (booking.endTime != null) {
        buffer.writeln('DTEND:${_formatDate(booking.endTime!)}');
      }
      buffer
        ..writeln('STATUS:CONFIRMED')
        ..writeln('END:VEVENT');
    }
    buffer.writeln('END:VCALENDAR');
    return buffer.toString();
  }

  String _formatDate(DateTime value) {
    return value.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first + 'Z';
  }

  String _escape(String value) {
    return const HtmlEscape(HtmlEscapeMode.attribute).convert(value);
  }
}
