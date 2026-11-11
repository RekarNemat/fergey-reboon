import 'package:flutter/material.dart';
import '../../data/home_content_data.dart';
import '../../data/library_teachers_data.dart';
import '../../models/academy_models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../modals/lesson_study_sheet.dart';
import '../modals/media_player_sheet.dart';
import '../modals/pdf_library_sheet.dart';

/// Favorites Tab ("وانە دڵخوازەکان") from Voice 2 & Image 2:
/// Users tap the heart icon on any lesson, video, article, guidance or book
/// so they can revisit and study it calmly whenever they have time.
class FavoritesTab extends StatefulWidget {
  final AppState appState;
  final VoidCallback onGoToHome;
  final VoidCallback onGoToAccount;

  const FavoritesTab({
    super.key,
    required this.appState,
    required this.onGoToHome,
    required this.onGoToAccount,
  });

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  String _filter = 'all';

  final _filters = const [
    ('all', 'هەمووی'),
    ('course', 'وانە و پەرتووک'),
    ('video', 'وێبینار و ڤیدیۆ'),
    ('article', 'نووسراو'),
    ('guidance', 'ڕێنمایی'),
    ('pdf', 'کتێبخانەی PDF'),
  ];

  void _openFavoriteItem(FavoriteEntry item) {
    final s = widget.appState;
    if (item.type == 'course') {
      final key = item.key.substring(7);
      openLessonStudySheet(
        context,
        s,
        key,
        onOpenAccountTab: widget.onGoToAccount,
      );
    } else if (item.type == 'video') {
      final id = item.key.substring(6);
      final v = [...reelsContentList, ...webinarsContentList]
          .where((e) => e.id == id)
          .firstOrNull;
      if (v != null) openVideoPlayerSheet(context, s, v);
    } else if (item.type == 'article') {
      final id = item.key.substring(8);
      final a = articlesContentList.where((e) => e.id == id).firstOrNull;
      if (a != null) openArticleReaderSheet(context, s, a);
    } else if (item.type == 'guidance') {
      final id = item.key.substring(9);
      final g = guidanceVideosList.where((e) => e.id == id).firstOrNull;
      if (g != null) openGuidanceVideoSheet(context, s, g);
    } else if (item.type == 'pdf') {
      final id = int.tryParse(item.key.substring(4));
      final b = pdfBooksDatabase.where((e) => e.id == id).firstOrNull;
      if (b != null) openPdfBookDetailSheet(context, s, b);
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'course':
        return Icons.menu_book_rounded;
      case 'video':
        return Icons.play_circle_fill_rounded;
      case 'article':
        return Icons.edit_document;
      case 'guidance':
        return Icons.medical_information_rounded;
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      default:
        return Icons.favorite_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.appState;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        final allFavs = s.resolvedFavorites;
        final filtered = allFavs
            .where((f) => _filter == 'all' || f.type == _filter)
            .toList();

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.rose600.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.rose600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'وانە دڵخوازەکان (${toKurdishDigits(allFavs.length)})',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              'هەر وانە و بابەتێک دڵی لێبدەیت لێرە پاشەکەوت دەبێت بۆ کاتی گونجاو',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    children: _filters.map((f) {
                      final active = _filter == f.$1;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: ChoiceChip(
                          label: Text(f.$2),
                          selected: active,
                          selectedColor: AppColors.teal700,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: active ? Colors.white : null,
                          ),
                          onSelected: (_) => setState(() => _filter = f.$1),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(height: 14),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.favorite_border_rounded,
                                  size: 64,
                                  color: Colors.grey.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'هیچ وانەیەکی دڵخواز لەم بەشەدا نییە',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'دەتوانیت لە فێرگەی ڕێبوون یان ئەکادیمیا دڵ لە هەر وانەیەک بدەیت بۆ بینینی لێرە.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                FilledButton.icon(
                                  onPressed: widget.onGoToHome,
                                  icon: const Icon(Icons.explore_rounded),
                                  label: const Text('گەڕان بەناو وانەکاندا'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.teal700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filtered.length,
                          itemBuilder: (_, idx) {
                            final item = filtered[idx];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: Material(
                                type: MaterialType.transparency,
                                borderRadius: BorderRadius.circular(18),
                                clipBehavior: Clip.antiAlias,
                                child: ListTile(
                                onTap: () => _openFavoriteItem(item),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                leading: Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: item.color.withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    _iconForType(item.type),
                                    color: item.color,
                                  ),
                                ),
                                title: Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
                                    Text(
                                      item.subtitle,
                                      style: TextStyle(
                                        color: item.color,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                    Text(
                                      item.badge,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                trailing: FavoriteHeartButton(
                                  appState: s,
                                  favoriteKey: item.key,
                                ),
                              ),
                              ),
                            );
                          },
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

