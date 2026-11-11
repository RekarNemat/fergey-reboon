import 'package:flutter/material.dart';
import '../../data/library_teachers_data.dart';
import '../../models/academy_models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/reboon_logo.dart';

void openPdfLibrarySheet(
  BuildContext context,
  AppState appState, {
  String initialCategory = 'all',
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => PdfLibrarySheet(
      appState: appState,
      initialCategory: initialCategory,
    ),
  );
}

void openPdfBookDetailSheet(
  BuildContext context,
  AppState appState,
  PdfBookData book,
) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StylizedBookCover(
                title: book.title,
                subtitle: book.author,
                color: book.coverColor,
                width: 96,
                height: 132,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.teal500.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${toKurdishDigits(book.pages)} لاپەڕە • ${book.size}',
                            style: const TextStyle(
                              color: AppColors.teal700,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const Spacer(),
                        FavoriteHeartButton(
                          appState: appState,
                          favoriteKey: 'pdf:${book.id}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.title,
                      style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: const TextStyle(
                        color: AppColors.teal600,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.desc,
                      style: Theme.of(ctx).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    showReboonToast(context, 'کتێبی (${book.title}) دەکرێتەوە... 📖');
                  },
                  icon: const Icon(Icons.menu_book_rounded),
                  label: const Text('خوێندنەوە لە ناو ئەپ'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    showReboonToast(context, 'فایلی PDFی (${book.title}) داگیرا 📥');
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('داگرتنی PDF'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.teal700,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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

class PdfLibrarySheet extends StatefulWidget {
  final AppState appState;
  final String initialCategory;

  const PdfLibrarySheet({
    super.key,
    required this.appState,
    this.initialCategory = 'all',
  });

  @override
  State<PdfLibrarySheet> createState() => _PdfLibrarySheetState();
}

class _PdfLibrarySheetState extends State<PdfLibrarySheet> {
  late String _category;
  String _search = '';

  final _categories = const [
    ('all', 'هەمووی'),
    ('aqeedah', 'عەقیدە'),
    ('fiqh', 'فیقهـ'),
    ('hadith', 'فەرموودە'),
    ('tafseer', 'تەفسیر'),
    ('nahw', 'زمانی عەرەبی'),
    ('seerah', 'سیرە'),
  ];

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = pdfBooksDatabase.where((b) {
      final matchesCat = _category == 'all' || b.category == _category;
      final q = _search.trim().toLowerCase();
      final matchesSearch = q.isEmpty ||
          b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q);
      return matchesCat && matchesSearch;
    }).toList();

    return AnimatedBuilder(
      animation: widget.appState,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '📚 کتێبخانەی PDFی زانستە شەرعییەکان',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              'کۆگای دەوڵەمەندی سەرچاوە ڕەسەنەکان بە داگرتنی خێرا',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: const InputDecoration(
                      hintText: 'گەڕان لە ناوی کتێب یان نووسەر...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    children: _categories.map((cat) {
                      final active = _category == cat.$1;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: ChoiceChip(
                          label: Text(cat.$2),
                          selected: active,
                          selectedColor: AppColors.teal700,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: active ? Colors.white : null,
                          ),
                          onSelected: (_) => setState(() => _category = cat.$1),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(height: 14),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text('هیچ کتێبێک نەدۆزرایەوە بەم گەڕانە.'),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final cols = constraints.maxWidth >= 680 ? 2 : 1;
                            return GridView.builder(
                              controller: controller,
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 176,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (_, idx) {
                                final b = filtered[idx];
                                return InkWell(
                                  onTap: () => openPdfBookDetailSheet(
                                    context,
                                    widget.appState,
                                    b,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkCard
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white.withValues(alpha: 0.08)
                                            : const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        StylizedBookCover(
                                          title: b.title,
                                          subtitle: b.author,
                                          color: b.coverColor,
                                          width: 88,
                                          height: 140,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.teal500
                                                          .withValues(alpha: 0.14),
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                    ),
                                                    child: Text(
                                                      '${toKurdishDigits(b.pages)} لاپەڕە • ${b.size}',
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w800,
                                                        color: AppColors.teal700,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  FavoriteHeartButton(
                                                    appState: widget.appState,
                                                    favoriteKey: 'pdf:${b.id}',
                                                    size: 17,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                b.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 13.5,
                                                ),
                                              ),
                                              Text(
                                                b.author,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: AppColors.teal600,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Expanded(
                                                child: Text(
                                                  b.desc,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          openPdfBookDetailSheet(
                                                        context,
                                                        widget.appState,
                                                        b,
                                                      ),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 4,
                                                        ),
                                                        textStyle:
                                                            const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      child: const Text('📖 خوێندن'),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: FilledButton(
                                                      onPressed: () =>
                                                          showReboonToast(
                                                        context,
                                                        'فایلی PDF داگیرا 📥',
                                                      ),
                                                      style: FilledButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppColors.teal700,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 4,
                                                        ),
                                                        textStyle:
                                                            const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      child: const Text('📥 PDF'),
                                                    ),
                                                  ),
                                                ],
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

