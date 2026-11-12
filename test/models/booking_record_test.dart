import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/booking.dart';

void main() {
  const BookingRecord booking = BookingRecord(
    bookingNumber: 1013,
    summary: '2x A Quiet Place',
    total: 15.30,
    date: '13/12/2026 09:05',
  );

  test('New bookings have no ids and convert to map', () {
    expect(booking.id, isNull);
    expect(booking.toMap(), <String, Object?>{
      'booking_number': 1013,
      'summary': '2x A Quiet Place',
      'total': 15.30,
      'date': '13/12/2026 09:05',
    });
  });

  test('Database map reverts to a booking record', () {
    final Map<String, Object?> row = <String, Object?>{
      'id': 3,
      'booking_number': 1014,
      'summary': '1x Hamilton',
      'total': 9.5,
      'date': '22/11/2026 11:40',
    };
    final BookingRecord restored = BookingRecord.fromMap(row);
    expect(restored.id, 3);
    expect(restored.bookingNumber, 1014);
    expect(restored.summary, '1x Hamilton');
    expect(restored.total, 9.5);
    expect(restored.date, '22/11/2026 11:40');
    expect(restored.toMap(), row);
  });

  test('Whole number turns to doubles', () {
    final Map<String, Object?> row = booking.toMap();
    row['total'] = 5;
    final BookingRecord restored = BookingRecord.fromMap(row);
    expect(restored.total, 5.0);
    expect(restored.total, isA<double>());
  });
}
