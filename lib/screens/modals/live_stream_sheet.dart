import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

void openLiveStreamSheet(
  BuildContext context,
  AppState appState, {
  required VoidCallback onOpenAccountTab,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _LiveStreamSheet(
      appState: appState,
      onOpenAccountTab: onOpenAccountTab,
    ),
  );
}

class _LiveStreamSheet extends StatefulWidget {
  final AppState appState;
  final VoidCallback onOpenAccountTab;

  const _LiveStreamSheet({
    required this.appState,
    required this.onOpenAccountTab,
  });

  @override
  State<_LiveStreamSheet> createState() => _LiveStreamSheetState();
}

class _LiveStreamSheetState extends State<_LiveStreamSheet> {
  bool _isPlaying = true;
  bool _isMuted = false;
  final TextEditingController _chatCtrl = TextEditingController();

  @override
  void dispose() {
    _chatCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _chatCtrl.text.trim();
    if (text.isEmpty) return;

    final ok = await ensureAuthenticated(
      context,
      widget.appState,
      actionLabel: 'ناردنی پەیام لە لایڤی فێرگەی ڕێبوون',
      onOpenAccountTab: () {
        Navigator.pop(context);
        widget.onOpenAccountTab();
      },
    );
    if (!ok || !mounted) return;

    widget.appState.sendLiveMessage(text);
    _chatCtrl.clear();
    showReboonToast(context, 'پەیامەکەت نێردرا بۆ لایڤ 💬');
  }

  void _openFullscreenPlayer() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_filled_rounded,
                      color: AppColors.rose600,
                      size: 76,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'وانەی بەردەوام: شیکاری سیرەی نەبەوی لەگەڵ مامۆستا',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '🔴 LIVE • ٠١:٢٤:١٥ • ٣٤٢ بینەر',
                      style: TextStyle(color: AppColors.amber400),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton.filled(
                  onPressed: () => Navigator.pop(ctx),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.16),
                  ),
                  icon: const Icon(Icons.fullscreen_exit_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            minChildSize: 0.55,
            maxChildSize: 0.96,
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
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.rose600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.live_tv_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'لایڤی فێرگەی ڕێبوون',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.rose600,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    '🔴 LIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'بینەرانی ڕاستەوخۆ: ٣٤٢ کەس',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Video Screen
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                AppColors.teal900,
                                Color(0xFF0F172A),
                                Color(0xFF881337),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      '🔴 ڕاستەوخۆ (Live)',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      '🎓 وانەی هەفتانەی سیرە',
                                      style: TextStyle(
                                        color: AppColors.amber400,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() => _isPlaying = !_isPlaying);
                                  showReboonToast(
                                    context,
                                    _isPlaying
                                        ? 'پەخشی ڕاستەوخۆ بەردەوامبووەوە ▶'
                                        : 'پەخشی ڕاستەوخۆ وەستا ⏸',
                                  );
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: AppColors.rose600,
                                      child: Icon(
                                        _isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'وانەی بەردەوام: شیکاری سیرەی نەبەوی لەگەڵ مامۆستا',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          setState(() => _isPlaying = !_isPlaying),
                                      child: Text(
                                        _isPlaying ? '⏸ وەستان' : '▶ پەخش',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    InkWell(
                                      onTap: () =>
                                          setState(() => _isMuted = !_isMuted),
                                      child: Text(
                                        _isMuted ? '🔇 بێدەنگ' : '🔊 دەنگ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      '٠١:٢٤:١٥',
                                      style: TextStyle(
                                        color: AppColors.rose600,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: _openFullscreenPlayer,
                                      child: const Text(
                                        '⛶ پڕاوپڕ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Live Reminder Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.rose600.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.rose600.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '📢 ئاگاداری لایڤ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.rose600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'هەموو پێنجشەممە کاتژمێر ٨:٣٠ی ئێوارە پەخشی ڕاستەوخۆمان هەیە.',
                                    style: TextStyle(fontSize: 11.5),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton(
                              onPressed: () => showReboonToast(
                                context,
                                'ئاگادارکردنەوەی لایڤ چالاککرا 🔔',
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.rose600,
                              ),
                              child: const Text('🔔 ئاگادارم بکە'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Live Chat Box
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '💬 چاتی ڕاستەوخۆی بەکارهێنەران',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...widget.appState.liveChatMessages.map(
                              (m) => Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSurface
                                      : const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                      TextSpan(
                                        text: '${m['name']}: ',
                                        style: const TextStyle(
                                          color: AppColors.teal600,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      TextSpan(text: m['msg']),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _chatCtrl,
                                    onSubmitted: (_) => _sendMessage(),
                                    decoration: const InputDecoration(
                                      hintText: 'پرسیار یان تێبینی بنووسە...',
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                FilledButton(
                                  onPressed: _sendMessage,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.teal700,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text('ناردن ✉️'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

