import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/library_teachers_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

void openUsefulResourcesSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _UsefulResourcesSheet(),
  );
}

class _UsefulResourcesSheet extends StatefulWidget {
  const _UsefulResourcesSheet();

  @override
  State<_UsefulResourcesSheet> createState() => _UsefulResourcesSheetState();
}

class _UsefulResourcesSheetState extends State<_UsefulResourcesSheet> {
  String _cat = 'all';

  final _cats = const [
    ('all', 'هەموو سەرچاوەکان'),
    ('libraries', 'مەکتەبە دیجیتاڵییەکان'),
    ('hadith', 'فەرموودە'),
    ('quran', 'قورئان & تەفسیر'),
    ('tools', 'فەرهەنگەکان'),
    ('academy', 'ئەکادیمیا جیهانییەکان'),
  ];

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      showReboonToast(context, 'کردنەوەی بەستەر: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = usefulResourcesDatabase
        .where((r) => _cat == 'all' || r.category == _cat)
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.5,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🌐 سەرچاوە بەسوودەکان و ماڵپەڕە ئیسلامییەکان',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'پێڕستی هەڵبژێردراوی باوەڕپێکراوترین ماڵپەڕە ئیسلامییەکانی جیهان',
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
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: _cats.map((c) {
                final active = _cat == c.$1;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: ChoiceChip(
                    label: Text(c.$2),
                    selected: active,
                    selectedColor: AppColors.emerald600,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: active ? Colors.white : null,
                    ),
                    onSelected: (_) => setState(() => _cat = c.$1),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 14),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth >= 680 ? 2 : 1;
                return GridView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 196,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, idx) {
                    final r = filtered[idx];
                    return Container(
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
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.emerald600
                                      .withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                alignment: Alignment.center,
                                child: Text(r.icon,
                                    style: const TextStyle(fontSize: 18)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    Text(
                                      r.url.replaceFirst('https://', ''),
                                      style: const TextStyle(
                                        fontFamily: 'NotoSans',
                                        color: AppColors.emerald600,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                  color: AppColors.emerald600
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  r.badge,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.emerald600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              r.desc,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => _openUrl(r.url),
                              icon: const Icon(Icons.open_in_new_rounded, size: 16),
                              label: const Text('🔗 سەردانکردنی ماڵپەڕ'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.emerald600,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

