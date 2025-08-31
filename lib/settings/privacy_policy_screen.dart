import 'package:flutter/material.dart';
import 'package:weatherapp_demo/localization/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          AppLocalizations.of(context).privacyPolicy,
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
                    Icons.privacy_tip,
                    size: 60,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).privacyPolicyTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).lastUpdated,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Privacy Policy Content
            _buildPolicySection(
              context: context,
              title: AppLocalizations.of(context).infoCollectionTitle,
              content: AppLocalizations.of(context).infoCollectionContent,
              isDark: isDark,
            ),
            
            const SizedBox(height: 16),
            
            _buildPolicySection(
              context: context,
              title: AppLocalizations.of(context).infoUsageTitle,
              content: AppLocalizations.of(context).infoUsageContent,
              isDark: isDark,
            ),
            
            const SizedBox(height: 16),
            
            _buildPolicySection(
              context: context,
              title: AppLocalizations.of(context).infoSharingTitle,
              content: AppLocalizations.of(context).infoSharingContent,
              isDark: isDark,
            ),
            
            const SizedBox(height: 16),
            
            _buildPolicySection(
              context: context,
              title: AppLocalizations.of(context).securityTitle,
              content: AppLocalizations.of(context).securityContent,
              isDark: isDark,
            ),
            
            const SizedBox(height: 16),
            
            _buildPolicySection(
              context: context,
              title: AppLocalizations.of(context).userRightsTitle,
              content: AppLocalizations.of(context).userRightsContent,
              isDark: isDark,
            ),
            
            const SizedBox(height: 16),
            
            _buildPolicySection(
              context: context,
              title: AppLocalizations.of(context).cookieTitle,
              content: AppLocalizations.of(context).privacyPolicyContent2,
              isDark: isDark,
            ),
            
            const SizedBox(height: 16),
            
            _buildPolicySection(
              context: context,
              title: AppLocalizations.of(context).policyChangesTitle,
              content: AppLocalizations.of(context).privacyPolicyContent3,
              isDark: isDark,
            ),
            
            const SizedBox(height: 16),
            
            _buildPolicySection(
              context: context,
              title: AppLocalizations.of(context).contactInfoTitle,
              content: AppLocalizations.of(context).privacyPolicyContent4,
              isDark: isDark,
            ),
            
            const SizedBox(height: 32),
            
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.security,
                    size: 40,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context).securityPriority,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).privacyPolicyContent1,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection({
    required BuildContext context,
    required String title,
    required String content,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
