import 'package:flutter/material.dart';
import '../../data/quizzes_data.dart';
import '../../models/academy_models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

/// Self-Assessment Hub ("خۆهەڵسەنگاندن") from Voice 3:
/// 500 Q&As across 25 topics ("٢٥ تەوەرە و ٥٠٠ پرسیار و وەڵام").
void openSelfAssessmentSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _SelfAssessmentSheet(),
  );
}

class _SelfAssessmentSheet extends StatefulWidget {
  const _SelfAssessmentSheet();

  @override
  State<_SelfAssessmentSheet> createState() => _SelfAssessmentSheetState();
}

class _SelfAssessmentSheetState extends State<_SelfAssessmentSheet> {
  AssessmentTopicData? _activeTopic;
  int _qIdx = 0;
  int? _picked;
  bool _revealed = false;
  int _correctCount = 0;

  void _startTopic(AssessmentTopicData topic) {
    setState(() {
      _activeTopic = topic;
      _qIdx = 0;
      _picked = null;
      _revealed = false;
      _correctCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.teal700.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.fact_check_rounded,
                      color: AppColors.teal700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'خۆهەڵسەنگاندن (٥٠٠ پرسیار و وەڵام)',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'پێداچوونەوە و هەڵسەنگاندن لە ٢٥ تەوەرەی زانستی شەرعیدا',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (_activeTopic != null)
                    TextButton(
                      onPressed: () => setState(() => _activeTopic = null),
                      child: const Text('تەوەرەکان'),
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
              child: _activeTopic == null
                  ? ListView.builder(
                      controller: controller,
                      padding: const EdgeInsets.all(16),
                      itemCount: selfAssessmentTopicsList.length,
                      itemBuilder: (_, idx) {
                        final t = selfAssessmentTopicsList[idx];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
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
                            onTap: () => _startTopic(t),
                            leading: CircleAvatar(
                              backgroundColor:
                                  AppColors.teal700.withValues(alpha: 0.14),
                              child: Text(
                                toKurdishDigits(t.id),
                                style: const TextStyle(
                                  color: AppColors.teal700,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            title: Text(
                              t.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              '${t.category} • ${toKurdishDigits(t.questionCount)} پرسیار • ئاستی ${t.level}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: const Icon(
                              Icons.play_circle_fill_rounded,
                              color: AppColors.teal600,
                              size: 28,
                            ),
                          ),
                          ),
                        );
                      },
                    )
                  : _buildTopicPractice(controller, isDark),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopicPractice(ScrollController controller, bool isDark) {
    final questions = _activeTopic!.sampleQuestions;
    final q = questions[_qIdx % questions.length];
    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.teal700,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _activeTopic!.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'پرسیاری ${toKurdishDigits(_qIdx + 1)} / ${toKurdishDigits(questions.length)}',
                style: const TextStyle(
                  color: AppColors.amber400,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                q.question,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                ),
              ),
              const SizedBox(height: 14),
              ...List.generate(q.options.length, (i) {
                final isCorrect = i == q.correctIndex;
                final isPicked = _picked == i;
                Color border = isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color(0xFFE5E7EB);
                Color bg = Colors.transparent;
                if (_revealed) {
                  if (isCorrect) {
                    border = AppColors.emerald600;
                    bg = AppColors.emerald600.withValues(alpha: 0.12);
                  } else if (isPicked) {
                    border = AppColors.rose600;
                    bg = AppColors.rose600.withValues(alpha: 0.12);
                  }
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: _revealed
                        ? null
                        : () {
                            setState(() {
                              _picked = i;
                              _revealed = true;
                              if (isCorrect) _correctCount++;
                            });
                          },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border, width: 1.6),
                      ),
                      child: Text(
                        q.options[i],
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                );
              }),
              if (_revealed && q.explanation.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.teal500.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '💡 ڕوونکردنەوە: ${q.explanation}',
                    style: const TextStyle(fontSize: 12.5),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'دروست: ${toKurdishDigits(_correctCount)}',
                      style: const TextStyle(
                        color: AppColors.emerald600,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: _revealed
                        ? () {
                            if (_qIdx + 1 < questions.length) {
                              setState(() {
                                _qIdx++;
                                _picked = null;
                                _revealed = false;
                              });
                            } else {
                              setState(() => _activeTopic = null);
                            }
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.teal700,
                    ),
                    child: Text(
                      _qIdx + 1 < questions.length
                          ? 'پرسیاری دواتر ←'
                          : 'تەواوکردن و گەڕانەوە',
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

