import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  group('Test that shared preferences work for user data', () {
    testWidgets('SettingsScreen pre-fills saved settings on open', (
      WidgetTester tester,
    ) async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData(<String, Object>{
        //   prefName: 'Abdul Kadir',
        //   prefAddress: 'Portsmouth Guildhall, PO1 2AJ',
        //   prefEmail: 'abdul.kadir@portsmouthcc.gov.uk',
        //   prefNewsletter: true,
      });
    });
  });
}
