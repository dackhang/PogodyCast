import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp_demo/localization/app_localizations.dart';

class SettingsProvider extends ChangeNotifier {
  // Singleton instance
  static final SettingsProvider _instance = SettingsProvider._internal();
  factory SettingsProvider() => _instance;
  SettingsProvider._internal();
  
  // Ngôn ngữ: 'vi' cho tiếng Việt, 'en' cho tiếng Anh
  String _language = 'vi';
  
  // Theme: 'light' cho light mode, 'dark' cho dark mode
  String _theme = 'light';
  
  // Keys cho SharedPreferences
  static const String _languageKey = 'language';
  static const String _themeKey = 'theme';

  // Callback function để thông báo khi ngôn ngữ thay đổi
  VoidCallback? _onLanguageChanged;

  // Getters
  String get language => _language;
  String get theme => _theme;
  
  // Get current locale / lấy ngôn ngữ hiện tại
  Locale get currentLocale => Locale(_language);

  // Setters
  void setLanguage(String language) {
    if (_language != language) {
      _language = language;
      _saveLanguage(language);
      notifyListeners();
      // Gọi callback khi ngôn ngữ thay đổi
      _onLanguageChanged?.call();
    }
  }

  void setTheme(String theme) {
    _theme = theme;
    _saveTheme(theme);
    notifyListeners();
  }

  // Set callback function
  void setOnLanguageChangedCallback(VoidCallback callback) {
    _onLanguageChanged = callback;
  }

  // Remove callback function
  void removeOnLanguageChangedCallback() {
    _onLanguageChanged = null;
  }
  
  // Load settings từ SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString(_languageKey) ?? 'vi';
    _theme = prefs.getString(_themeKey) ?? 'light';
    notifyListeners();
  }
  
  // Save language
  Future<void> _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }
  
  // Save theme
  Future<void> _saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }

  // Helper methods
  String getLanguageDisplayName(String lang) {
    switch (lang) {
      case 'vi':
        return 'Vietnamese';
      case 'en':
        return 'English';
      default:
        return 'Vietnamese';
    }
  }

  String getThemeDisplayName(String theme) {
    switch (theme) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'Light';
    }
  }

  IconData getThemeIcon(String theme) {
    switch (theme) {
      case 'light':
        return Icons.wb_sunny;
      case 'dark':
        return Icons.nightlight_round;
      default:
        return Icons.wb_sunny;
    }
  }
}
