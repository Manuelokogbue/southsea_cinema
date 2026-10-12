import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';

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
}
