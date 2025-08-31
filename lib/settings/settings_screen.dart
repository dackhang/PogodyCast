import 'package:flutter/material.dart';
import 'package:weatherapp_demo/settings/settings_provider.dart';
import 'package:weatherapp_demo/settings/language_selection_screen.dart';
import 'package:weatherapp_demo/settings/theme_selection_screen.dart';
import 'package:weatherapp_demo/settings/help_support_screen.dart';
import 'package:weatherapp_demo/localization/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          AppLocalizations.of(context).settings,
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
            // Ngôn ngữ
            _buildClickableSettingSection(
              title: AppLocalizations.of(context).language,
              icon: Icons.language,
              subtitle: _settingsProvider.getLanguageDisplayName(_settingsProvider.language),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LanguageSelectionScreen(),
                  ),
                );
              },
              isDark: isDark,
            ),
            
            const SizedBox(height: 24),
            
            // Chế độ hiển thị
            _buildClickableSettingSection(
              title: AppLocalizations.of(context).displayMode,
              icon: Icons.palette,
              subtitle: _settingsProvider.getThemeDisplayName(_settingsProvider.theme),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ThemeSelectionScreen(),
                  ),
                );
              },
              isDark: isDark,
            ),
            
            const SizedBox(height: 24),
            
            // Help & Support
            _buildClickableSettingSection(
              title: AppLocalizations.of(context).helpSupport,
              icon: Icons.help_outline,
              subtitle: AppLocalizations.of(context).contactUsSection + ' & ' + AppLocalizations.of(context).privacyPolicySection,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HelpSupportScreen(),
                  ),
                );
              },
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method để tạo section cài đặt có thể click
  Widget _buildClickableSettingSection({
    required String title,
    required IconData icon,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
              child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
                  child: Row(
            children: [
              Icon(icon, color: isDark ? Colors.white70 : Colors.black54, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isDark ? Colors.white70 : Colors.black54,
                size: 16,
              ),
            ],
          ),
      ),
    );
  }
}
