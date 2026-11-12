import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';

void main() {
  setUp(() async {
    sqfliteFfiInit();
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: CinemaDatabase.instance.createTables,
      ),
    );
    CinemaDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await CinemaDatabase.instance.close();
  });

  BookingRecord buildRecord(int bookingNumber, String summary, double total) {
    return BookingRecord(
      bookingNumber: bookingNumber,
      summary: summary,
      total: total,
      date: '24/05/2026 15:40',
    );
  }

  test('Storing an order and returning its id', () async {
    final int id = await CinemaDatabase.instance.insertOrder(
      buildRecord(1010, '1x Annabelle', 9.50),
    );
    expect(id, greaterThan(0));

    final List<BookingRecord> orders =
        await CinemaDatabase.instance.getAllOrders();
    expect(orders.length, 1);
    expect(orders[0].id, id);
    expect(orders[0].summary, '1x Annabelle');
    expect(orders[0].total, 9.50);
  });

  test('getNextOrderNumber increases', () async {
    expect(await CinemaDatabase.instance.getNextBookingNumber(), 1011);

    await CinemaDatabase.instance.insertOrder(
      buildRecord(1013, 'Booking', 9.0),
    );
    expect(await CinemaDatabase.instance.getNextBookingNumber(), 1014);
  });

  test('getAllOrders sorts orders with last number first', () async {
    await CinemaDatabase.instance.insertOrder(
      buildRecord(1011, 'First', 9.5),
    );
    await CinemaDatabase.instance.insertOrder(
      buildRecord(1012, 'Third', 13.3),
    );
    await CinemaDatabase.instance.insertOrder(
      buildRecord(1013, 'Second', 7.5),
    );

    final List<BookingRecord> orders =
        await CinemaDatabase.instance.getAllOrders();
    expect(orders[0].bookingNumber, 1013);
    expect(orders[1].bookingNumber, 1012);
    expect(orders[2].bookingNumber, 1011);
  });
}
