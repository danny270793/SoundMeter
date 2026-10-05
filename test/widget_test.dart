import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundmeter/core/di/injection.dart';
import 'package:soundmeter/core/meter/app_meter_settings_controller.dart';
import 'package:soundmeter/l10n/app_localizations.dart';
import 'package:soundmeter/pages/settings_page.dart';
import 'package:soundmeter/widgets/decibel_gauge.dart';

Widget _host(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    setupDi();
  });

  testWidgets('gauge renders current level and unit', (tester) async {
    await tester.pumpWidget(
      _host(
        const Scaffold(
          body: DecibelGauge(value: 63.6, maxValue: 81, unitLabel: 'dB'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('64'), findsOneWidget);
    expect(find.text('dB'), findsOneWidget);
  });

  testWidgets('settings shows measurement, appearance and security', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const SettingsPage()));
    await tester.pumpAndSettle();
    expect(find.text('Calibration'), findsOneWidget);
    expect(find.text('Keep screen on'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Face ID & fingerprint'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Face ID & fingerprint'), findsOneWidget);
  });

  testWidgets('calibration slider updates the offset', (tester) async {
    await tester.pumpWidget(_host(const SettingsPage()));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Slider), const Offset(60, 0));
    await tester.pumpAndSettle();
    expect(getIt<AppMeterSettingsController>().calibrationDb, greaterThan(0));
  });

  testWidgets('settings is translated to Spanish', (tester) async {
    await tester.pumpWidget(
      _host(const SettingsPage(), locale: const Locale('es')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Calibración'), findsOneWidget);
  });
}
