import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:soundmeter/pages/settings.dart';
import 'package:soundmeter/pages/soundmeter.dart';
import 'package:soundmeter/pages/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData.light(),
        dark: ThemeData.dark(),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          initialRoute: SplashPage.path,
          routes: {
            SplashPage.path: (context) => const SplashPage(),
            SoundMeterPage.path: (context) => const SoundMeterPage(),
            SettingsPage.path: (context) => const SettingsPage(),
          },
        )
    );
  }
}
