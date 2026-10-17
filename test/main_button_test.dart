import 'package:flutter/material.dart';
import 'package:southsea_cinema/widgets/main_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MainButton shows up in test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainButton(
            label: 'BOOK NOW',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('BOOK NOW'), findsOneWidget);
  });

  testWidgets('MainButton works when tapped', (WidgetTester tester) async {
    bool pressMe = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainButton(
            label: 'Add to order',
            onPressed: () {
              pressMe = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Add to order'));
    await tester.pump();

    expect(pressMe, isTrue);
  });
}
