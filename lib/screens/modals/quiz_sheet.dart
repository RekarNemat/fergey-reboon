import 'package:flutter/material.dart';
import '../../data/quizzes_data.dart';
import '../../models/academy_models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

void openQuizSheet(
  BuildContext context,
  AppState appState,
  String subjectTitle, {
  int? levelNumberToUnlock,
}) {
  String key = 'العقيدة';
  if (subjectTitle.contains('فیقهـ') || subjectTitle.contains('الفقه')) {
    key = 'الفقه';
  } else if (subjectTitle.contains('فەرموودە') ||
      subjectTitle.contains('الحديث')) {
    key = 'الحديث';
  } else if (subjectTitle.contains('زمان') || subjectTitle.contains('النحو')) {
    key = 'النحو';
  }

  final questions = levelQuizBank[key] ?? levelQuizBank['العقيدة']!;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _LevelQuizSheet(
      appState: appState,
      subjectTitle: subjectTitle,
      questions: questions,
      levelNumberToUnlock: levelNumberToUnlock,
    ),
  );
}

class _LevelQuizSheet extends StatefulWidget {
  final AppState appState;
  final String subjectTitle;
  final List<QuizQuestion> questions;
  final int? levelNumberToUnlock;

  const _LevelQuizSheet({
    required this.appState,
    required this.subjectTitle,
    required this.questions,
    this.levelNumberToUnlock,
  });

  @override
  State<_LevelQuizSheet> createState() => _LevelQuizSheetState();
}

class _LevelQuizSheetState extends State<_LevelQuizSheet> {
  int _index = 0;
  int _score = 0;
  int? _selectedOption;
  bool _finished = false;

  void _next() {
    if (_selectedOption == null) return;
    if (_selectedOption == widget.questions[_index].correctIndex) {
      _score++;
    }
    if (_index + 1 < widget.questions.length) {
      setState(() {
        _index++;
        _selectedOption = null;
      });
    } else {
      final pct = ((_score / widget.questions.length) * 100).round();
      if (pct >= 70 && widget.levelNumberToUnlock != null) {
        widget.appState.markLevelQuizPassed(widget.levelNumberToUnlock!);
      }
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = widget.questions.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'تاقیکردنەوەی زانستی',
                          style: TextStyle(
                            color: AppColors.teal600,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.subjectTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
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
            const Divider(height: 24),
            if (!_finished) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'پرسیاری ${toKurdishDigits(_index + 1)} لە ${toKurdishDigits(total)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    '⏱️ دیاریکراو',
                    style: TextStyle(
                      color: AppColors.teal600,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (_index + 1) / total,
                  minHeight: 8,
                  color: AppColors.teal500,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.teal50,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.teal500.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  widget.questions[_index].question,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                widget.questions[_index].options.length,
                (i) {
                  final selected = _selectedOption == i;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => setState(() => _selectedOption = i),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.teal500.withValues(alpha: 0.14)
                              : (isDark ? AppColors.darkCard : Colors.white),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? AppColors.teal500
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : const Color(0xFFE5E7EB)),
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: selected
                                  ? AppColors.teal600
                                  : Colors.grey.withValues(alpha: 0.2),
                              child: Text(
                                String.fromCharCode(65 + i),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: selected ? Colors.white : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.questions[_index].options[i],
                                style: TextStyle(
                                  fontWeight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: _selectedOption != null ? _next : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.teal700,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('وەڵامدانەوە و بەردەوامبوون'),
              ),
            ] else ...[
              Builder(
                builder: (_) {
                  final pct = ((_score / total) * 100).round();
                  final passed = pct >= 70;
                  return Column(
                    children: [
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          color: AppColors.teal500.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.teal500, width: 3),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          passed ? '🏆' : '📚',
                          style: const TextStyle(fontSize: 38),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        passed
                            ? 'دەستخۆش! بە سەرکەوتوویی تاقیکردنەوەکەت پەڕاند'
                            : 'هەوڵێکی باش بوو!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        passed && widget.levelNumberToUnlock != null
                            ? 'ئاستی داهاتوو بۆت کرایەوە! 🔓'
                            : 'نمرەکەت تۆمارکرا لە هەژمارەکەت',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.teal500.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${toKurdishDigits(pct)}٪',
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: AppColors.teal600,
                              ),
                            ),
                            Text(
                              '${toKurdishDigits(_score)} وەڵامی دروست لە ${toKurdishDigits(total)} پرسیار',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showReboonToast(
                                  context,
                                  'سەرکەوتنی تاقیکردنەوە تۆمارکرا لە هەژمارەکەت',
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.teal700,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text('پاشەکەوتکردن لە پڕۆفایل'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('داخستن'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

