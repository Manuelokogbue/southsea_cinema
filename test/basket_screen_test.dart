import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/screens/basket_screen.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';

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
    setUp(() {
      BasketRepository.instance.empty();
    });

    testWidgets('BasketScreen displays empty message when the basket has no movies', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: BasketScreen()
      ));

      expect(find.text('No movies in cart'), findsOneWidget);
    });

    testWidgets('Test to remove movies when delete icon tapped', (WidgetTester tester) async {
      const BasketItem movie = BasketItem(movie: testMovie, quantity: 2);

      BasketRepository.instance.addMovie(movie);

      await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

      expect(find.text('MY ORDER'), findsOneWidget);
      expect(find.text('2 Tickets'), findsOneWidget);
      expect(find.text('£12.40'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump(); 

      expect(find.text('No movies in cart'), findsOneWidget);
    });
  }