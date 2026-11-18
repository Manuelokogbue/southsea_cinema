import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';

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

const Movie testMovieWithNoImage = Movie(
  id: 'Wed',
  name: 'Wednesday',
  description: 'A mystery horror film',
  showingDateTime: 'Friday 30th October, 2026',
  imagePath: 'assets/images/rand.jpeg',
  rating: '8.90',
  duration: '1hr 55mins',
  pg: '17',
  genre: 'Horror',
  price: 6.20,
);

void main() {
  testWidgets('MovieCard displays movie information',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MovieCard(movie: testMovie),
        ),
      ),
    );

    expect(find.text('Wednesday'), findsOneWidget);
    expect(find.text('(17)'), findsOneWidget);
    expect(find.text('A mystery horror film'), findsOneWidget);
    expect(find.text('Friday 30th October, 2026'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsOneWidget);
  });

  testWidgets('MovieCard displays a message when the image is unavailable',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MovieCard(movie: testMovieWithNoImage),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Image unavailable'), findsOneWidget);
  });

  testWidgets('BOOK NOW opens the MovieBooking screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MovieCard(movie: testMovie),
        ),
      ),
    );

    await tester.tap(find.text('BOOK NOW'));
    await tester.pumpAndSettle();

    expect(find.text('Add to order'), findsOneWidget);
    expect(find.text('Wednesday'), findsOneWidget);
  });
}
