import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weatherapp_demo/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weatherapp_demo/settings/settings_provider.dart';
import 'package:weatherapp_demo/localization/app_localizations.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Đảm bảo binding đã được khởi tạo trước khi gọi Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SettingsProvider _settingsProvider;

  @override
  void initState() {
    super.initState();
    _settingsProvider = SettingsProvider();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _settingsProvider.loadSettings();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lắng nghe thay đổi từ SettingsProvider
    _settingsProvider.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settingsProvider.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  ThemeData _getTheme() {
    if (_settingsProvider.theme == 'dark') {
      return ThemeData(
        fontFamily: 'Rubik',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Dark charcoal background
        colorScheme: const ColorScheme.dark(
          primary: Colors.lightBlueAccent,
          secondary: Colors.lightBlueAccent,
          surface: Color(0xFF2A2A2A), // Slightly lighter dark gray for cards
          background: Color(0xFF1A1A1A),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        cardColor: const Color(0xFF2A2A2A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFF2A2A2A),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          contentTextStyle: TextStyle(color: Colors.white70),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF3A3A3A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Colors.white54),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.lightBlueAccent,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF3A3A3A),
          labelStyle: const TextStyle(color: Colors.white),
          selectedColor: Colors.lightBlueAccent,
        ),
      );
    } else {
      return ThemeData(
        fontFamily: 'Rubik',
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: _getTheme(),
      locale: _settingsProvider.currentLocale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', ''),
        Locale('en', ''),
      ],
      home: const SplashScreen(),
    );
  }
}
