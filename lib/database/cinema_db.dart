import 'package:path/path.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:sqflite/sqflite.dart';

class CinemaDatabase {
  CinemaDatabase._internal();

  static final CinemaDatabase instance = CinemaDatabase._internal();

  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }

  Future<Database> get database async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      return cachedDatabase;
    }
    final Database db = await _initDB('cinema_data.db');
    _database = db;
    return db;
  }

  Future<Database> _initDB(String fileName) async {
    final String folder = await getDatabasesPath();
    final String filepath = join(folder, fileName);
    final Database db =
        await openDatabase(filepath, version: 1, onCreate: _createDB);
    return db;
  }

  Future<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_number INTEGER NOT NULL,
        summary TEXT NOT NULL,
        total REAL NOT NULL,
        date TEXT NOT NULL)
    ''');
  }

  Future<void> _createDB(Database db, int version) async {
    await createTables(db, version);

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1011,
      'summary': '2x Hamilton',
      'total': 30.8,
      'date': 'Sunday 25th October, 2026 09:00AM'
    });

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1012,
      'summary': '1x Annabelle',
      'total': 9.50,
      'date': 'Friday 30th Oct, 2026 12:00PM'
    });

    await db.insert('bookings', <String, Object?>{
      'booking_number': 1013,
      'summary': '3x A Quiet Place',
      'total': 22.95,
      'date': 'Sunday 1st Nov, 2026 13:15PM'
    });
  }

  Future<int> insertOrder(BookingRecord booking) async {
    final Database db = await database;
    final int id = await db.insert('bookings', booking.toMap());
    return id;
  }

  Future<List<BookingRecord>> getAllOrders() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.query(
      'bookings',
      orderBy: 'booking_number DESC',
    );

    final List<BookingRecord> bookings = [];
    for (final Map<String, Object?> row in records) {
      bookings.add(BookingRecord.fromMap(row));
    }
    return bookings;
  }

  Future<int> getNextBookingNumber() async {
    final Database db = await database;
    final List<Map<String, Object?>> records = await db.rawQuery(
      'SELECT MAX(booking_number) as max_num FROM bookings',
    );

    if (records.isEmpty) {
      return 1011;
    }
    final Object? maxVal = records[0]['max_num'];
    if (maxVal == null) {
      return 1011;
    }

    final int currMax = maxVal as int;
    return currMax + 1;
  }

  Future<void> close() async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      await cachedDatabase.close();
      _database = null;
    }
  }
}
