import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/academy_models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/reboon_logo.dart';

void openSanadDetailSheet(
  BuildContext context,
  AppState appState,
  SanadItemData sanad, {
  required VoidCallback onOpenAccountTab,
}) async {
  final ok = await ensureAuthenticated(
    context,
    appState,
    actionLabel: sanad.title,
    onOpenAccountTab: onOpenAccountTab,
  );
  if (!ok || !context.mounted) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => SanadDetailSheet(appState: appState, sanad: sanad),
  );
}

void openSanadCertificatePreviewSheet(
  BuildContext context,
  AppState appState,
  SanadItemData sanad, {
  required VoidCallback onOpenAccountTab,
}) async {
  final ok = await ensureAuthenticated(
    context,
    appState,
    actionLabel: 'ئیجازە و سەنەد: ${sanad.shortTitle}',
    onOpenAccountTab: onOpenAccountTab,
  );
  if (!ok || !context.mounted) return;

  final studentName = appState.isLoggedIn ? appState.fullName : 'فێرخوازی ڕێبوون';
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              children: [
                const Text(
                  '📜 شەهادەی ئیجازەی زانستی (PDF)',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF8F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.teal700, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.teal900.withValues(alpha: 0.12),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                      style: TextStyle(
                        color: AppColors.teal700,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'شَهَادَةُ إِجَازَةٍ عِلْمِيَّةٍ بِالسَّنَدِ الْمُتَّصِلِ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.teal800,
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'فێرگەی ڕێبوون بۆ زانستە شەرعییەکان — فێربوونی ئەکادیمی بە سەنەدی متصل',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF44403C),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.teal50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.teal400),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'ئەم ئیجازە زانستییە پێشکەش دەکرێت بە فێرخوازی بەڕێز:',
                            style: TextStyle(fontSize: 12, color: Color(0xFF44403C)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            studentName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.teal800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'بۆ وەرگرتنی: ${sanad.title}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF57534E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE7E5E4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🔗 زنجیرەی سەنەدی متصل (سلسلة السند المبارك):',
                            style: TextStyle(
                              color: AppColors.teal700,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          const Divider(),
                          ...List.generate(sanad.chain.length, (idx) {
                            final item = sanad.chain[idx];
                            final name = idx == 0 ? studentName : item.name;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                '[الرتبة ${toKurdishDigits(idx + 1)}] $name — (${item.title})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF292524),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مۆری ئەکادیمیا: فێرگەی ڕێبوون',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1C1917),
                              ),
                            ),
                            Text(
                              '© ٢٠٢٦ - بەڵگەنامەی فەرمی',
                              style: TextStyle(fontSize: 10, color: Color(0xFF78716C)),
                            ),
                          ],
                        ),
                        const ReboonEmblem(
                          height: 48,
                          backgroundColor: AppColors.teal700,
                          strokeColor: AppColors.gold,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'مامۆستای ئیجازەدار:',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1C1917),
                              ),
                            ),
                            Text(
                              sanad.teacherName,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.teal700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  showReboonToast(
                    context,
                    'ئیجازەی سەنەد (${sanad.science}) بە PDF داگیرا 📜',
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: const Text('داگرتن و پاشەکەوتکردنی ئیجازەی PDF'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.teal700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class SanadDetailSheet extends StatefulWidget {
  final AppState appState;
  final SanadItemData sanad;

  const SanadDetailSheet({
    super.key,
    required this.appState,
    required this.sanad,
  });

  @override
  State<SanadDetailSheet> createState() => _SanadDetailSheetState();
}

class _SanadDetailSheetState extends State<SanadDetailSheet> {
  int _tab = 0; // 0: chain, 1: req, 2: lessons, 3: voice & exam
  bool _isRecording = false;
  bool _hasRecorded = false;
  bool _voiceSubmitted = false;
  int _recSeconds = 0;
  Timer? _recTimer;
  DateTime? _scheduledExamDate;

  @override
  void dispose() {
    _recTimer?.cancel();
    super.dispose();
  }

  void _toggleRecording() {
    if (!_isRecording) {
      _recTimer?.cancel();
      setState(() {
        _isRecording = true;
        _hasRecorded = false;
        _voiceSubmitted = false;
        _recSeconds = 0;
      });
      _recTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _recSeconds++);
      });
    } else {
      _recTimer?.cancel();
      setState(() {
        _isRecording = false;
        _hasRecorded = true;
      });
    }
  }

  Future<void> _pickExamDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 2)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 30),
    );
    if (time == null || !mounted) return;
    setState(() {
      _scheduledExamDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
    showReboonToast(context, 'ژوانگەی تاقیکردنەوەی ڕاستەوخۆ بە زووم جێگیرکرا 📅');
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.appState;
    final sanad = widget.sanad;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.55,
          maxChildSize: 0.96,
          builder: (_, controller) {
            return Column(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: sanad.color.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              sanad.science,
                              style: TextStyle(
                                color: sanad.color,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.amber500.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '📜 ڕشتەی سەنەدی متصل',
                              style: TextStyle(
                                color: AppColors.amber600,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      Text(
                        sanad.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'مەتن / کتێب: ${sanad.book} • مامۆستا: ${sanad.teacherName}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // 4 Sub-Tabs matching HTML
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      _SubTabPill(
                        label: '🔗 ڕشتەی سەنەدەکەت',
                        active: _tab == 0,
                        onTap: () => setState(() => _tab = 0),
                      ),
                      _SubTabPill(
                        label: '📌 شەرتی ناچاری',
                        active: _tab == 1,
                        onTap: () => setState(() => _tab = 1),
                      ),
                      _SubTabPill(
                        label: '🎧 وانەکانی گوێگرتن (٥)',
                        active: _tab == 2,
                        onTap: () => setState(() => _tab = 2),
                      ),
                      _SubTabPill(
                        label: '🎙️ عەرزی دەنگی & تاقیکردنەوە',
                        active: _tab == 3,
                        onTap: () => setState(() => _tab = 3),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 16),

                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    children: [
                      if (_tab == 0) _buildChainTab(s, sanad, isDark),
                      if (_tab == 1) _buildReqTab(sanad, isDark),
                      if (_tab == 2) _buildLessonsTab(s, sanad, isDark),
                      if (_tab == 3) _buildExamTab(sanad, isDark),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            openSanadCertificatePreviewSheet(
                              context,
                              s,
                              sanad,
                              onOpenAccountTab: () {},
                            );
                          },
                          icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                          label: const Text('📄 داگرتنی شەهادەی ئیجازە (PDF)'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.teal700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildChainTab(AppState s, SanadItemData sanad, bool isDark) {
    final studentName = s.isLoggedIn ? s.fullName : 'فێرخواز (ناوی تۆ)';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.amber500.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.amber500.withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📜 ڕشتەی سەنەدەکەت (ئەمە سەنەدەکەتە ئەگەر تەواوی بکەیت بە ئیجازە):',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                'زنجیرەی پیرۆز و متصلی گێڕەرەوان لە فێرخوازەوە تاوەکو سیدنا ونبينا محمد (صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ) و رب العالمين:',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(sanad.chain.length, (idx) {
          final node = sanad.chain[idx];
          final name = idx == 0 ? studentName : node.name;
          final isProphet = node.name.contains('محمد');
          final isGod = node.name.contains('رب العالمين');

          Color bg = isDark ? AppColors.darkCard : Colors.white;
          Color border = isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB);
          String icon = '👤';

          if (idx == 0) {
            bg = AppColors.teal500.withValues(alpha: 0.12);
            border = AppColors.teal500;
            icon = '🎓';
          } else if (isProphet) {
            bg = AppColors.amber500.withValues(alpha: 0.16);
            border = AppColors.amber500;
            icon = '⭐️';
          } else if (isGod) {
            bg = AppColors.emerald600.withValues(alpha: 0.16);
            border = AppColors.emerald600;
            icon = '✨';
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.grey.withValues(alpha: 0.14),
                      child: Text(icon, style: const TextStyle(fontSize: 15)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            node.title,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'الرتبة ${toKurdishDigits(idx + 1)}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (idx < sanad.chain.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    size: 16,
                    color: AppColors.teal600,
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildReqTab(SanadItemData sanad, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.amber500.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.amber500.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sanad.reqTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.amber600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(sanad.reqText, style: const TextStyle(height: 1.7)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'کورتەی هەنگاوەکانی وەرگرتنی سەنەد:',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              SizedBox(height: 10),
              Text('✅ هەنگاوی ١: گوێگرتن لە وانەکانی دەقەکە لە تابی "وانەکانی گوێگرتن".'),
              SizedBox(height: 6),
              Text('🎙️ هەنگاوی ٢: تۆمارکردنی دەنگ یان دانانی داواکاری تاقیکردنەوە بە زووم.'),
              SizedBox(height: 6),
              Text('👨‍🏫 هەنگاوی ٣: مامۆستا گوێت لێدەگرێت و هەڵەکانت بۆ ڕاست دەکاتەوە.'),
              SizedBox(height: 6),
              Text('📜 هەنگاوی ٤: وەرگرتنی ئیجازەی زانستی و داگرتنی بڕوانامەی PDF.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLessonsTab(AppState s, SanadItemData sanad, bool isDark) {
    final listened = s.getSanadListened(sanad.key);
    final lessons = [
      'وانەی ٠١: دەروازە و مێژووی زانستی ${sanad.science}',
      'وانەی ٠٢: شیکردنەوەی دەقی ${sanad.book} (بەشی یەکەم)',
      'وانەی ٠٣: شیکردنەوەی دەقی ${sanad.book} (بەشی دووەم)',
      'وانەی ٠٤: ئەحکام و ڕێساکانی تێگەیشتنی دەقەکان',
      'وانەی ٠٥: بەرپەرچدانەوە و پێداچوونەوەی گشتی بەرامبەر مامۆستا',
    ];
    final pct = ((listened.length / lessons.length) * 100).round();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.teal500.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ڕێژەی گوێگرتن لە دەقەکان:',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
              ),
              Text(
                '${toKurdishDigits(pct)}٪ تەواوکراوە (${toKurdishDigits(listened.length)} لە ${toKurdishDigits(lessons.length)})',
                style: const TextStyle(
                  color: AppColors.teal700,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(lessons.length, (i) {
          final id = i + 1;
          final isDone = listened.contains(id);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDone
                    ? AppColors.emerald600
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : const Color(0xFFE5E7EB)),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isDone
                      ? AppColors.emerald600.withValues(alpha: 0.15)
                      : Colors.grey.withValues(alpha: 0.15),
                  child: Text(
                    isDone ? '✓' : toKurdishDigits(id),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDone ? AppColors.emerald600 : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    lessons[i],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    s.toggleSanadLesson(sanad.key, id);
                    if (!isDone) {
                      showReboonToast(
                        context,
                        'وانەکە وەک خوێنراو لە سەنەد پاشەکەوت کرا 🎧',
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        isDone ? AppColors.emerald600 : AppColors.teal700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: Text(isDone ? '🎧 گوێبیسترا' : '▶ گوێگرتن'),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExamTab(SanadItemData sanad, bool isDark) {
    final mm = toKurdishDigits((_recSeconds ~/ 60).toString().padLeft(2, '0'));
    final ss = toKurdishDigits((_recSeconds % 60).toString().padLeft(2, '0'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.blue600.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.blue600.withValues(alpha: 0.25)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🎙️ عەرزی دەنگی لەبەردەم مامۆستادا',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'دەتوانیت تۆماری دەنگی خوێندنەوەکەت بنێریت، یان کاتێک بۆ تاقیکردنەوەی شفوي بە زووم دیاری بکەیت.',
                style: TextStyle(fontSize: 12.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Voice recorder card
        Container(
          padding: const EdgeInsets.all(16),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تۆمارکردنی خەتمی دەنگی:',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                  Text(
                    '$mm:$ss',
                    style: const TextStyle(
                      color: AppColors.rose600,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: _toggleRecording,
                    icon: Icon(
                      _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                    ),
                    label: Text(
                      _isRecording
                          ? '⏹ ڕاگرتنی تۆمارکردن'
                          : (_hasRecorded
                              ? '🔄 دووبارە تۆمارکردنەوە'
                              : '🔴 دەستپێکردنی تۆمارکردن'),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.rose600,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _hasRecorded && !_voiceSubmitted
                        ? () {
                            setState(() => _voiceSubmitted = true);
                            showReboonToast(
                              context,
                              'تۆماری دەنگی سەنەد بە سەرکەوتوویی بۆ مامۆستا نێردرا 🎙️',
                            );
                          }
                        : null,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('📤 ناردن بۆ مامۆستا'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.teal700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _voiceSubmitted
                    ? '📩 تۆماری دەنگی نێردرا! لە پشکنیندایە لەلایەن مامۆستای سەنەدداری ئەکادیمیا.'
                    : (_isRecording
                        ? '🎙️ دەنگەکەت لە تۆمارکردندایە... خوێندنەوەکە بڵێ.'
                        : (_hasRecorded
                            ? '✅ تۆمارکردنی دەنگ تەواوبوو. ئامادەیە بۆ ناردن.'
                            : 'تکایە دەنگەکەت تۆمار بکە بۆ ناردن.')),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Zoom Live Exam Scheduler
        Container(
          padding: const EdgeInsets.all(16),
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
                '📅 دیاریکردنی کاتی تاقیکردنەوەی ڕاستەوخۆ (Zoom Live Exam):',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _scheduledExamDate == null
                          ? 'هیچ کاتێک دیاری نەکراوە'
                          : 'کات: ${toKurdishDigits(_scheduledExamDate!.year)}/${toKurdishDigits(_scheduledExamDate!.month)}/${toKurdishDigits(_scheduledExamDate!.day)} — ${toKurdishDigits(_scheduledExamDate!.hour)}:${toKurdishDigits(_scheduledExamDate!.minute.toString().padLeft(2, '0'))}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _pickExamDateTime,
                    icon: const Icon(Icons.calendar_month_rounded, size: 18),
                    label: const Text('🚀 دیاریکردنی کات'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.teal700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubTabPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SubTabPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: active,
        selectedColor: AppColors.teal700,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: active ? Colors.white : null,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

