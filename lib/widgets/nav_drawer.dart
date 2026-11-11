import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/reboon_logo.dart';
import '../../widgets/common_widgets.dart';
import '../../screens/pages/about_organization_page.dart';
import '../../screens/pages/about_academy_page.dart';
import '../../screens/pages/settings_page.dart';

/// Redesigned Hamburger Drawer (☰) per Voice 4 & 5:
/// Separated cleanly from Settings (⚙️), containing:
/// 1. ناساندنی ڕێکخراو (Organization intro matching Image 4 + social media)
/// 2. ناساندنی فێرگە (Academy intro & goals matching Image 5)
class ReboonNavDrawer extends StatelessWidget {
  final AppState appState;
  final VoidCallback onOpenLive;
  final VoidCallback onOpenTeachers;
  final VoidCallback onOpenAccountTab;

  const ReboonNavDrawer({
    super.key,
    required this.appState,
    required this.onOpenLive,
    required this.onOpenTeachers,
    required this.onOpenAccountTab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Branded Drawer Header
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [AppColors.teal800, AppColors.teal900],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal900.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const ReboonEmblem(
                    height: 52,
                    backgroundColor: AppColors.gold,
                    strokeColor: AppColors.teal900,
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'فێرگەی ڕێبوون',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ڕێکخراوی ڕێبوون بۆ پەروەردە و ڕاهێنان',
                          style: TextStyle(
                            color: AppColors.amber400,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Two Main Intro Sections requested in Voice 4 & 5
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Text(
                      'ناساندن و پێناسە',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _DrawerCardButton(
                    icon: Icons.apartment_rounded,
                    color: const Color(0xFF1F9A58),
                    title: 'ناساندنی ڕێکخراو',
                    subtitle: 'دروشم، پێناسە، بواری کارکردن و سۆشیاڵ میدیا',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutOrganizationPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _DrawerCardButton(
                    icon: Icons.school_rounded,
                    color: AppColors.teal700,
                    title: 'ناساندنی فێرگە',
                    subtitle: 'ئامانجەکانی فێربوون لە فێرگەی ڕێبوون',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutAcademyPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Divider(height: 1),
            ),

            // Secondary Quick Access
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  ListTile(
                    leading: const Icon(Icons.live_tv_rounded, color: AppColors.rose600),
                    title: const Text('لایڤی فێرگە', style: TextStyle(fontWeight: FontWeight.w700)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.rose600.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: AppColors.rose600,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    onTap: () {
                      Navigator.pop(context);
                      onOpenLive();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.groups_rounded, color: AppColors.amber600),
                    title: const Text('مامۆستایانی فێرگە', style: TextStyle(fontWeight: FontWeight.w700)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    onTap: () {
                      Navigator.pop(context);
                      onOpenTeachers();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_rounded, color: AppColors.teal700),
                    title: const Text('ڕێکخستنەکان', style: TextStyle(fontWeight: FontWeight.w700)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsPage(
                            appState: appState,
                            onGoToAccount: onOpenAccountTab,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.mail_outline_rounded, color: AppColors.sky600),
                    title: const Text('پەیوەندیمان پێوە بکە', style: TextStyle(fontWeight: FontWeight.w700)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    onTap: () {
                      Navigator.pop(context);
                      showReboonToast(context, 'پەیوەندی نێردرا بۆ تیمی ڕێبوون');
                    },
                  ),
                ],
              ),
            ),

            // Footer version
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                'فێرگەی ڕێبوون • وەشانی v1.2.0',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerCardButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DrawerCardButton({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? color.withValues(alpha: 0.14)
              : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          ],
        ),
      ),
    );
  }
}

