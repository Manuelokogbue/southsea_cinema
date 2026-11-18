import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/basket_screen.dart';
import 'package:southsea_cinema/views/settings_screen.dart';
import 'package:southsea_cinema/views/bookings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SouthseaCinemaApp());
}

class SouthseaCinemaApp extends StatefulWidget {
  const SouthseaCinemaApp({super.key});

  @override
  State<SouthseaCinemaApp> createState() => _SouthseaCinemaAppState();
}

class _SouthseaCinemaAppState extends State<SouthseaCinemaApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? savedTheme = await prefs.getString(prefThemeMode);
    if (!mounted || savedTheme == null) {
      return;
    }

    setState(() {
      _themeMode = savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: _buildTheme(
          brightness: Brightness.light,
          background: cinemaLightBackground,
          surface: cinemaLightSurface,
          foreground: cinemaLightFont,
          muted: cinemaLightFontMuted,
        ),
        darkTheme: _buildTheme(
          brightness: Brightness.dark,
          background: cinemaBackground,
          surface: cinemaSurface,
          foreground: cinemaFontWhite,
          muted: cinemaFontMuted,
        ),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) {
            return const HomeView();
          },
          '/basket': (BuildContext context) {
            return const BasketScreen();
          },
          '/settings': (BuildContext context) {
            return SettingsScreen(
              themeMode: _themeMode,
              onThemeModeChanged: _setThemeMode,
            );
          },
          '/bookings': (BuildContext context) {
            return const BookingsScreen();
          }
        }

        // '/listing': (BuildContext context) {
        //   return const MovieListing(); // },
        );
  }

  ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color foreground,
    required Color muted,
  }) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cinemaBrand,
        brightness: brightness,
        primary: cinemaBrand,
        surface: surface,
        onSurface: foreground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        titleTextStyle: TextStyle(
          color: foreground,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: TextStyle(color: muted),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll<Color>(cinemaBrand),
      ),
    );
  }
}
