import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/views/bookings_screen.dart';

void main() {
  setUp(() async {
    sqfliteFfiInit();

    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: CinemaDatabase.instance.configureDatabase,
        onCreate: CinemaDatabase.instance.createTables,
      ),
    );

    CinemaDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await CinemaDatabase.instance.close();
  });

  testWidgets(
      'BookingsScreen displays empty message when there are no bookings',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: BookingsScreen()),
    );

    await tester.pumpAndSettle();

    expect(find.text('No bookings here.'), findsOneWidget);
  });

  testWidgets('BookingsScreen displays multiple booking cards',
      (WidgetTester tester) async {
    await CinemaDatabase.instance.insertOrder(
      const BookingRecord(
        bookingNumber: 1010,
        summary: '2x Annabelle',
        total: 19.00,
        date: '24/05/2026 15:40',
      ),
    );

    await CinemaDatabase.instance.insertOrder(
      const BookingRecord(
        bookingNumber: 1011,
        summary: '1x Hamilton',
        total: 15.50,
        date: '25/05/2026 16:30',
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(home: BookingsScreen()),
    );

    await tester.pumpAndSettle();

    expect(find.text('Booking #1010'), findsOneWidget);
    expect(find.text('Booking #1011'), findsOneWidget);

    expect(find.text('2x Annabelle'), findsOneWidget);
    expect(find.text('1x Hamilton'), findsOneWidget);

    expect(find.text('£19.00'), findsOneWidget);
    expect(find.text('£15.50'), findsOneWidget);

    expect(find.text('24/05/2026 15:40'), findsOneWidget);
    expect(find.text('25/05/2026 16:30'), findsOneWidget);
  });

  testWidgets('BookingsScreen displays an error when the database is closed',
      (WidgetTester tester) async {
    await CinemaDatabase.instance.close();

    await tester.pumpWidget(
      const MaterialApp(home: BookingsScreen()),
    );

    await tester.pumpAndSettle();

    expect(
      find.textContaining('Could not load bookings:'),
      findsOneWidget,
    );
  });
}
