import 'package:flutter/material.dart';
import 'package:weatherapp_demo/settings/settings_provider.dart';
import 'package:weatherapp_demo/localization/app_localizations.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context).selectDisplayMode,
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).selectDisplayModeForApp,
              style: TextStyle(
                fontSize: 18,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            
            // Light Mode
            _buildThemeOption('light', AppLocalizations.of(context).light, AppLocalizations.of(context).lightMode, Icons.wb_sunny, AppLocalizations.of(context).lightModeDesc),
            
            const SizedBox(height: 16),
            
            // Dark Mode
            _buildThemeOption('dark', AppLocalizations.of(context).dark, AppLocalizations.of(context).darkMode, Icons.nightlight_round, AppLocalizations.of(context).darkModeDesc),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String themeCode, String displayName, String subtitle, IconData icon, String description) {
    final isSelected = _settingsProvider.theme == themeCode;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _settingsProvider.setTheme(themeCode);
        });
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).modeSelected}$displayName'),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
            ? (isDark ? Colors.blue[900] : Colors.blue[50]) 
            : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
                          Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected 
                    ? (isDark ? Colors.blue[800] : Colors.blue[100]) 
                    : (isDark ? const Color(0xFF3A3A3A) : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                    ? (isDark ? Colors.blue[200] : Colors.blue[700]) 
                    : (isDark ? Colors.white70 : Colors.black54),
                  size: 24,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected 
                        ? (isDark ? Colors.blue[200] : Colors.blue[700]) 
                        : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected 
                        ? (isDark ? Colors.blue[300] : Colors.blue[600]) 
                        : (isDark ? Colors.white70 : Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected 
                        ? (isDark ? Colors.blue[400] : Colors.blue[500]) 
                        : (isDark ? Colors.white54 : Colors.black45),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: isDark ? Colors.blue[200] : Colors.blue[700],
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
