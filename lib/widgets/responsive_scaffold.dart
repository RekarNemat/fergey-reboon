import 'package:flutter/material.dart';
import '../screens/modals/live_stream_sheet.dart';
import '../screens/modals/notifications_sheet.dart';
import '../screens/modals/search_sheet.dart';
import '../screens/modals/teachers_sheet.dart';
import '../screens/pages/settings_page.dart';
import '../screens/tabs/academy_tab.dart';
import '../screens/tabs/account_tab.dart';
import '../screens/tabs/favorites_tab.dart';
import '../screens/tabs/home_tab.dart';
import '../screens/tabs/sanad_tab.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'nav_drawer.dart';
import 'reboon_logo.dart';

class ResponsiveMainShell extends StatelessWidget {
  final AppState appState;

  const ResponsiveMainShell({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final s = appState;
    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        final pages = [
          SanadTab(
            appState: s,
            onGoToAccount: () => s.setTabIndex(4),
          ),
          AcademyTab(
            appState: s,
            onGoToAccount: () => s.setTabIndex(4),
          ),
          HomeTab(
            appState: s,
            onGoToAcademy: () => s.setTabIndex(1),
            onGoToSanad: () => s.setTabIndex(0),
            onGoToAccount: () => s.setTabIndex(4),
          ),
          FavoritesTab(
            appState: s,
            onGoToHome: () => s.setTabIndex(2),
            onGoToAccount: () => s.setTabIndex(4),
          ),
          AccountTab(appState: s),
        ];

        final unread = s.unreadNotificationsCount;

        return Scaffold(
          drawer: ReboonNavDrawer(
            appState: s,
            onOpenLive: () => openLiveStreamSheet(
              context,
              s,
              onOpenAccountTab: () => s.setTabIndex(4),
            ),
            onOpenTeachers: () => openAcademyTeachersSheet(context, s),
            onOpenAccountTab: () => s.setTabIndex(4),
          ),
          appBar: AppBar(
            backgroundColor: AppColors.teal800,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            leading: Builder(
              builder: (ctx) => IconButton(
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                tooltip: 'پێڕست و ناساندن',
              ),
            ),
            title: const Text(
              'فێرگەی ڕێبوون',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 19,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => openGlobalSearchSheet(
                  context,
                  s,
                  onOpenAccountTab: () => s.setTabIndex(4),
                ),
                icon: const Icon(Icons.search_rounded, color: Colors.white),
                tooltip: 'گەڕان',
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () => openNotificationsSheet(context, s),
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                    ),
                    tooltip: 'ئاگادارکردنەوەکان',
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 9,
                      right: 9,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: AppColors.rose600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsPage(
                      appState: s,
                      onGoToAccount: () => s.setTabIndex(4),
                    ),
                  ),
                ),
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                tooltip: 'ڕێکخستنەکان',
              ),
            ],
          ),
          body: IndexedStack(
            index: s.currentTabIndex,
            children: pages,
          ),
          bottomNavigationBar: _ReboonBottomNavBar(
            currentIndex: s.currentTabIndex,
            favCount: s.favoriteKeys.length,
            onTap: s.setTabIndex,
          ),
        );
      },
    );
  }
}

/// Exact 5-tab Dark-Teal & Gold Bottom Navigation Bar matching Image 2 & Voice 2:
/// Right-to-Left (RTL):
/// 0: سەنەدەکان | 1: ئەکادیمیا | 2: فێرگەی ڕێبوون (center logo) | 3: وانە دڵخوازەکان | 4: هەژمار
class _ReboonBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final int favCount;
  final ValueChanged<int> onTap;

  const _ReboonBottomNavBar({
    required this.currentIndex,
    required this.favCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.teal800,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(4, 8, 4, bottomPad > 0 ? bottomPad : 8),
      child: Row(
        children: [
          _NavItem(
            label: 'سەنەدەکان',
            icon: Icons.workspace_premium_outlined,
            activeIcon: Icons.workspace_premium_rounded,
            active: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            label: 'ئەکادیمیا',
            icon: Icons.laptop_chromebook_outlined,
            activeIcon: Icons.laptop_chromebook_rounded,
            active: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          // Center Brand Tab: Calligraphic "ڕێبوون" Emblem
          Expanded(
            child: InkWell(
              onTap: () => onTap(2),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: currentIndex == 2 ? 1.12 : 0.96,
                      duration: const Duration(milliseconds: 200),
                      child: ReboonEmblem(
                        height: 30,
                        backgroundColor: currentIndex == 2
                            ? AppColors.gold
                            : AppColors.gold.withValues(alpha: 0.8),
                        strokeColor: AppColors.teal900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'فێرگەی ڕێبوون',
                        maxLines: 1,
                        style: TextStyle(
                          color: currentIndex == 2
                              ? AppColors.gold
                              : Colors.white.withValues(alpha: 0.82),
                          fontWeight: currentIndex == 2
                              ? FontWeight.w800
                              : FontWeight.w600,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _NavItem(
            label: 'وانە دڵخوازەکان',
            icon: Icons.favorite_border_rounded,
            activeIcon: Icons.favorite_rounded,
            active: currentIndex == 3,
            badgeCount: favCount > 0 ? favCount : null,
            onTap: () => onTap(3),
          ),
          _NavItem(
            label: 'هەژمار',
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            active: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool active;
  final int? badgeCount;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.active,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.gold.withValues(alpha: 0.16)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      active ? activeIcon : icon,
                      color: active
                          ? AppColors.gold
                          : AppColors.gold.withValues(alpha: 0.78),
                      size: 24,
                    ),
                  ),
                  if (badgeCount != null)
                    Positioned(
                      top: -2,
                      left: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.rose600,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          toKurdishDigits(badgeCount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    color: active
                        ? AppColors.gold
                        : AppColors.gold.withValues(alpha: 0.85),
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

