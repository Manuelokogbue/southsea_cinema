import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/views/settings_screen.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    rootBundle.clear();
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });
  testWidgets('Basic app loading test', (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    expect(find.text('Southsea Cinema'), findsOneWidget);
    expect(find.text('ANNABELLE'), findsOneWidget);
    expect(find.text('HAMILTON'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('App restores the saved light theme', (
    WidgetTester tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefThemeMode: 'light',
    });

    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
  });

  group('Widget interactivity test', () {
    testWidgets('Tapping the book now button', (WidgetTester tester) async {
      await tester.pumpWidget(SouthseaCinemaApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BOOK NOW').first);
      await tester.pumpAndSettle();

      expect(find.byType(MovieListing), findsOneWidget);
      expect(
          find.text('*Discounts will be applied at checkout.'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Tapping add to order button', (WidgetTester tester) async {
      await tester.pumpWidget(SouthseaCinemaApp());
      await tester.pumpAndSettle();

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
