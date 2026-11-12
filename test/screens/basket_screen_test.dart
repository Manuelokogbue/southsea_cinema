import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/views/basket_screen.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/bookings_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/database/cinema_db.dart';

const Movie testMovie = Movie(
    id: 'Wed',
    name: 'Wednesday',
    description:
        'Discover the mysteries of the unknown land with Wednesday Addams',
    showingDateTime: 'Friday 30th OCt, 2026 16:45PM',
    imagePath: 'assets/images/Annabelle',
    rating: '8.90',
    duration: '1hr 55mins',
    pg: '17',
    genre: 'Horror',
    price: 6.2);

void main() {
  setUp(() async {
    BasketRepository.instance.empty();

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

  testWidgets(
      'BasketScreen displays empty message when the basket has no movies',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    expect(find.text('No tickets in cart'), findsOneWidget);
  });

  testWidgets('Test to remove movies when delete icon tapped',
      (WidgetTester tester) async {
    const BasketItem movie = BasketItem(movie: testMovie, quantity: 2);

    BasketRepository.instance.addMovie(movie);

    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    expect(find.text('MY ORDER'), findsOneWidget);
    expect(find.text('2 Tickets'), findsOneWidget);
    expect(find.text('£12.40'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('No tickets in cart'), findsOneWidget);
  });

  testWidgets(
      'Buy tickets saves the booking and clears the basket and opens bookings screen',
      (
    WidgetTester tester,
  ) async {
    BasketRepository.instance.addMovie(
      const BasketItem(movie: testMovie, quantity: 2),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: const BasketScreen(),
        routes: {
          '/bookings': (BuildContext context) {
            return const BookingsScreen();
          },
        },
      ),
    );

    await tester.runAsync(() async {
      await tester.tap(find.text('BUY TICKETS'));
      await tester.pumpAndSettle();
    });
    await tester.pumpAndSettle();

    final List<BookingRecord>? bookings = await tester.runAsync(() async {
      return await CinemaDatabase.instance.getAllOrders();
    });

    expect(bookings, isNotNull);
    if (bookings != null) {
      expect(bookings.length, 1);
      expect(bookings[0].bookingNumber, 1011);
      expect(bookings[0].summary, '2x Wednesday');
      expect(bookings[0].total, 16.40);
    }
    expect(BasketRepository.instance.getMovies(), isEmpty);
    expect(find.byType(BookingsScreen), findsOneWidget);
    expect(find.text('Booking #1011'), findsOneWidget);
  });

  testWidgets('Test to add 3 movies and delete the middle one',
    (WidgetTester tester) async {
  final basket = BasketRepository.instance;

  basket.addMovie(const BasketItem(movie: testMovie, quantity: 1));
  basket.addMovie(const BasketItem(movie: Movie(
    id: 'Anna',
    name: 'ANNABELLE',
    description: 'Horror movie',
    showingDateTime: 'Friday 30th Oct, 2026',
    imagePath: 'assets/images/annabelle.jpeg',
    rating: '7.67',
    duration: '2hrs 45mins',
    pg: '18',
    genre: 'Horror',
    price: 9.5,
  ), quantity: 1));

  basket.addMovie(const BasketItem(movie: Movie(
    id: 'Hamil',
    name: 'HAMILTON',
    description: 'Musical',
    showingDateTime: 'Sunday 25th October, 2026',
    imagePath: 'assets/images/hamilton.jpeg',
    rating: '8.30',
    duration: '2hrs 40mins',
    pg: '18',
    genre: 'Musical',
    price: 15.4,
  ), quantity: 1));

  await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

  expect(find.byIcon(Icons.delete_outline), findsNWidgets(3));

  await tester.tap(find.byIcon(Icons.delete_outline).at(1));
  await tester.pumpAndSettle();

  expect(basket.getMovies().length, 2);
  expect(basket.getMovies()[0].movie.name, 'Wednesday');
  expect(basket.getMovies()[1].movie.name, 'HAMILTON');
});

}
