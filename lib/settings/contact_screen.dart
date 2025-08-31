import 'package:flutter/material.dart';
import 'package:weatherapp_demo/localization/app_localizations.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context).contact,
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.contact_support,
                    size: 60,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).contactUs,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).weAreReadyToHelp,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Contact Information
            Text(
              AppLocalizations.of(context).contactInformation,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Email
            _buildContactItem(
              context: context,
              icon: Icons.email,
              title: 'Email',
              subtitle: 'support@pogody.com',
              isDark: isDark,
              onTap: () {
                // Có thể thêm chức năng mở email app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Email: support@pogody.com'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Phone
            _buildContactItem(
              context: context,
              icon: Icons.phone,
              title: AppLocalizations.of(context).phone,
              subtitle: '+84 123 456 789',
              isDark: isDark,
              onTap: () {
                // Có thể thêm chức năng gọi điện
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context).phoneCopied),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Website
            _buildContactItem(
              context: context,
              icon: Icons.language,
              title: AppLocalizations.of(context).website,
              subtitle: 'www.pogody.com',
              isDark: isDark,
              onTap: () {
                // Có thể thêm chức năng mở website sẽ sửa sau bằng url_launcher
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context).websiteCopied),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Address
            _buildContactItem(
              context: context,
              icon: Icons.location_on,
              title: AppLocalizations.of(context).address,
              subtitle: AppLocalizations.of(context).addressValue,
              isDark: isDark,
              onTap: () {
                // Có thể thêm chức năng mở map
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context).addressCopied),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Support Hours
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: isDark ? Colors.white70 : Colors.black54,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context).workingHours,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context).workingHoursValue,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDark ? Colors.white70 : Colors.black54,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 2),
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
