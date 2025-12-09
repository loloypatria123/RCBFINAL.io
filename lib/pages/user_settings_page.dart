import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import '../providers/ui_provider.dart';
import '../services/supabase_storage_service.dart';

// Color constants for settings page
class _SettingsColors {
  static const Color bgColor = Color(0xFF0A0E27); // Scaffold background
  static const Color cardBg = Color(0xFF111827); // Card background
  static const Color primaryMedium = Color(0xFF1A1F3A);
  static const Color accent = Color(0xFF4F46E5); // Indigo accent
  static const Color accentSecondary = Color(0xFF06B6D4); // Cyan accent
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFFD1D5DB);
}

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  String _localizedText(BuildContext context, String key) {
    final ui = Provider.of<UIProvider>(context, listen: false);
    final lang = ui.selectedLanguage.toLowerCase();

    // Fallback to English
    String t(Map<String, String> values) =>
        lang.contains('filipino') || lang.contains('tagalog')
        ? values['fil'] ?? values['en']!
        : lang.contains('cebuano') || lang.contains('bisaya')
        ? values['ceb'] ?? values['en']!
        : values['en']!;

    switch (key) {
      case 'settings_title':
        return t({
          'en': 'Settings',
          'fil': 'Mga Setting',
          'ceb': 'Mga Setting',
        });
      case 'account_settings_title':
        return t({
          'en': 'Account & Settings',
          'fil': 'Account at Mga Setting',
          'ceb': 'Account ug Mga Setting',
        });
      case 'account_settings_subtitle':
        return t({
          'en': 'Manage your profile, preferences, and app settings',
          'fil': 'I-manage ang iyong profile, preference, at app settings',
          'ceb': 'I-manage ang imong profile, paborito, ug app settings',
        });
      case 'user_profile_section_title':
        return t({
          'en': 'User Profile',
          'fil': 'Profile ng User',
          'ceb': 'Profile sa Gumagamit',
        });
      case 'view_profile_title':
        return t({
          'en': 'View profile information',
          'fil': 'Tingnan ang impormasyon ng profile',
          'ceb': 'Tan-awa ang impormasyon sa profile',
        });
      case 'app_settings_section_title':
        return t({
          'en': 'App Settings',
          'fil': 'Mga App Setting',
          'ceb': 'Mga App Setting',
        });
      case 'theme_title':
        return t({
          'en': 'Theme (light/dark)',
          'fil': 'Tema (liwanag/dilim)',
          'ceb': 'Tema (hayag/ngitngit)',
        });
      case 'theme_subtitle':
        return t({
          'en': 'Switch between light and dark mode',
          'fil': 'Lumipat sa liwanag o madilim na mode',
          'ceb': 'Ibalhin sa hayag o ngitngit nga mode',
        });
      case 'language_title':
        return t({'en': 'Language', 'fil': 'Wika', 'ceb': 'Pinulongan'});
      case 'language_set_message':
        return t({
          'en': 'Language set to {lang}',
          'fil': 'Naitakda ang wika sa {lang}',
          'ceb': 'Na-set ang pinulongan sa {lang}',
        });
      case 'support_section_title':
        return t({
          'en': 'Support Help Center',
          'fil': 'Support / Help Center',
          'ceb': 'Support / Help Center',
        });
      case 'faqs_title':
        return t({'en': 'FAQs', 'fil': 'FAQs', 'ceb': 'FAQs'});
      case 'faqs_subtitle':
        return t({
          'en': 'Frequently asked questions',
          'fil': 'Mga madalas itanong',
          'ceb': 'Kanunay pangutab-on nga mga pangutana',
        });
      case 'troubleshooting_title':
        return t({
          'en': 'Troubleshooting guide',
          'fil': 'Troubleshooting guide',
          'ceb': 'Troubleshooting guide',
        });
      case 'troubleshooting_subtitle':
        return t({
          'en': 'Solve common problems with the app or robots',
          'fil': 'Ayusin ang karaniwang problema sa app o mga robot',
          'ceb': 'Solbara ang kasagarang problema sa app o sa mga robot',
        });
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _SettingsColors.bgColor,
      appBar: AppBar(
        backgroundColor: _SettingsColors.cardBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _localizedText(context, 'settings_title'),
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _SettingsColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _SettingsColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ChangeNotifierProvider.value(
        value: Provider.of<AuthProvider>(context, listen: false),
        child: _SettingsContent(
          pulseAnimation: _pulseAnimation,
          rotationAnimation: _rotationAnimation,
          localizedText: _localizedText,
        ),
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final Animation<double> rotationAnimation;
  final String Function(BuildContext, String) localizedText;

  const _SettingsContent({
    required this.pulseAnimation,
    required this.rotationAnimation,
    required this.localizedText,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final uiProvider = context.watch<UIProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _SettingsSectionHeader(
            title: localizedText(context, 'account_settings_title'),
            subtitle: localizedText(context, 'account_settings_subtitle'),
          ),
          const SizedBox(height: 20),
          
          // Animated Profile Header Card
          _ProfileHeaderCard(
            authProvider: authProvider,
            pulseAnimation: pulseAnimation,
            rotationAnimation: rotationAnimation,
          ),
          const SizedBox(height: 24),
          
          // User Profile section
          _AnimatedSectionTitle(
            localizedText(context, 'user_profile_section_title'),
            Icons.person,
            _SettingsColors.accent,
            pulseAnimation,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showUpdateUsernameDialog(context, authProvider),
            child: _AnimatedSettingsTile(
              title: 'Update username',
              subtitle: 'Change your display name',
              icon: Icons.edit,
              color: _SettingsColors.accentSecondary,
              pulseAnimation: pulseAnimation,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showUpdateEmailDialog(context, authProvider),
            child: _AnimatedSettingsTile(
              title: 'Update email',
              subtitle: 'Change your email address',
              icon: Icons.email,
              color: _SettingsColors.accent,
              pulseAnimation: pulseAnimation,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showUpdatePasswordDialog(context, authProvider),
            child: _AnimatedSettingsTile(
              title: 'Update password',
              subtitle: 'Change your account password',
              icon: Icons.lock,
              color: _SettingsColors.warningColor,
              pulseAnimation: pulseAnimation,
            ),
          ),
          const SizedBox(height: 28),
          
          // App Settings section
          _AnimatedSectionTitle(
            localizedText(context, 'app_settings_section_title'),
            Icons.settings,
            _SettingsColors.accentSecondary,
            pulseAnimation,
          ),
          const SizedBox(height: 12),
          
          _AnimatedSettingsSwitchTile(
            title: localizedText(context, 'theme_title'),
            subtitle: localizedText(context, 'theme_subtitle'),
            icon: Icons.brightness_6,
            value: uiProvider.isDarkMode,
            pulseAnimation: pulseAnimation,
            onChanged: (value) {
              uiProvider.setDarkMode(value);
            },
          ),
          const SizedBox(height: 12),
          
          GestureDetector(
            onTap: () async {
              final selected = await _showLanguageDialog(
                context,
                initial: uiProvider.selectedLanguage,
              );
              if (selected != null && selected.isNotEmpty) {
                uiProvider.setSelectedLanguage(selected);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localizedText(context, 'language_set_message')
                            .replaceFirst('{lang}', selected),
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: _SettingsColors.successColor,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            child: _AnimatedSettingsTile(
              title: localizedText(context, 'language_title'),
              subtitle: uiProvider.selectedLanguage,
              icon: Icons.language,
              color: _SettingsColors.accent,
              pulseAnimation: pulseAnimation,
            ),
          ),
          const SizedBox(height: 12),
          
          GestureDetector(
            onTap: () {
              _showVersionDialog(context);
            },
            child: _AnimatedSettingsTile(
              title: 'App version info',
              subtitle: 'RCB v1.0.0',
              icon: Icons.info,
              color: _SettingsColors.accentSecondary,
              pulseAnimation: pulseAnimation,
            ),
          ),
          const SizedBox(height: 28),
          
          // Support / Help Center
          _AnimatedSectionTitle(
            localizedText(context, 'support_section_title'),
            Icons.support_agent,
            _SettingsColors.successColor,
            pulseAnimation,
          ),
          const SizedBox(height: 12),
          
          _AnimatedSettingsTile(
            title: localizedText(context, 'faqs_title'),
            subtitle: localizedText(context, 'faqs_subtitle'),
            icon: Icons.help_center,
            color: _SettingsColors.successColor,
            pulseAnimation: pulseAnimation,
          ),
          const SizedBox(height: 12),
          _AnimatedSettingsTile(
            title: localizedText(context, 'troubleshooting_title'),
            subtitle: localizedText(context, 'troubleshooting_subtitle'),
            icon: Icons.build_circle,
            color: _SettingsColors.warningColor,
            pulseAnimation: pulseAnimation,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SettingsSectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    _SettingsColors.accent,
                    _SettingsColors.accentSecondary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _SettingsColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: _SettingsColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _AnimatedSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Animation<double> pulseAnimation;

  const _AnimatedSectionTitle(
    this.title,
    this.icon,
    this.color,
    this.pulseAnimation,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Transform.scale(
                scale: pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _SettingsColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedSettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Animation<double> pulseAnimation;

  const _AnimatedSettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _SettingsColors.cardBg,
            color.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: pulseAnimation.value,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _SettingsColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: _SettingsColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: color,
            size: 24,
          ),
        ],
      ),
    );
  }
}

class _AnimatedSettingsSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final Animation<double> pulseAnimation;
  final ValueChanged<bool> onChanged;

  const _AnimatedSettingsSwitchTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.pulseAnimation,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final color = value
        ? _SettingsColors.successColor
        : _SettingsColors.textSecondary;

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _SettingsColors.cardBg,
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Transform.scale(
                scale: value ? pulseAnimation.value : 1.0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: value
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _SettingsColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: _SettingsColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: _SettingsColors.successColor,
                activeTrackColor: _SettingsColors.successColor.withOpacity(0.5),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final AuthProvider authProvider;
  final Animation<double> pulseAnimation;
  final Animation<double> rotationAnimation;

  const _ProfileHeaderCard({
    required this.authProvider,
    required this.pulseAnimation,
    required this.rotationAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final name = authProvider.userModel?.name ?? 'User';
    final email = authProvider.userModel?.email ?? 'N/A';

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _SettingsColors.cardBg,
                _SettingsColors.accent.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _SettingsColors.accent.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _SettingsColors.accent.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Animated Avatar - Clickable for upload and view profile
              GestureDetector(
                onTap: () => _handleProfilePictureTap(context, authProvider),
                child: AnimatedBuilder(
                  animation: rotationAnimation,
                  builder: (context, child) {
                    final photoUrl = authProvider.userModel?.photoUrl;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Rotating ring
                        Transform.rotate(
                          angle: rotationAnimation.value * 6.28319,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _SettingsColors.accentSecondary.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: List.generate(8, (index) {
                                return Transform.rotate(
                                  angle: (index * 0.785398),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: _SettingsColors.accentSecondary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        // Avatar with image or initial
                        Transform.scale(
                          scale: pulseAnimation.value,
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: photoUrl == null || photoUrl.isEmpty
                                  ? LinearGradient(
                                      colors: [
                                        _SettingsColors.accent,
                                        _SettingsColors.accentSecondary,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: photoUrl != null && photoUrl.isNotEmpty
                                  ? Colors.transparent
                                  : null,
                              image: photoUrl != null && photoUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(photoUrl),
                                      fit: BoxFit.cover,
                                      onError: (exception, stackTrace) {
                                        // If image fails to load, show initial
                                      },
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: _SettingsColors.accent.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: photoUrl == null || photoUrl.isEmpty
                                ? Center(
                                    child: Text(
                                      name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                      style: GoogleFonts.poppins(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        // Camera icon overlay
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _SettingsColors.accentSecondary,
                              border: Border.all(
                                color: _SettingsColors.cardBg,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          _SettingsColors.textPrimary,
                          _SettingsColors.accentSecondary,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 14,
                          color: _SettingsColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            email,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: _SettingsColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _SettingsColors.successColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _SettingsColors.successColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.scale(
                            scale: pulseAnimation.value,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: _SettingsColors.successColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Active User',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: _SettingsColors.successColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


Future<String?> _showLanguageDialog(
  BuildContext context, {
  required String initial,
}) async {
  const languages = [
    {'name': 'English', 'icon': '🇺🇸'},
    {'name': 'Filipino', 'icon': '🇵🇭'},
    {'name': 'Cebuano', 'icon': '🇵🇭'},
  ];

  return showDialog<String>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: _SettingsColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: _SettingsColors.accent.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _SettingsColors.accent,
                    _SettingsColors.accentSecondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.language,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Select Language',
              style: GoogleFonts.poppins(
                color: _SettingsColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            final isSelected = lang['name'] == initial;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => Navigator.of(ctx).pop(lang['name']),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              _SettingsColors.accent.withOpacity(0.2),
                              _SettingsColors.accentSecondary.withOpacity(0.1),
                            ],
                          )
                        : null,
                    color: isSelected ? null : _SettingsColors.primaryMedium,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? _SettingsColors.accent
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        lang['icon']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          lang['name']!,
                          style: GoogleFonts.poppins(
                            color: _SettingsColors.textPrimary,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _SettingsColors.successColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    },
  );
}

void _showVersionDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: _SettingsColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: _SettingsColors.accentSecondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _SettingsColors.accentSecondary,
                    _SettingsColors.accent,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.info,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'App Version Info',
              style: GoogleFonts.poppins(
                color: _SettingsColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _SettingsColors.primaryMedium,
                _SettingsColors.accentSecondary.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _SettingsColors.accentSecondary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVersionInfoRow(Icons.apps, 'App Name', 'RCB'),
              const SizedBox(height: 12),
              _buildVersionInfoRow(Icons.tag, 'Version', 'v1.0.0'),
              const SizedBox(height: 12),
              _buildVersionInfoRow(Icons.build, 'Build', '2025.11.29'),
              const SizedBox(height: 12),
              _buildVersionInfoRow(Icons.code, 'Platform', 'Flutter'),
            ],
          ),
        ),
        actions: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _SettingsColors.accentSecondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildVersionInfoRow(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, color: _SettingsColors.accentSecondary, size: 18),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: _SettingsColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ),
      Text(
        value,
        style: GoogleFonts.poppins(
          color: _SettingsColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

/// Show dialog to update username
void _showUpdateUsernameDialog(BuildContext context, AuthProvider authProvider) {
  final nameController = TextEditingController(
    text: authProvider.userModel?.name ?? '',
  );
  bool isUpdating = false;

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: _SettingsColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: _SettingsColors.accentSecondary.withOpacity(0.3),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _SettingsColors.accentSecondary,
                      _SettingsColors.accent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Update Username',
                style: GoogleFonts.poppins(
                  color: _SettingsColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: GoogleFonts.poppins(color: _SettingsColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  labelStyle: GoogleFonts.poppins(
                    color: _SettingsColors.textSecondary,
                  ),
                  hintText: 'Enter your name',
                  hintStyle: GoogleFonts.poppins(
                    color: _SettingsColors.textSecondary.withOpacity(0.5),
                  ),
                  enabled: !isUpdating,
                  filled: true,
                  fillColor: _SettingsColors.primaryMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _SettingsColors.accentSecondary.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _SettingsColors.accentSecondary.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _SettingsColors.accentSecondary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              if (isUpdating) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _SettingsColors.accentSecondary,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isUpdating
                  ? null
                  : () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: _SettingsColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isUpdating
                  ? null
                  : () async {
                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Name cannot be empty',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: _SettingsColors.warningColor,
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isUpdating = true;
                      });

                      final result = await authProvider.updateProfileName(
                        nameController.text.trim(),
                      );

                      if (context.mounted) {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result['success'] == true
                                  ? result['message'] ?? 'Name updated successfully'
                                  : result['error'] ?? 'Failed to update name',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: result['success'] == true
                                ? _SettingsColors.successColor
                                : _SettingsColors.warningColor,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _SettingsColors.accentSecondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Update',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    ),
  );
}

/// Show dialog to update email
void _showUpdateEmailDialog(BuildContext context, AuthProvider authProvider) {
  final emailController = TextEditingController(
    text: authProvider.userModel?.email ?? '',
  );
  bool isUpdating = false;

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: _SettingsColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: _SettingsColors.accent.withOpacity(0.3),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _SettingsColors.accent,
                      _SettingsColors.accentSecondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.email, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Update Email',
                style: GoogleFonts.poppins(
                  color: _SettingsColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.poppins(color: _SettingsColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: GoogleFonts.poppins(
                    color: _SettingsColors.textSecondary,
                  ),
                  hintText: 'Enter your email',
                  hintStyle: GoogleFonts.poppins(
                    color: _SettingsColors.textSecondary.withOpacity(0.5),
                  ),
                  enabled: !isUpdating,
                  filled: true,
                  fillColor: _SettingsColors.primaryMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _SettingsColors.accent.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _SettingsColors.accent.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _SettingsColors.accent,
                      width: 2,
                    ),
                  ),
                ),
              ),
              if (isUpdating) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_SettingsColors.accent),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isUpdating
                  ? null
                  : () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: _SettingsColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isUpdating
                  ? null
                  : () async {
                      if (emailController.text.trim().isEmpty ||
                          !emailController.text.contains('@')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please enter a valid email address',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: _SettingsColors.warningColor,
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isUpdating = true;
                      });

                      final result = await authProvider.updateProfileEmail(
                        emailController.text.trim(),
                      );

                      if (context.mounted) {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result['success'] == true
                                  ? result['message'] ?? 'Email updated successfully'
                                  : result['error'] ?? 'Failed to update email',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: result['success'] == true
                                ? _SettingsColors.successColor
                                : _SettingsColors.warningColor,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _SettingsColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Update',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    ),
  );
}

/// Show dialog to update password
void _showUpdatePasswordDialog(BuildContext context, AuthProvider authProvider) {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isUpdating = false;
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: _SettingsColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: _SettingsColors.warningColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _SettingsColors.warningColor,
                      _SettingsColors.warningColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lock, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Update Password',
                style: GoogleFonts.poppins(
                  color: _SettingsColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: obscureCurrent,
                  style: GoogleFonts.poppins(color: _SettingsColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: GoogleFonts.poppins(
                      color: _SettingsColors.textSecondary,
                    ),
                    enabled: !isUpdating,
                    filled: true,
                    fillColor: _SettingsColors.primaryMedium,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCurrent ? Icons.visibility : Icons.visibility_off,
                        color: _SettingsColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureCurrent = !obscureCurrent;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _SettingsColors.warningColor.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _SettingsColors.warningColor.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _SettingsColors.warningColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  obscureText: obscureNew,
                  style: GoogleFonts.poppins(color: _SettingsColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: GoogleFonts.poppins(
                      color: _SettingsColors.textSecondary,
                    ),
                    enabled: !isUpdating,
                    filled: true,
                    fillColor: _SettingsColors.primaryMedium,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew ? Icons.visibility : Icons.visibility_off,
                        color: _SettingsColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureNew = !obscureNew;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _SettingsColors.warningColor.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _SettingsColors.warningColor.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _SettingsColors.warningColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirm,
                  style: GoogleFonts.poppins(color: _SettingsColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle: GoogleFonts.poppins(
                      color: _SettingsColors.textSecondary,
                    ),
                    enabled: !isUpdating,
                    filled: true,
                    fillColor: _SettingsColors.primaryMedium,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm ? Icons.visibility : Icons.visibility_off,
                        color: _SettingsColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirm = !obscureConfirm;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _SettingsColors.warningColor.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _SettingsColors.warningColor.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _SettingsColors.warningColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                if (isUpdating) ...[
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _SettingsColors.warningColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isUpdating
                  ? null
                  : () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: _SettingsColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isUpdating
                  ? null
                  : () async {
                      if (currentPasswordController.text.isEmpty ||
                          newPasswordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please fill in all fields',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: _SettingsColors.warningColor,
                          ),
                        );
                        return;
                      }

                      if (newPasswordController.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Password must be at least 6 characters',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: _SettingsColors.warningColor,
                          ),
                        );
                        return;
                      }

                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Passwords do not match',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: _SettingsColors.warningColor,
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isUpdating = true;
                      });

                      final result = await authProvider.updatePassword(
                        currentPassword: currentPasswordController.text,
                        newPassword: newPasswordController.text,
                      );

                      if (context.mounted) {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result['success'] == true
                                  ? result['message'] ??
                                      'Password updated successfully'
                                  : result['error'] ?? 'Failed to update password',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: result['success'] == true
                                ? _SettingsColors.successColor
                                : _SettingsColors.warningColor,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _SettingsColors.warningColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Update',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    ),
  );
}

/// Handle profile picture tap - show options to view profile or upload image
void _handleProfilePictureTap(BuildContext context, AuthProvider authProvider) {
  showModalBottomSheet(
    context: context,
    backgroundColor: _SettingsColors.cardBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: _SettingsColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _SettingsColors.accent,
                    _SettingsColors.accentSecondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            title: Text(
              'View Profile',
              style: GoogleFonts.poppins(
                color: _SettingsColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pop(ctx);
              _showAnimatedProfileDialog(context, authProvider);
            },
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _SettingsColors.successColor,
                    _SettingsColors.successColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
            ),
            title: Text(
              'Upload Photo',
              style: GoogleFonts.poppins(
                color: _SettingsColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pop(ctx);
              _pickAndUploadProfileImage(context, authProvider);
            },
          ),
          if (authProvider.userModel?.photoUrl != null &&
              authProvider.userModel!.photoUrl!.isNotEmpty)
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _SettingsColors.warningColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _SettingsColors.warningColor,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: _SettingsColors.warningColor,
                  size: 20,
                ),
              ),
              title: Text(
                'Remove Photo',
                style: GoogleFonts.poppins(
                  color: _SettingsColors.warningColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _removeProfileImage(context, authProvider);
              },
            ),
        ],
      ),
    ),
  );
}

/// Pick and upload profile image
Future<void> _pickAndUploadProfileImage(
  BuildContext context,
  AuthProvider authProvider,
) async {
  try {
    final ImagePicker picker = ImagePicker();
    
    // Show source selection
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: _SettingsColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: _SettingsColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: Text(
                'Take Photo',
                style: GoogleFonts.poppins(
                  color: _SettingsColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: Text(
                'Choose from Gallery',
                style: GoogleFonts.poppins(
                  color: _SettingsColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    // Pick image
    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image == null) return;

    // Show loading dialog
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _SettingsColors.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  _SettingsColors.accentSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Uploading image...',
                style: GoogleFonts.poppins(
                  color: _SettingsColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Upload to Supabase
    final file = File(image.path);
    final userId = authProvider.user?.uid;
    if (userId == null) {
      if (context.mounted) {
        Navigator.pop(context);
        _showErrorSnackBar(context, 'User not authenticated');
      }
      return;
    }

    final result = await SupabaseStorageService.uploadProfileImage(
      userId: userId,
      imageFile: file,
      isAdmin: authProvider.isAdmin,
    );

    if (!context.mounted) return;
    Navigator.pop(context); // Close loading dialog

    if (result['success'] == true) {
      // Update profile photo URL in Firestore
      final updateResult = await authProvider.updateProfilePhotoUrl(
        result['url'] as String,
      );

      if (context.mounted) {
        if (updateResult['success'] == true) {
          _showSuccessSnackBar(context, 'Profile image uploaded successfully!');
        } else {
          _showErrorSnackBar(
            context,
            updateResult['error'] ?? 'Failed to update profile',
          );
        }
      }
    } else {
      if (context.mounted) {
        _showErrorSnackBar(
          context,
          result['error'] ?? 'Failed to upload image',
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog if still open
      _showErrorSnackBar(context, 'Error: ${e.toString()}');
    }
  }
}

/// Remove profile image
Future<void> _removeProfileImage(
  BuildContext context,
  AuthProvider authProvider,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: _SettingsColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _SettingsColors.warningColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      title: Text(
        'Remove Profile Photo',
        style: GoogleFonts.poppins(
          color: _SettingsColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        'Are you sure you want to remove your profile photo?',
        style: GoogleFonts.poppins(
          color: _SettingsColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              color: _SettingsColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: _SettingsColors.warningColor,
          ),
          child: Text(
            'Remove',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    final userId = authProvider.user?.uid;
    if (userId == null) {
      _showErrorSnackBar(context, 'User not authenticated');
      return;
    }

    // Delete from Supabase
    await SupabaseStorageService.deleteProfileImage(
      userId: userId,
      isAdmin: authProvider.isAdmin,
    );

    // Update Firestore to remove photo URL
    final updateResult = await authProvider.updateProfilePhotoUrl('');

    if (context.mounted) {
      if (updateResult['success'] == true) {
        _showSuccessSnackBar(context, 'Profile photo removed successfully');
      } else {
        _showErrorSnackBar(
          context,
          updateResult['error'] ?? 'Failed to remove photo',
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      _showErrorSnackBar(context, 'Error: ${e.toString()}');
    }
  }
}

/// Show success snackbar
void _showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _SettingsColors.successColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Show error snackbar
void _showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _SettingsColors.warningColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    ),
  );
}

/// Show animated profile information dialog
void _showAnimatedProfileDialog(BuildContext context, AuthProvider authProvider) {
  final userModel = authProvider.userModel;
  if (userModel == null) return;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Profile Information',
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _AnimatedProfileDialog(
        userModel: userModel,
        animation: animation,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // Fade animation
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );
      
      // Scale animation
      final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      );
      
      // Slide animation
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      );

      return FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        ),
      );
    },
  );
}

class _AnimatedProfileDialog extends StatefulWidget {
  final dynamic userModel;
  final Animation<double> animation;

  const _AnimatedProfileDialog({
    required this.userModel,
    required this.animation,
  });

  @override
  State<_AnimatedProfileDialog> createState() => _AnimatedProfileDialogState();
}

class _AnimatedProfileDialogState extends State<_AnimatedProfileDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _contentController;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _contentAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );
    
    // Delay content animation slightly
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        _contentController.forward();
      }
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.userModel?.name ?? 'User';
    final email = widget.userModel?.email ?? 'N/A';
    final status = widget.userModel?.status ?? 'Active';
    final role = widget.userModel?.role?.toString().split('.').last ?? 'user';
    final createdAt = widget.userModel?.createdAt;
    final lastLogin = widget.userModel?.lastLogin;
    final isEmailVerified = widget.userModel?.isEmailVerified ?? false;

    final screenHeight = MediaQuery.of(context).size.height;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: screenHeight * 0.85,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _SettingsColors.cardBg,
              _SettingsColors.primaryMedium,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _SettingsColors.accent.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _SettingsColors.accent.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _SettingsColors.accent,
                      _SettingsColors.accentSecondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    // Close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Avatar
                    FadeTransition(
                      opacity: _contentAnimation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: widget.userModel?.photoUrl == null ||
                                  widget.userModel!.photoUrl!.isEmpty
                              ? LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                )
                              : null,
                          image: widget.userModel?.photoUrl != null &&
                                  widget.userModel!.photoUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(widget.userModel!.photoUrl!),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) {
                                    // If image fails to load, show initial
                                  },
                                )
                              : null,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: widget.userModel?.photoUrl == null ||
                                widget.userModel!.photoUrl!.isEmpty
                            ? Center(
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                  style: GoogleFonts.poppins(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Name
                    FadeTransition(
                      opacity: _contentAnimation,
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Status badge
                    FadeTransition(
                      opacity: _contentAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: _SettingsColors.successColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              status,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: FadeTransition(
                  opacity: _contentAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_contentAnimation),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        _buildInfoRow(
                          Icons.email_rounded,
                          'Email',
                          email,
                          _SettingsColors.accentSecondary,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.person_outline_rounded,
                          'Role',
                          role.toUpperCase(),
                          _SettingsColors.accent,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          isEmailVerified
                              ? Icons.verified_rounded
                              : Icons.email_outlined,
                          'Email Status',
                          isEmailVerified ? 'Verified' : 'Not Verified',
                          isEmailVerified
                              ? _SettingsColors.successColor
                              : _SettingsColors.warningColor,
                        ),
                        if (createdAt != null) ...[
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            Icons.calendar_today_rounded,
                            'Member Since',
                            _formatDate(createdAt),
                            _SettingsColors.accentSecondary,
                          ),
                        ],
                        if (lastLogin != null) ...[
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            Icons.access_time_rounded,
                            'Last Login',
                            _formatDate(lastLogin),
                            _SettingsColors.accent,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: _SettingsColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: _SettingsColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
