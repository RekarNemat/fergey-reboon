import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SettingsPage extends StatefulWidget {
  final AppState appState;
  final VoidCallback onGoToAccount;

  const SettingsPage({
    super.key,
    required this.appState,
    required this.onGoToAccount,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showCustomGoalInput = false;
  final TextEditingController _customGoalCtrl = TextEditingController();

  @override
  void dispose() {
    _customGoalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.appState;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('ڕێکخستنەکان'),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Profile Card (from HTML Sidebar)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                AppColors.teal900.withValues(alpha: 0.4),
                                AppColors.darkCard,
                              ]
                            : [AppColors.teal50, Colors.white],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.teal500.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.teal700,
                              child: Text(
                                s.isLoggedIn ? s.initials : '👤',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.isLoggedIn ? s.fullName : 'میوان',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    s.isLoggedIn
                                        ? s.email
                                        : 'چوونەژوورەوە نەکراوە',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onGoToAccount();
                              },
                              icon: const Icon(Icons.edit_outlined),
                              tooltip: 'دەستکاریکردنی پڕۆفایل',
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: 0.65,
                                  minHeight: 7,
                                  backgroundColor: isDark
                                      ? AppColors.darkSurface
                                      : const Color(0xFFE5E7EB),
                                  color: AppColors.teal500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              '٦٥٪',
                              style: TextStyle(
                                color: AppColors.teal600,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'مەنهەجی گشتی تەواو کراوە',
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 1. Appearance (ڕوالەت)
                  _SectionLabel('ڕوالەت'),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.dark_mode_rounded,
                        iconColor: AppColors.indigo600,
                        title: 'دۆخی تاریک',
                        subtitle: 'گۆڕینی ڕووناکی/تاریکی',
                        trailing: Switch.adaptive(
                          value: s.isDarkMode,
                          activeTrackColor: AppColors.teal500,
                          onChanged: (_) {
                            s.toggleDarkMode();
                            showReboonToast(
                              context,
                              s.isDarkMode
                                  ? 'دۆخی تاریک چالاک کرا'
                                  : 'دۆخی ڕووناک چالاک کرا',
                            );
                          },
                        ),
                        onTap: () => s.toggleDarkMode(),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _IconBadge(
                                  icon: Icons.format_size_rounded,
                                  color: AppColors.teal600,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'قەبارەی تێکست',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${toKurdishDigits(s.fontSize.round())}px',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: s.fontSize,
                              min: 14,
                              max: 24,
                              divisions: 10,
                              activeColor: AppColors.teal600,
                              label: '${s.fontSize.round()}px',
                              onChanged: (v) => s.setFontSize(v),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.font_download_rounded,
                        iconColor: AppColors.purple600,
                        title: 'جۆری فۆنت',
                        trailing: SizedBox(
                          width: 155,
                          child: DropdownButton<String>(
                            value: s.fontFamily,
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            borderRadius: BorderRadius.circular(12),
                            items: const [
                              DropdownMenuItem(
                                value: 'NotoSansArabic',
                                child: Text(
                                  'فۆنتی ڕێبوون (ستایل)',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'IBMPlexSansArabic',
                                child: Text(
                                  'IBM Plex Arabic',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'System',
                                child: Text(
                                  'سیستەم',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                s.setFontFamily(val);
                                showReboonToast(context, 'فۆنت گۆڕدرا');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 2. Notifications (Voice 4: remove "پوش", write "ئاگادارکردنەوە (Notification)")
                  _SectionLabel('ئاگادارکردنەوەکان'),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.notifications_active_rounded,
                        iconColor: AppColors.rose600,
                        title: 'ئاگادارکردنەوە (Notification)',
                        subtitle: 'سیستەمی ئاگادارکردنەوەی فێرگە',
                        trailing: Switch.adaptive(
                          value: s.pushNotifications,
                          activeTrackColor: AppColors.teal500,
                          onChanged: (v) {
                            s.setPushNotifications(v);
                            showReboonToast(
                              context,
                              v
                                  ? 'ئاگادارکردنەوە چالاک کرا'
                                  : 'ئاگادارکردنەوە ناچالاک کرا',
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.email_outlined,
                        iconColor: AppColors.amber600,
                        title: 'ئاگادارکردنەوەی ئیمەیڵ',
                        subtitle: 'نامەکانی نوێکردنەوە',
                        trailing: Switch.adaptive(
                          value: s.emailNotifications,
                          activeTrackColor: AppColors.teal500,
                          onChanged: (v) {
                            s.setEmailNotifications(v);
                            showReboonToast(
                              context,
                              v
                                  ? 'ئاگادارکردنەوەی ئیمەیڵ چالاک کرا'
                                  : 'ئاگادارکردنەوەی ئیمەیڵ ناچالاک کرا',
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.alarm_rounded,
                        iconColor: AppColors.blue600,
                        title: 'بیرکردنەوەی ڕۆژانە',
                        subtitle: 'بیرخستنەوەی خوێندن',
                        trailing: Switch.adaptive(
                          value: s.dailyReminder,
                          activeTrackColor: AppColors.teal500,
                          onChanged: (v) {
                            s.setDailyReminder(v);
                            showReboonToast(
                              context,
                              v ? 'بیرکردنەوە چالاک کرا' : 'بیرکردنەوە ناچالاک کرا',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 3. Learning (خوێندن)
                  _SectionLabel('خوێندن'),
                  _SettingsGroup(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _IconBadge(
                                  icon: Icons.bar_chart_rounded,
                                  color: AppColors.emerald600,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'ئامانجی ڕۆژانە',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${toKurdishDigits(s.dailyGoalMinutes)} خولەک لە ڕۆژێکدا',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 132,
                                  child: DropdownButton<String>(
                                    value: [15, 30, 60, 120]
                                            .contains(s.dailyGoalMinutes) &&
                                        !_showCustomGoalInput
                                        ? s.dailyGoalMinutes.toString()
                                        : 'custom',
                                    isExpanded: true,
                                    underline: const SizedBox.shrink(),
                                    borderRadius: BorderRadius.circular(12),
                                    items: const [
                                      DropdownMenuItem(
                                        value: '15',
                                        child: Text('١٥ خولەک', overflow: TextOverflow.ellipsis),
                                      ),
                                      DropdownMenuItem(
                                        value: '30',
                                        child: Text('٣٠ خولەک', overflow: TextOverflow.ellipsis),
                                      ),
                                      DropdownMenuItem(
                                        value: '60',
                                        child: Text('١ کاتژمێر', overflow: TextOverflow.ellipsis),
                                      ),
                                      DropdownMenuItem(
                                        value: '120',
                                        child: Text('٢ کاتژمێر', overflow: TextOverflow.ellipsis),
                                      ),
                                      DropdownMenuItem(
                                        value: 'custom',
                                        child: Text('خۆم دیاری دەکەم ✏️', overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      if (val == null) return;
                                      if (val == 'custom') {
                                        setState(() => _showCustomGoalInput = true);
                                      } else {
                                        setState(() => _showCustomGoalInput = false);
                                        s.setDailyGoalMinutes(int.parse(val));
                                        showReboonToast(
                                          context,
                                          'ئامانجی ڕۆژانە گۆڕدرا بۆ ${toKurdishDigits(val)} خولەک',
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (_showCustomGoalInput) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      controller: _customGoalCtrl,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'خولەک',
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('خولەک'),
                                  const Spacer(),
                                  FilledButton(
                                    onPressed: () {
                                      final mins =
                                          int.tryParse(_customGoalCtrl.text.trim());
                                      if (mins == null || mins < 1 || mins > 480) {
                                        showReboonToast(
                                          context,
                                          'تکایە ژمارەیەک لە ١ بۆ ٤٨٠ خولەک بنووسە',
                                        );
                                        return;
                                      }
                                      s.setDailyGoalMinutes(mins);
                                      setState(() => _showCustomGoalInput = false);
                                      showReboonToast(
                                        context,
                                        'ئامانجی ڕۆژانە گۆڕدرا بۆ ${toKurdishDigits(mins)} خولەک',
                                      );
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.teal700,
                                    ),
                                    child: const Text('پەسەندکردن'),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.download_for_offline_rounded,
                        iconColor: AppColors.sky600,
                        title: 'داگرتنی ئۆفلاین',
                        subtitle: 'وانەکان بۆ بەبێ ئینتەرنێت',
                        trailing: Switch.adaptive(
                          value: s.offlineDownloadsEnabled,
                          activeTrackColor: AppColors.teal500,
                          onChanged: (v) {
                            s.setOfflineEnabled(v);
                            showReboonToast(
                              context,
                              v
                                  ? 'داگرتنی ئۆفلاین چالاک کرا'
                                  : 'داگرتنی ئۆفلاین ناچالاک کرا',
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // Offline lessons list when enabled
                  if (s.offlineDownloadsEnabled) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '📥 وانە داگیراوەکان',
                          style: TextStyle(
                            color: AppColors.teal700,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '٤٥ MB',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (s.offlineLessons.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: Text(
                          '📂 هیچ وانەیەک داگیراو نییە',
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    else
                      ...s.offlineLessons.map(
                        (lesson) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(lesson.icon, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lesson.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      lesson.size,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  s.removeOfflineLesson(lesson.id);
                                  showReboonToast(
                                    context,
                                    'وانەکە سڕدرایەوە لە لیستی ئۆفلاین',
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.rose600,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 18),

                  // 4. About (دەربارە)
                  _SectionLabel('دەربارە'),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        iconColor: Colors.grey.shade600,
                        title: 'وەشانی ئەپ',
                        trailing: const Text(
                          'v1.2.0',
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.mail_outline_rounded,
                        iconColor: Colors.pink.shade400,
                        title: 'پەیوەندیمان پێوە بکە',
                        subtitle: 'ڕای خۆت بنێرە',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => showReboonToast(context, 'پەیوەندی نێردرا'),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.star_rate_rounded,
                        iconColor: AppColors.amber500,
                        title: 'هەڵسەنگاندنی ئەپ',
                        subtitle: 'ئەپەکەمان هەڵبسەنگێنە',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () =>
                            showReboonToast(context, 'هەڵسەنگاندن پاشەکەوتکرا ⭐'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Login / Logout button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (s.isLoggedIn) {
                          s.logout();
                          showReboonToast(context, 'لە هەژمار چوویتە دەرەوە');
                        } else {
                          Navigator.pop(context);
                          widget.onGoToAccount();
                        }
                      },
                      icon: Icon(
                        s.isLoggedIn
                            ? Icons.logout_rounded
                            : Icons.login_rounded,
                      ),
                      label: Text(
                        s.isLoggedIn
                            ? 'چوونە دەرەوە لە هەژمار'
                            : 'چوونەژوورەوە بۆ هەژمار',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: s.isLoggedIn
                            ? AppColors.rose600.withValues(alpha: 0.12)
                            : AppColors.teal700,
                        foregroundColor:
                            s.isLoggedIn ? AppColors.rose600 : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4, left: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.darkCard : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBadge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 19),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            _IconBadge(icon: icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              Flexible(
                fit: FlexFit.loose,
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

