import 'package:flutter/material.dart';
import '../../data/courses_data.dart';
import '../../models/academy_models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/progress_chart.dart';
import '../../widgets/reboon_logo.dart';
import '../modals/lesson_study_sheet.dart';
import '../modals/quiz_sheet.dart';

class AcademyTab extends StatelessWidget {
  final AppState appState;
  final VoidCallback onGoToAccount;

  const AcademyTab({
    super.key,
    required this.appState,
    required this.onGoToAccount,
  });

  @override
  Widget build(BuildContext context) {
    final s = appState;
    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        final isGeneral = s.academyTrack == 'general';

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1020),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              children: [
                // Header Title matching HTML
                Text(
                  'ئەکادیمیای ڕێبوون',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'هەڵبژاردەی نێوان دوو ڕێڕەوی خوێندن بۆ ئەوەی بەو شێوازەی دەتەوێت قووڵ ببیتەوە لە زانستەکاندا.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                // Track Toggle Buttons matching HTML
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _TrackToggleButton(
                      label: 'مەنهەجی گشتی هاوتەریب',
                      active: isGeneral,
                      onTap: () => s.setAcademyTrack('general'),
                    ),
                    _TrackToggleButton(
                      label: 'مەنهەجی پسپۆڕی (جیاواز)',
                      active: !isGeneral,
                      onTap: () => s.setAcademyTrack('specific'),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                if (isGeneral)
                  _buildGeneralTrack(context, s)
                else
                  _buildSpecializedTrack(context, s),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneralTrack(BuildContext context, AppState s) {
    return Column(
      children: [
        // Track Overview Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.teal800, AppColors.teal900],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.teal600.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  '٥ ئاستی ناچاری / بە قفڵ بەستراوە 🔒',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'مەنهەجی گشتی هاوتەریب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'ئەم ڕێڕەوە بۆ زۆرینەی خەڵکی و فێرخوازانی ئاسایی داڕێژراوە. ئامانجی ئەوەیە هەر ١٢ علومە شەرعییەکە بە شێوازێکی یەکجار تەنسیقکراو و لەناو ٥ ئاستی ناچاری پەیتاپەیتا دا تێکەڵ بکرێن.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: () =>
                    openBookPdfPreviewSheet(context, 'مەنهەجی گشتی هاوتەریب'),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('داگرتنی گشتی مەنهەج بە PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.teal900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 5 Mandatory Levels
        ...generalLevelsData.map((lvl) {
          final unlocked = s.isLevelUnlocked(lvl.levelNumber);
          return _buildGeneralLevelCard(context, s, lvl, unlocked);
        }),

        const SizedBox(height: 8),
        // Progress Chart
        AcademyProgressChart(appState: s),
      ],
    );
  }

  Widget _buildGeneralLevelCard(
    BuildContext context,
    AppState s,
    GeneralLevelData lvl,
    bool unlocked,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Opacity(
      opacity: unlocked ? 1.0 : 0.62,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: unlocked
                ? (lvl.levelNumber == 1
                    ? AppColors.teal500
                    : lvl.badgeColor.withValues(alpha: 0.5))
                : Colors.grey.withValues(alpha: 0.3),
            width: lvl.levelNumber == 1 ? 2 : 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: lvl.badgeColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          lvl.badgeText,
                          style: TextStyle(
                            color: lvl.badgeColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${lvl.title} ${unlocked ? '(ناچاری / 🔓 کراوەیە)' : '(ناچاری / 🔒 بە قفڵ بەستراوە)'}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    if (!unlocked) {
                      showReboonToast(
                        context,
                        'تکایە ئاستی پێش خۆی تەواو بکە ئینجا ئەم بەشەت بۆ کارا دەبێت',
                      );
                      return;
                    }
                    openBookPdfPreviewSheet(context, '${lvl.badgeText}: ${lvl.title}');
                  },
                  icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                  label: const Text('داگرتنی PDFی ئاست'),
                  style: OutlinedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (!unlocked) {
                      showReboonToast(
                        context,
                        'تکایە ئاستی پێش خۆی تەواو بکە ئینجا ئەم بەشەت بۆ کارا دەبێت',
                      );
                      return;
                    }
                    openQuizSheet(
                      context,
                      s,
                      '${lvl.badgeText}: ${lvl.title}',
                      levelNumberToUnlock: lvl.levelNumber,
                    );
                  },
                  icon: const Icon(Icons.quiz_rounded, size: 16),
                  label: const Text('✍️ تاقیکردنەوەی ئاست'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.teal700,
                    textStyle: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Responsive Grid of the 4 Courses in this level (Voice 8: book visual + teacher below!)
            LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth >= 780
                    ? 4
                    : (constraints.maxWidth >= 500 ? 2 : 1);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 256,
                  ),
                  itemCount: lvl.courses.length,
                  itemBuilder: (_, idx) {
                    final c = lvl.courses[idx];
                    return _CourseVisualCard(
                      appState: s,
                      courseKey: c.courseKey,
                      badge: c.scienceBadge,
                      title: c.title,
                      mainBook: c.mainBook,
                      supportBook: c.supportBook,
                      instructorFull: c.instructorFull,
                      color: c.color,
                      unlocked: unlocked,
                      onOpenStudy: () {
                        if (!unlocked) {
                          showReboonToast(
                            context,
                            'تکایە ئاستی پێش خۆی تەواو بکە ئینجا ئەم بەشەت بۆ کارا دەبێت',
                          );
                          return;
                        }
                        openLessonStudySheet(
                          context,
                          s,
                          c.courseKey,
                          onOpenAccountTab: onGoToAccount,
                        );
                      },
                      onOpenPdf: () {
                        if (!unlocked) {
                          showReboonToast(
                            context,
                            'تکایە ئاستی پێش خۆی تەواو بکە ئینجا ئەم بەشەت بۆ کارا دەبێت',
                          );
                          return;
                        }
                        openBookPdfPreviewSheet(context, c.courseKey);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializedTrack(BuildContext context, AppState s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Specialized Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.teal700, AppColors.teal800],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.teal500.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  '٥ زانستی سەرەکی / ٤ قۆناغ لە هەریەکەیاندا',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'مەنهەجی پسپۆڕی (ڕێڕەوی جیاواز)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'ئەم ڕێڕەوە تایبەتە بەو فێرخوازانەی دەیانەوێت بە شێوازێکی یەکجار قووڵ و ئەکادیمی لە زانستە شەرعییەکاندا لێکۆڵینەوە بکەن.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: () =>
                    openBookPdfPreviewSheet(context, 'مەنهەجی پسپۆڕی (ڕێڕەوی جیاواز)'),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('داگرتنی گشتی مەنهەج بە PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.teal900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 5 Sciences x 4 Stages
        ...specializedSciencesData.map((sci) {
          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: sci.color.withValues(alpha: 0.32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: sci.color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(sci.emoji, style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sci.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            sci.subtitle,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () =>
                          openBookPdfPreviewSheet(context, sci.title),
                      icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                      label: const Text('داگرتنی PDFی زانست'),
                      style: OutlinedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => openQuizSheet(context, s, sci.title),
                      icon: const Icon(Icons.quiz_rounded, size: 16),
                      label: const Text('✍️ تاقیکردنەوەی زانست'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.teal700,
                        textStyle: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = constraints.maxWidth >= 780
                        ? 4
                        : (constraints.maxWidth >= 500 ? 2 : 1);
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 256,
                      ),
                      itemCount: sci.stages.length,
                      itemBuilder: (_, idx) {
                        final st = sci.stages[idx];
                        return _CourseVisualCard(
                          appState: s,
                          courseKey: st.courseKey,
                          badge: st.stageLabel,
                          title: st.title,
                          mainBook: st.mainBook,
                          supportBook: st.supportBook,
                          instructorFull: st.instructorFull,
                          color: sci.color,
                          unlocked: true,
                          onOpenStudy: () => openLessonStudySheet(
                            context,
                            s,
                            st.courseKey,
                            onOpenAccountTab: onGoToAccount,
                          ),
                          onOpenPdf: () =>
                              openBookPdfPreviewSheet(context, st.courseKey),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _TrackToggleButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TrackToggleButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.teal700 : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.teal700, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.teal700,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// Course Card enhanced per Voice 8:
/// Includes a corner book cover visual + teacher avatar & name underneath + favorite heart!
class _CourseVisualCard extends StatelessWidget {
  final AppState appState;
  final String courseKey;
  final String badge;
  final String title;
  final String mainBook;
  final String supportBook;
  final String instructorFull;
  final Color color;
  final bool unlocked;
  final VoidCallback onOpenStudy;
  final VoidCallback onOpenPdf;

  const _CourseVisualCard({
    required this.appState,
    required this.courseKey,
    required this.badge,
    required this.title,
    required this.mainBook,
    required this.supportBook,
    required this.instructorFull,
    required this.color,
    required this.unlocked,
    required this.onOpenStudy,
    required this.onOpenPdf,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onOpenStudy,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isDark
                ? [AppColors.darkSurface, AppColors.darkCard]
                : [color.withValues(alpha: 0.08), Colors.white],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: badge + heart + corner book cover visual (Voice 8)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w800,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    StylizedBookCover(
                      title: title,
                      color: color,
                      width: 50,
                      height: 64,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سەرەکی: $mainBook',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'پاڵپشت: $supportBook',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10.5,
                        ),
                  ),
                ],
              ),
            ),
            // Teacher portrait/name underneath + Favorite Heart (Voice 8)
            Row(
              children: [
                TeacherAvatarBubble(
                  name: instructorFull,
                  size: 24,
                  colorStart: color,
                  colorEnd: Color.lerp(color, Colors.black, 0.35) ?? color,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    instructorFull,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FavoriteHeartButton(
                  appState: appState,
                  favoriteKey: 'course:$courseKey',
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onOpenStudy,
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      minimumSize: const Size(0, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: const Text('▶ خوێندن'),
                  ),
                ),
                const SizedBox(width: 6),
                OutlinedButton(
                  onPressed: onOpenPdf,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: const Text('📄 PDF'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

