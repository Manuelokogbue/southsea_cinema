import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/order_item.dart';

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

  test('stores item details linked to a booking', () async {
    final BookingRecord booking = buildRecord(1014, '2x Hamilton', 30.8);
    final OrderItem item = const OrderItem(
      movieName: 'Hamilton',
      showingDateTime: 'Sunday 25th October, 2026 09:00AM',
      quantity: 2,
      unitPrice: 15.4,
      lineTotal: 30.8,
    );

    final int bookingId = await CinemaDatabase.instance
        .insertBookingWithItems(booking, <OrderItem>[item]);
    final List<OrderItem> items =
        await CinemaDatabase.instance.getAllOrderItems();

    expect(items.length, 1);
    expect(items[0].bookingId, bookingId);
    expect(items[0].movieName, 'Hamilton');
    expect(items[0].quantity, 2);
    expect(items[0].lineTotal, 30.8);
  });

  test('upgrades version 1 while preserving bookings and enabling foreign keys',
      () async {
    const String databasePath = 'migration_test.db';
    await databaseFactoryFfiNoIsolate.deleteDatabase(databasePath);

    final Database versionOne = await databaseFactoryFfiNoIsolate.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE bookings (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              booking_number INTEGER NOT NULL,
              summary TEXT NOT NULL,
              total REAL NOT NULL,
              date TEXT NOT NULL
            )
          ''');
          await db.insert('bookings', <String, Object?>{
            'booking_number': 1015,
            'summary': '1x Legacy Film',
            'total': 10.0,
            'date': '24/05/2026 15:40',
          });
        },
      ),
    );
    await versionOne.close();

    final Database versionTwo = await databaseFactoryFfiNoIsolate.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: CinemaDatabase.instance.configureDatabase,
        onCreate: CinemaDatabase.instance.createTables,
        onUpgrade: CinemaDatabase.instance.onUpgrade,
      ),
    );

    final List<Map<String, Object?>> bookings =
        await versionTwo.query('bookings');
    final List<Map<String, Object?>> orders = await versionTwo.query('orders');
    final List<Map<String, Object?>> foreignKeys =
        await versionTwo.rawQuery('PRAGMA foreign_keys');

    expect(bookings.length, 1);
    expect(bookings[0]['summary'], '1x Legacy Film');
    expect(orders, isEmpty);
    expect(foreignKeys.single['foreign_keys'], 1);
    await expectLater(
      versionTwo.insert('orders', <String, Object?>{
        'booking_id': 9999,
        'movie_name': 'Invalid',
        'showing_date_time': 'Unknown',
        'quantity': 1,
        'unit_price': 1.0,
        'line_total': 1.0,
      }),
      throwsA(isA<DatabaseException>()),
    );

    await versionTwo.close();
    await databaseFactoryFfiNoIsolate.deleteDatabase(databasePath);
  });
}
