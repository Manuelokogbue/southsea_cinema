import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

const Movie testMovie = Movie(
  id: 'Wed',
  name: 'Wednesday',
  description: 'A mystery horror film',
  showingDateTime: 'Friday 30th October, 2026',
  imagePath: 'assets/images/annabelle.jpeg',
  rating: '8.90',
  duration: '1hr 55mins',
  pg: '17',
  genre: 'Horror',
  price: 6.20,
);

void main() {
  setUp(() {
    BasketRepository.instance.empty();
  });

  testWidgets(
      'Selecting a ticket quantity adds the correct quantity to the basket',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MovieBooking(testMovie),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownMenu<int>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('3').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to order'));
    await tester.pump();

    final basket = BasketRepository.instance;

    expect(basket.getMovies().length, 1);
    expect(basket.getMovies().first.movie.name, 'Wednesday');
    expect(basket.getMovies().first.quantity, 3);
  });

  testWidgets('Dropdown allows selecting the minimum quantity of 1',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MovieBooking(testMovie),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownMenu<int>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();

    expect(find.text('1').first, findsOneWidget);
  });

  testWidgets('Dropdown allows selecting the maximum quantity of 5',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MovieBooking(testMovie),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownMenu<int>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('5').last);
    await tester.pumpAndSettle();

    expect(find.text('5').first, findsOneWidget);
  });
}
