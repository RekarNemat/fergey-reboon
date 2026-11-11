import 'package:flutter/material.dart';
import '../../data/courses_data.dart';
import '../../data/home_content_data.dart';
import '../../data/library_teachers_data.dart';
import '../../models/academy_models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/reboon_logo.dart';
import '../modals/independent_quiz_sheet.dart';
import '../modals/lesson_study_sheet.dart';
import '../modals/live_stream_sheet.dart';
import '../modals/media_player_sheet.dart';
import '../modals/pdf_library_sheet.dart';
import '../modals/resources_sheet.dart';
import '../modals/self_assessment_sheet.dart';
import '../modals/teachers_sheet.dart';

class HomeTab extends StatefulWidget {
  final AppState appState;
  final VoidCallback onGoToAcademy;
  final VoidCallback onGoToSanad;
  final VoidCallback onGoToAccount;

  const HomeTab({
    super.key,
    required this.appState,
    required this.onGoToAcademy,
    required this.onGoToSanad,
    required this.onGoToAccount,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final PageController _bannerCtrl = PageController(viewportFraction: 1.0);
  int _bannerPage = 0;
  int _dailyIndex = 0;
  bool _showReelsInWebinarTab = false;

  @override
  void dispose() {
    _bannerCtrl.dispose();
    super.dispose();
  }

  void _openScienceHub(ScienceCategoryItem science) {
    final relatedCourses = courseCatalog.values
        .where((c) =>
            c.category.contains(science.kurdishName) ||
            c.category.contains(science.arabicName) ||
            c.title.contains(science.arabicName))
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: science.color,
                  child: Icon(science.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${science.arabicName} • ${science.kurdishName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      const Text(
                        'وانە و سەرچاوە و تاقیکردنەوەکانی ئەم زانستە',
                        style: TextStyle(fontSize: 12),
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
            const Divider(height: 22),
            if (relatedCourses.isNotEmpty) ...[
              const Text(
                '📖 وانە و پەرتووکە تۆمارکراوەکان:',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
              const SizedBox(height: 8),
              ...relatedCourses.take(4).map(
                    (c) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.play_circle_fill_rounded,
                          color: AppColors.teal700),
                      title: Text(c.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13.5)),
                      subtitle: Text(
                          '${c.instructor} • ${toKurdishDigits(c.episodesCount)} ئەڵقە'),
                      onTap: () {
                        Navigator.pop(ctx);
                        openLessonStudySheet(
                          context,
                          widget.appState,
                          c.key,
                          onOpenAccountTab: widget.onGoToAccount,
                        );
                      },
                    ),
                  ),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      openPdfLibrarySheet(
                        context,
                        widget.appState,
                        initialCategory:
                            ['aqeedah', 'fiqh', 'hadith', 'tafseer', 'nahw', 'seerah']
                                    .contains(science.id)
                                ? science.id
                                : 'all',
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                    label: const Text('کتێبە PDFەکان'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      openIndependentQuizSheet(
                        context,
                        initialScienceId: science.id,
                      );
                    },
                    icon: const Icon(Icons.quiz_rounded, size: 18),
                    label: const Text('تاقیکردنەوەی زانست'),
                    style: FilledButton.styleFrom(
                      backgroundColor: science.color,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.appState;
    final daily = dailyLearningEntries[_dailyIndex];

    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: ListView(
              padding: const EdgeInsets.only(top: 12, bottom: 28),
              children: [
                // 1. HERO BANNER CAROUSEL (Voice 6 + Image 6 + HTML Hero)
                _buildHeroCarousel(),
                const SizedBox(height: 14),

                // 2. فێربوونی ڕۆژانە (Voice 6 + Image 6 — below Hero!)
                _buildDailyLearningCard(daily),
                const SizedBox(height: 22),

                // 3. زانستەکان (Image 6 circular teal badges horizontally)
                const SectionTitleHeader(title: 'زانستەکان'),
                const SizedBox(height: 12),
                _buildSciencesStrip(),
                const SizedBox(height: 24),

                // 4. ڕاڤەی پەرتووکی شەرعی (Image 6 + Voice 6 + HTML Courses)
                SectionTitleHeader(
                  title: 'ڕاڤەی پەرتووکی شەرعی',
                  actionLabel: 'ئەکادیمیا',
                  onActionTap: widget.onGoToAcademy,
                ),
                const SizedBox(height: 12),
                _buildRecordedBooksCarousel(s),
                const SizedBox(height: 24),

                // 5. وێبینار & کورتە ڤیدیۆ (Image 6 + Voice 6 + HTML Webinars/Reels)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'وێبینار',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : AppColors.teal900,
                              ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Spacer(),
                      ChoiceChip(
                        label: const Text('وێبینار'),
                        visualDensity: VisualDensity.compact,
                        selected: !_showReelsInWebinarTab,
                        selectedColor: AppColors.teal700,
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: !_showReelsInWebinarTab ? Colors.white : null,
                        ),
                        onSelected: (_) =>
                            setState(() => _showReelsInWebinarTab = false),
                      ),
                      const SizedBox(width: 4),
                      ChoiceChip(
                        label: const Text('کورتە ڤیدیۆ'),
                        visualDensity: VisualDensity.compact,
                        selected: _showReelsInWebinarTab,
                        selectedColor: AppColors.teal700,
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _showReelsInWebinarTab ? Colors.white : null,
                        ),
                        onSelected: (_) =>
                            setState(() => _showReelsInWebinarTab = true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildWebinarsOrReelsCarousel(s),
                const SizedBox(height: 24),

                // 6. کتێبخانە (Image 6 + HTML 29-book PDF library)
                SectionTitleHeader(
                  title: 'کتێبخانە',
                  actionLabel: 'بینینی هەمووی',
                  onActionTap: () => openPdfLibrarySheet(context, s),
                ),
                const SizedBox(height: 12),
                _buildLibraryPreviewStrip(s),
                const SizedBox(height: 24),

                // 7. ڕێنمایی (Voice 7 + Image 6 — health, spine, plan, mental wellness)
                const SectionTitleHeader(title: 'ڕێنمایی'),
                const SizedBox(height: 12),
                _buildGuidanceCarousel(s),
                const SizedBox(height: 26),

                // 8. خزمەتگوزارییە گشتییەکان (Voice 3 & 8 + Image 6 — Moved down from Header!)
                const SectionTitleHeader(title: 'بەشەکان و هەڵسەنگاندن'),
                const SizedBox(height: 12),
                _buildBottomActionStrip(s),
                const SizedBox(height: 26),

                // 9. پڕۆژەکانی دیکەی ڕێبوون (HTML Projects showcase)
                const SectionTitleHeader(title: 'پڕۆژەکانی دیکەی ڕێبوون'),
                const SizedBox(height: 12),
                _buildProjectsStrip(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroCarousel() {
    final screenW = MediaQuery.of(context).size.width;
    final bannerHeight = screenW >= 640 ? 235.0 : 210.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          SizedBox(
            height: bannerHeight,
            child: PageView(
              controller: _bannerCtrl,
              onPageChanged: (p) => setState(() => _bannerPage = p),
              children: [
                // Slide 1: Photorealistic library hero matching Image 6
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/hero_library.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.teal800, AppColors.teal900],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.72),
                              Colors.black.withValues(alpha: 0.15),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gold,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Text(
                                '✨ پلاتفۆرمی فەرمیی فێرگەی ڕێبوون',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.teal900,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'بەخێربێن بۆ فێرگەی ڕێبوون',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 19,
                              ),
                            ),
                            const Text(
                              'فێربوونی زانستە شەرعییەکان بە سەنەدی گەیەنراو و مێتۆدی هاوچەرخ',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Slide 2: HTML Welcome Banner (Voice 6 explicitly suggested adding the HTML definition as a banner slide!)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.teal800,
                        AppColors.teal700,
                        AppColors.teal900,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'دەروازەی زانستە شەرعییەکان',
                        style: TextStyle(
                          color: AppColors.amber400,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'فێرگەی ڕێبوون بۆ زانستی سەنەددار',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'دوور لە دەمارگیری و پشتبەستوو بە بەڵگە صەحیحەکان بە سەنەدی گەیەنراو تا پێغەمبەری خوا ﷺ.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          ElevatedButton(
                            onPressed: widget.onGoToAcademy,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.teal900,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            child: const Text('🚀 دەستپێکردنی خوێندن'),
                          ),
                          OutlinedButton(
                            onPressed: widget.onGoToSanad,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white54),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            child: const Text('📜 سەنەدەکان'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Slide 3: Seerah App spotlight
                InkWell(
                  onTap: () =>
                      openProjectDetailSheet(context, reboonProjectsList.first),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF134E4A), Color(0xFFB45309)],
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '⭐ پڕۆژەی پێشنیازکراوی ڕێبوون',
                          style: TextStyle(
                            color: AppColors.amber400,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'ئەپی سیرەی پێغەمبەر (صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'پلاتفۆرمێکی گشتگیر بۆ ناسینی ژیاننامەی پێغەمبەری خوا ﷺ بە نەخشەی کارلێککار و سەنەدی دروست.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _bannerPage == i ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: _bannerPage == i
                      ? AppColors.teal700
                      : Colors.grey.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyLearningCard(DailyLearningEntry daily) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.teal800,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal900.withValues(alpha: 0.2),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _dailyIndex = (_dailyIndex + 1) % dailyLearningEntries.length;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  daily.title,
                  style: const TextStyle(
                    color: AppColors.amber400,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.autorenew_rounded,
                  color: AppColors.amber400,
                  size: 15,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              daily.arabicQuote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${daily.kurdishExplanation} — ${daily.source}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSciencesStrip() {
    return SizedBox(
      height: 102,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: homeSciencesList.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, idx) {
          final item = homeSciencesList[idx];
          return InkWell(
            onTap: () => _openScienceHub(item),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 74,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.teal800,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal900.withValues(alpha: 0.16),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: AppColors.amber400,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.arabicName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecordedBooksCarousel(AppState s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 224,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: featuredRecordedBooks.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, idx) {
          final book = featuredRecordedBooks[idx];
          return InkWell(
            onTap: () => openLessonStudySheet(
              context,
              s,
              book.key,
              onOpenAccountTab: widget.onGoToAccount,
            ),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 158,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.65),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Top visual area: stylized book cover + teacher badge + heart
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            book.accentColor.withValues(alpha: 0.16),
                            isDark ? AppColors.darkSurface : AppColors.teal50,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: StylizedBookCover(
                              title: book.title,
                              subtitle:
                                  '${toKurdishDigits(book.episodesCount)} ئەڵقە',
                              color: book.accentColor,
                              width: 86,
                              height: 118,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: TeacherAvatarBubble(
                              name: book.instructor,
                              size: 32,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: FavoriteHeartButton(
                              appState: s,
                              favoriteKey: 'course:${book.key}',
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Golden-amber bottom bar matching Image 6
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          book.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.teal900,
                            fontWeight: FontWeight.w900,
                            fontSize: 12.5,
                          ),
                        ),
                        Text(
                          book.instructor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.teal900.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
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
      ),
    );
  }

  Widget _buildWebinarsOrReelsCarousel(AppState s) {
    final items =
        _showReelsInWebinarTab ? reelsContentList : webinarsContentList;
    return SizedBox(
      height: _showReelsInWebinarTab ? 236 : 206,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, idx) {
          final v = items[idx];
          return InkWell(
            onTap: () => openVideoPlayerSheet(context, s, v, playlist: items),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: _showReelsInWebinarTab ? 148 : 178,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.65),
                  width: 1.4,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [v.colorStart, v.colorEnd],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: TeacherAvatarBubble(
                              name: v.speaker,
                              size: 32,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: FavoriteHeartButton(
                              appState: s,
                              favoriteKey: 'video:${v.id}',
                              inactiveColor: Colors.white70,
                              size: 16,
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white54),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                v.duration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          v.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.teal900,
                            fontWeight: FontWeight.w900,
                            fontSize: 11.5,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          v.speaker,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.teal900.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
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
      ),
    );
  }

  Widget _buildLibraryPreviewStrip(AppState s) {
    final previewBooks = [
      pdfBooksDatabase[27], // اختصار علوم الحديث
      pdfBooksDatabase[28], // إرواء الغليل
      pdfBooksDatabase[16], // تفسير القرآن العظيم
      pdfBooksDatabase[0], // الأصول الثلاثة
      pdfBooksDatabase[10], // الأربعين النووية
      pdfBooksDatabase[23], // الرحيق المختوم
    ];

    return SizedBox(
      height: 162,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: previewBooks.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, idx) {
          final b = previewBooks[idx];
          return InkWell(
            onTap: () => openPdfBookDetailSheet(context, s, b),
            borderRadius: BorderRadius.circular(14),
            child: StylizedBookCover(
              title: b.title,
              subtitle: b.author,
              color: b.coverColor,
              width: 114,
              height: 158,
              badge: '${toKurdishDigits(b.pages)} ل',
            ),
          );
        },
      ),
    );
  }

  Widget _buildGuidanceCarousel(AppState s) {
    return SizedBox(
      height: 164,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: guidanceVideosList.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, idx) {
          final g = guidanceVideosList[idx];
          return InkWell(
            onTap: () => openGuidanceVideoSheet(context, s, g),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 248,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    g.color,
                    Color.lerp(g.color, Colors.black, 0.45) ?? g.color,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: g.color.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(g.icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          g.duration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      FavoriteHeartButton(
                        appState: s,
                        favoriteKey: 'guidance:${g.id}',
                        inactiveColor: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        g.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        g.specialist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.amber400,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Bottom Action Grid matching Image 6 + Voice 3 & 8
  Widget _buildBottomActionStrip(AppState s) {
    final actions = [
      (
        'بابەتی نووسراو',
        Icons.edit_document,
        () => openArticlesListSheet(context, s),
      ),
      (
        'خۆهەڵسەنگاندن',
        Icons.fact_check_rounded,
        () => openSelfAssessmentSheet(context),
      ),
      (
        'تاقیکردنەوەی سەربەخۆ',
        Icons.assignment_turned_in_rounded,
        () => openIndependentQuizSheet(context),
      ),
      (
        'پەخشی ڕاستەوخۆ',
        Icons.live_tv_rounded,
        () => openLiveStreamSheet(
              context,
              s,
              onOpenAccountTab: widget.onGoToAccount,
            ),
      ),
      (
        'مامۆستایانی فێرگە',
        Icons.school_rounded,
        () => openAcademyTeachersSheet(context, s),
      ),
      (
        'سەرچاوە بەسوودەکان',
        Icons.library_books_rounded,
        () => openUsefulResourcesSheet(context),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 700 ? 6 : 3;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: cols == 6 ? 1.05 : 1.08,
            ),
            itemCount: actions.length,
            itemBuilder: (_, idx) {
              final item = actions[idx];
              return InkWell(
                onTap: item.$3,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.teal800,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal900.withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.$2, color: AppColors.gold, size: 30),
                      const SizedBox(height: 8),
                      Text(
                        item.$1,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProjectsStrip() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 158,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: reboonProjectsList.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, idx) {
          final p = reboonProjectsList[idx];
          return InkWell(
            onTap: () => openProjectDetailSheet(context, p),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 246,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: p.isFeatured
                    ? const LinearGradient(
                        colors: [AppColors.teal700, AppColors.teal800],
                      )
                    : null,
                color: p.isFeatured
                    ? null
                    : (isDark ? AppColors.darkCard : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: p.isFeatured
                      ? AppColors.teal400.withValues(alpha: 0.5)
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : const Color(0xFFE5E7EB)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p.icon, style: const TextStyle(fontSize: 22)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: p.isFeatured
                              ? AppColors.amber400
                              : p.accentColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          p.badge,
                          style: TextStyle(
                            color: p.isFeatured
                                ? AppColors.teal900
                                : p.accentColor,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: p.isFeatured ? Colors.white : null,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        p.desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: p.isFeatured
                              ? Colors.white.withValues(alpha: 0.85)
                              : Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'زانیاری زیاتر ←',
                    style: TextStyle(
                      color: p.isFeatured ? AppColors.amber400 : p.accentColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

