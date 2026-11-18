import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

void main() {
  testWidgets('NavDrawer displays all navigation options',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Southsea Cinema')),
          drawer: const NavDrawer(),
          body: const Text('Home Screen'),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Southsea Cinema'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('My Basket'), findsOneWidget);
    expect(find.text('My Settings'), findsOneWidget);
  });

  testWidgets('Close button closes the navigation drawer',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Southsea Cinema')),
          drawer: const NavDrawer(),
          body: const Text('Home Screen'),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsOneWidget);
    expect(find.text('My Basket'), findsNothing);
  });
}
