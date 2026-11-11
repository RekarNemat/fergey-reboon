import 'package:flutter/material.dart';
import '../../data/courses_data.dart';
import '../../models/academy_models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'quiz_sheet.dart';

void openLessonStudySheet(
  BuildContext context,
  AppState appState,
  String courseKeyOrTitle, {
  required VoidCallback onOpenAccountTab,
}) async {
  final detail = getCourseDetail(courseKeyOrTitle);

  final ok = await ensureAuthenticated(
    context,
    appState,
    actionLabel: detail.title,
    onOpenAccountTab: onOpenAccountTab,
  );
  if (!ok || !context.mounted) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => LessonStudySheet(
      appState: appState,
      course: detail,
    ),
  );
}

void openBookPdfPreviewSheet(BuildContext context, String courseTitleOrKey) {
  final detail = getCourseDetail(courseTitleOrKey);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.78,
        minChildSize: 0.5,
        maxChildSize: 0.94,
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
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.teal700.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppColors.teal700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'کتێبی: ${detail.title}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'مامۆستا: ${detail.instructor} • ${toKurdishDigits(detail.episodesCount)} ئەڵقە',
                          style: Theme.of(ctx).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(18),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.teal50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.teal500.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'کورتەی مەتن و پێڕستی وانەکان',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.teal400 : AppColors.teal800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(detail.summary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...detail.episodes.map(
                    (ep) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${toKurdishDigits(ep.id)}.',
                            style: const TextStyle(
                              color: AppColors.teal600,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ep.title,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                      'فایلی PDFی (${detail.title}) بە سەرکەوتوویی داگیرا 📥',
                    );
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('داگرتنی فایلی PDF بە کوردی و عەرەبی'),
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
      );
    },
  );
}

class LessonStudySheet extends StatefulWidget {
  final AppState appState;
  final CourseDetail course;

  const LessonStudySheet({
    super.key,
    required this.appState,
    required this.course,
  });

  @override
  State<LessonStudySheet> createState() => _LessonStudySheetState();
}

class _LessonStudySheetState extends State<LessonStudySheet> {
  Episode? _playingEpisode;
  bool _isPlayingMedia = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.appState;
    final course = widget.course;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        final doneSet = s.getCompletedEpisodes(course.key);
        final doneCount = doneSet.length;
        final totalCount = course.episodes.length;
        final pct = totalCount == 0 ? 0 : ((doneCount / totalCount) * 100).round();
        final quizUnlocked = doneCount >= 3;

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.88,
          minChildSize: 0.55,
          maxChildSize: 0.96,
          builder: (_, scrollController) {
            return Column(
              children: [
                // Header gradient matching HTML Study Modal
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.teal800, AppColors.teal900],
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.teal600.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              course.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.amber500,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${toKurdishDigits(course.episodesCount)} ئەڵقە',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Spacer(),
                          FavoriteHeartButton(
                            appState: s,
                            favoriteKey: 'course:${course.key}',
                            inactiveColor: Colors.white70,
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'مامۆستای وانە: ${course.instructor}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        course.summary,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                openBookPdfPreviewSheet(context, course.key),
                            icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                            label: const Text('داگرتنی PDFی کتێبەکە'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.teal900,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: quizUnlocked
                                ? () {
                                    Navigator.pop(context);
                                    openQuizSheet(context, s, course.title);
                                  }
                                : null,
                            icon: const Icon(Icons.quiz_rounded, size: 16),
                            label: Text(
                              quizUnlocked
                                  ? '✍️ ئەنجامدانی تاقیکردنەوە (${toKurdishDigits(doneCount)} وانە تەواو بووە ✨)'
                                  : '✍️ تاقیکردنەوە (پێویستی بە ٣ وانەیە - ${toKurdishDigits(doneCount)}/٣)',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.amber500,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  AppColors.amber500.withValues(alpha: 0.45),
                              disabledForegroundColor:
                                  Colors.white.withValues(alpha: 0.85),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Progress bar strip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  color: isDark
                      ? AppColors.darkCard
                      : AppColors.teal50,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${toKurdishDigits(doneCount)} لە ${toKurdishDigits(totalCount)} ئەڵقە خوێنراوە (${toKurdishDigits(pct)}٪)',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const Text(
                            'سیستەمی خوێندنی فێرگەی ڕێبوون',
                            style: TextStyle(
                              color: AppColors.teal600,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: totalCount == 0 ? 0 : doneCount / totalCount,
                          minHeight: 8,
                          backgroundColor: isDark
                              ? AppColors.darkSurface
                              : const Color(0xFFE5E7EB),
                          color: AppColors.teal500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Mini Inline Video/Audio Player when an episode is playing
                if (_playingEpisode != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), AppColors.teal900],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        IconButton.filled(
                          onPressed: () {
                            setState(() => _isPlayingMedia = !_isPlayingMedia);
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.teal500,
                          ),
                          icon: Icon(
                            _isPlayingMedia
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isPlayingMedia
                                    ? '🎧 لە پەخشکردندایە...'
                                    : '⏸ وەستاوە',
                                style: const TextStyle(
                                  color: AppColors.amber400,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _playingEpisode!.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _playingEpisode = null;
                              _isPlayingMedia = false;
                            });
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Episodes List
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: course.episodes.length,
                    itemBuilder: (context, index) {
                      final ep = course.episodes[index];
                      final isDone = doneSet.contains(ep.id);
                      final isCurrent = _playingEpisode?.id == ep.id;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDone
                              ? AppColors.teal500.withValues(alpha: 0.08)
                              : (isDark ? AppColors.darkCard : Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCurrent
                                ? AppColors.amber500
                                : (isDone
                                    ? AppColors.teal500.withValues(alpha: 0.45)
                                    : (isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : const Color(0xFFE5E7EB))),
                            width: isCurrent ? 1.8 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                s.toggleEpisodeDone(course.key, ep.id);
                                showReboonToast(
                                  context,
                                  isDone
                                      ? 'وانەکە نیشانەکەی لابرا'
                                      : 'وانەکە وەک خوێنراو تۆمارکرا! ✓',
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isDone
                                      ? AppColors.teal600
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDone
                                        ? AppColors.teal600
                                        : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                ),
                                child: isDone
                                    ? const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ep.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.5,
                                      decoration: isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: isDone ? Colors.grey : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '⏱️ ${ep.duration} • 🎧 مەتنی دەنگی/ڤیدیۆیی',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.tonalIcon(
                              onPressed: () {
                                setState(() {
                                  _playingEpisode = ep;
                                  _isPlayingMedia = true;
                                });
                                showReboonToast(
                                  context,
                                  'دەستپێکردنی گوێگرتن لە: ${ep.title}',
                                );
                              },
                              icon: const Icon(Icons.play_arrow_rounded, size: 18),
                              label: const Text('گوێگرتن'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

