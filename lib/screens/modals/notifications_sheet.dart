import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

void openNotificationsSheet(BuildContext context, AppState appState) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _NotificationsSheet(appState: appState),
  );
}

class _NotificationsSheet extends StatefulWidget {
  final AppState appState;
  const _NotificationsSheet({required this.appState});

  @override
  State<_NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<_NotificationsSheet> {
  String _filter = 'all'; // 'all', 'unread', 'read'

  @override
  Widget build(BuildContext context) {
    final s = widget.appState;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        final filtered = s.notifications.where((n) {
          if (_filter == 'unread') return !n.read;
          if (_filter == 'read') return n.read;
          return true;
        }).toList();

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          maxChildSize: 0.92,
          builder: (_, controller) => Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
                child: Row(
                  children: [
                    const Text(
                      '🔔 ئاگادارکردنەوەکان',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        s.markAllNotificationsRead();
                        showReboonToast(context, 'هەمووی کرایە خوێنراو');
                      },
                      child: const Text('هەمووی بکە بە خوێنراو'),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _FilterTab(
                      label: 'هەمووی',
                      active: _filter == 'all',
                      onTap: () => setState(() => _filter = 'all'),
                    ),
                    _FilterTab(
                      label:
                          'نەخوێنراو (${toKurdishDigits(s.unreadNotificationsCount)})',
                      active: _filter == 'unread',
                      onTap: () => setState(() => _filter = 'unread'),
                    ),
                    _FilterTab(
                      label: 'خوێنراو',
                      active: _filter == 'read',
                      onTap: () => setState(() => _filter = 'read'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 14),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('📭 هیچ ئاگادارکردنەوەیەک نییە.'),
                      )
                    : ListView.builder(
                        controller: controller,
                        padding: const EdgeInsets.all(14),
                        itemCount: filtered.length,
                        itemBuilder: (_, idx) {
                          final n = filtered[idx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: !n.read
                                  ? AppColors.teal500.withValues(alpha: 0.08)
                                  : (isDark ? AppColors.darkCard : Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: !n.read
                                    ? AppColors.teal500.withValues(alpha: 0.35)
                                    : (isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : const Color(0xFFE5E7EB)),
                              ),
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              borderRadius: BorderRadius.circular(16),
                              clipBehavior: Clip.antiAlias,
                              child: ListTile(
                              onTap: () => s.markNotificationRead(n.id),
                              leading: Text(n.icon, style: const TextStyle(fontSize: 22)),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      n.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13.5,
                                        color: !n.read ? AppColors.teal700 : null,
                                      ),
                                    ),
                                  ),
                                  if (!n.read)
                                    const CircleAvatar(
                                      radius: 4,
                                      backgroundColor: AppColors.teal500,
                                    ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(n.text, style: const TextStyle(fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text(
                                    n.time,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.teal600 : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
              color: active ? AppColors.teal600 : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

