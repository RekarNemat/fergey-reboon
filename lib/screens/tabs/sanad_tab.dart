import 'package:flutter/material.dart';
import '../../data/sanad_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/reboon_logo.dart';
import '../modals/sanad_detail_sheet.dart';

class SanadTab extends StatelessWidget {
  final AppState appState;
  final VoidCallback onGoToAccount;

  const SanadTab({
    super.key,
    required this.appState,
    required this.onGoToAccount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1020),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
          children: [
            // Hero Banner matching HTML Section: Sanad
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.teal900.withValues(alpha: 0.55), AppColors.darkCard]
                      : [AppColors.teal50, Colors.white],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.teal500.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.teal500.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Text(
                            'تایبەتمەندی بێهاوتا',
                            style: TextStyle(
                              color: AppColors.teal700,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'سیستەمی سەنەد و ئیجازە (٥ زانستی سەرەکی)',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.teal400 : AppColors.teal900,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'یەکەمین پلاتفۆرمی کوردی کە ڕێگەت پێدەدات ئیجازەی زانستی بە سەنەدی متصل لە ناو ئەپەکەدا وەربگریت. ئەم پرۆسەیە پێویستی بە وردبینی، تێگەیشتنی تەواو و پێشکەشکردنی دەقەکان هەیە.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.teal500.withValues(alpha: 0.2),
                        width: 4,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text('📜', style: TextStyle(fontSize: 34)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5 Sanad Science Cards enhanced per Voice 8 with book visual & teacher portrait
            LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth >= 860
                    ? 3
                    : (constraints.maxWidth >= 540 ? 2 : 1);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 384,
                  ),
                  itemCount: sanadItemsList.length,
                  itemBuilder: (_, idx) {
                    final item = sanadItemsList[idx];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: isDark
                              ? [AppColors.darkCard, AppColors.darkSurface]
                              : [item.color.withValues(alpha: 0.06), Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: item.color.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top: Teacher Avatar + Title + Corner Book Cover (Voice 8)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        TeacherAvatarBubble(
                                          name: item.teacherName,
                                          size: 32,
                                          colorStart: item.color,
                                          colorEnd: Color.lerp(
                                                item.color,
                                                Colors.black,
                                                0.35,
                                              ) ??
                                              item.color,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.teacherName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 11.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.shortTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              StylizedBookCover(
                                title: item.book,
                                subtitle: item.science,
                                color: item.color,
                                width: 58,
                                height: 76,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: item.color,
                              fontWeight: FontWeight.w800,
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.amber500.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.amber500.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.reqTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.amber600,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Expanded(
                                    child: Text(
                                      item.reqText,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () => openSanadDetailSheet(
                                context,
                                appState,
                                item,
                                onOpenAccountTab: onGoToAccount,
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: item.color,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              child: const Text('📜 بینینی سەنەد و پرۆسەی وەرگرتن'),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => openSanadCertificatePreviewSheet(
                                context,
                                appState,
                                item,
                                onOpenAccountTab: onGoToAccount,
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: const Text('📄 داگرتنی ئیجازە (PDF)'),
                            ),
                          ),
                        ],
                      ),
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
}

