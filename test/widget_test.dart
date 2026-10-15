import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/movie_listing.dart';


void main() {
  testWidgets('Basic app loading test', (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    expect(find.text('Southsea Cinema'), findsOneWidget);
    expect(find.text('ANNABELLE'), findsOneWidget);
    expect(find.text('HAMILTON'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  group('Widget interactivity test', () {
    testWidgets('Tapping the book now button', (WidgetTester tester) async {
      await tester.pumpWidget(SouthseaCinemaApp());

      await tester.tap(find.text('BOOK NOW').first);
      await tester.pumpAndSettle();

      expect(find.byType(MovieListing), findsOneWidget);
      expect(find.text('ANNABELLE'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

    });

    testWidgets('Tapping add to order button', (WidgetTester tester) async {
      await tester.pumpWidget(SouthseaCinemaApp());

      await tester.tap(find.text('BOOK NOW').first);
      await tester.pumpAndSettle();

      expect(find.byType(MovieListing), findsOneWidget);
      expect(find.text('ANNABELLE'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.tap(find.text('Add to order').first);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);

    });
  });
}
