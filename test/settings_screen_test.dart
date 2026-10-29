import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/screens/settings_screen.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('SettingsScreen accurately displays appropriate fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));

    expect(find.text('My Settings'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('SAVE SETTINGS'), findsOneWidget);
  });

  testWidgets('Toggle switch and save settings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));

    final Finder addressField =
        find.widgetWithText(TextField, 'Enter your address');
    final Finder emailField =
        find.widgetWithText(TextField, 'Enter your email address');
    final Finder patronField =
        find.widgetWithText(TextField, 'Enter your Patron Number');

    await tester.enterText(patronField, '2615');
    await tester.enterText(addressField, '15 Alex Close, Portsmouth');
    await tester.enterText(emailField, 'tommy12@gmail.com');

    final Finder switchFinder = find.byType(Switch);
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.scrollUntilVisible(find.text('SAVE SETTINGS'), 200.0,
        scrollable: find.byType(Scrollable).first);

    await tester.tap(find.widgetWithText(ElevatedButton, 'SAVE SETTINGS'));
    await tester.pumpAndSettle();

    expect(find.text('Settings saved!'), findsOneWidget);

    final SharedPreferencesAsync prefs = SharedPreferencesAsync();

    expect(await prefs.getString(prefAddress), '15 Alex Close, Portsmouth');
    expect(
      await prefs.getString(prefEmail),
      'tommy12@gmail.com',
    );
    expect(await prefs.getString(prefPatronNo), '2615');
    expect(await prefs.getBool(prefNews), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('15 Alex Close, Portsmouth'), findsOneWidget);
    expect(
      find.text('tommy12@gmail.com'),
      findsOneWidget,
    );
    expect(find.text('2615'), findsOneWidget);
    final Switch reopenedSwitch = tester.widget<Switch>(find.byType(Switch));
    expect(reopenedSwitch.value, isTrue);
  });

  testWidgets('SettingsScreen already fills saved settings on open', (
    WidgetTester tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefAddress: 'Portsmouth Guildhall, PO1 2AJ',
      prefEmail: 'yasan.tommy@port.ac.uk',
      prefPatronNo: '5624',
      prefNews: true,
    });

    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Portsmouth Guildhall, PO1 2AJ'), findsOneWidget);
    expect(find.text('yasan.tommy@port.ac.uk'), findsOneWidget);
    expect(find.text('5624'), findsOneWidget);
    final Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
    expect(switchWidget.value, isTrue);
  });
}
