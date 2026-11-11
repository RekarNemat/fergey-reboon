import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/home_content_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/reboon_logo.dart';

class AboutOrganizationPage extends StatelessWidget {
  const AboutOrganizationPage({super.key});

  Future<void> _openSocial(BuildContext context, String url, String label) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      showReboonToast(context, 'کردنەوەی پەڕەی $label');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          OrganizationInfo.pageTitle,
          style: TextStyle(
            color: Color(0xFF1B8A5A),
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF6FBF8),
      ),
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF6FBF8),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
            child: Column(
              children: [
                // Circular Logo Emblem with subtle halo matching Image 4
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B8A5A).withValues(alpha: 0.14),
                        blurRadius: 24,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const ReboonEmblem(
                    height: 68,
                    backgroundColor: Color(0xFF28744B),
                    strokeColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Organization Names (Kurdish, Arabic, English) matching Image 4
                Text(
                  OrganizationInfo.orgNameKu,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: isDark ? AppColors.teal400 : const Color(0xFF1B8A5A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  OrganizationInfo.orgSubtitleKu,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  OrganizationInfo.orgNameAr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  OrganizationInfo.orgNameEn,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'NotoSans',
                    color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 20),

                // Slogan Card (دروشم) - rich green card matching Image 4
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xFF1F9A58), Color(0xFF15804A)],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B8A5A).withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'دروشم',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        OrganizationInfo.slogan,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Definition Card (پێناسە) matching Image 4
                _InfoWhiteCard(
                  icon: Icons.info_outline_rounded,
                  title: 'پێناسە',
                  child: Text(
                    OrganizationInfo.definition,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Work Areas Card (بواری کارکردن) matching Image 4
                _InfoWhiteCard(
                  icon: Icons.work_outline_rounded,
                  title: 'بواری کارکردن',
                  child: Column(
                    children: OrganizationInfo.workAreas
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 9),
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1F9A58),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      height: 1.75,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Social Media & Pages Card (requested in Voice 4 & 5)
                _InfoWhiteCard(
                  icon: Icons.share_rounded,
                  title: 'سۆشیاڵ میدیا و پەڕە فەرمییەکان',
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _SocialChip(
                        label: 'فەیسبووک',
                        icon: Icons.facebook_rounded,
                        color: const Color(0xFF1877F2),
                        onTap: () => _openSocial(
                          context,
                          'https://facebook.com',
                          'فەیسبووکی ڕێکخراوی ڕێبوون',
                        ),
                      ),
                      _SocialChip(
                        label: 'یوتیوب',
                        icon: Icons.play_circle_fill_rounded,
                        color: const Color(0xFFFF0000),
                        onTap: () => _openSocial(
                          context,
                          'https://youtube.com',
                          'یوتیوبی فێرگەی ڕێبوون',
                        ),
                      ),
                      _SocialChip(
                        label: 'تێلەگرام',
                        icon: Icons.send_rounded,
                        color: const Color(0xFF0088CC),
                        onTap: () => _openSocial(
                          context,
                          'https://t.me',
                          'کەناڵی تێلەگرامی ڕێبوون',
                        ),
                      ),
                      _SocialChip(
                        label: 'ماڵپەڕی فەرمی',
                        icon: Icons.language_rounded,
                        color: AppColors.teal700,
                        onTap: () => _openSocial(
                          context,
                          'https://rekarnemat.github.io',
                          'ماڵپەڕی فەرمیی ڕێبوون',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoWhiteCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _InfoWhiteCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : const Color(0xFFEAEFEF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F9A58).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF1B8A5A), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.teal400 : const Color(0xFF1B8A5A),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SocialChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

