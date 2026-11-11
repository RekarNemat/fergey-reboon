import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/quizzes_data.dart';
import '../../models/academy_models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

void openIndependentQuizSheet(BuildContext context, {String? initialScienceId}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => IndependentQuizSheet(initialScienceId: initialScienceId),
  );
}

class IndependentQuizSheet extends StatefulWidget {
  final String? initialScienceId;

  const IndependentQuizSheet({super.key, this.initialScienceId});

  @override
  State<IndependentQuizSheet> createState() => _IndependentQuizSheetState();
}

class _IndependentQuizSheetState extends State<IndependentQuizSheet> {
  IndependentScienceMeta? _selectedScience;
  List<QuizQuestion> _questions = [];
  int _qIndex = 0;
  int _score = 0;
  int _timeLeft = 60;
  Timer? _timer;
  int? _chosenOption;
  bool _answered = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialScienceId != null) {
      final match = independentSciencesList
          .where((s) => s.id == widget.initialScienceId)
          .firstOrNull;
      if (match != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startQuiz(match);
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startQuiz(IndependentScienceMeta science) {
    _timer?.cancel();
    setState(() {
      _selectedScience = science;
      _questions = independentQuizBank[science.id] ?? independentQuizBank['aqeedah']!;
      _qIndex = 0;
      _score = 0;
      _finished = false;
      _answered = false;
      _chosenOption = null;
      _timeLeft = 60;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_timeLeft <= 1) {
        t.cancel();
        setState(() {
          _timeLeft = 0;
          _answered = true;
        });
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _chooseOption(int optIdx) {
    if (_answered) return;
    _timer?.cancel();
    final q = _questions[_qIndex];
    setState(() {
      _chosenOption = optIdx;
      _answered = true;
      if (optIdx == q.correctIndex) {
        _score += 5;
      }
    });
  }

  void _nextQuestion() {
    if (_qIndex + 1 >= _questions.length) {
      _timer?.cancel();
      setState(() => _finished = true);
    } else {
      setState(() {
        _qIndex++;
        _chosenOption = null;
        _answered = false;
        _timeLeft = 60;
      });
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.96,
      builder: (_, scrollController) {
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.amber500.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '✍️ تاقیکردنەوەی سەربەخۆ',
                                style: TextStyle(
                                  color: AppColors.amber600,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.teal500.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '١٢ زانستە شەرعییەکە',
                                style: TextStyle(
                                  color: AppColors.teal600,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'ئاستی زانستی خۆت تاقیبکەرەوە',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        Text(
                          '٢٠ پرسیاری هەڵبژاردن بۆ هەر زانستێک • نمرە لە ١٠٠',
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
            const Divider(height: 1),
            Expanded(
              child: _selectedScience == null
                  ? _buildScienceSelector(scrollController, isDark)
                  : _finished
                      ? _buildResults(scrollController, isDark)
                      : _buildQuestionView(scrollController, isDark),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScienceSelector(ScrollController controller, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 640
            ? 3
            : (constraints.maxWidth >= 380 ? 2 : 1);
        return GridView.builder(
          controller: controller,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: cols == 1 ? 2.5 : 1.18,
          ),
          itemCount: independentSciencesList.length,
          itemBuilder: (context, idx) {
            final s = independentSciencesList[idx];
            return InkWell(
              onTap: () => _startQuiz(s),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(14),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [s.colorStart, s.colorEnd],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(s.icon, style: const TextStyle(fontSize: 20)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.amber500.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            '٢٠ پرسیار',
                            style: TextStyle(
                              color: AppColors.amber600,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          s.desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Text(
                      'دەستپێکردن ←',
                      style: TextStyle(
                        color: AppColors.amber600,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuestionView(ScrollController controller, bool isDark) {
    final q = _questions[_qIndex];
    final letters = ['أ', 'ب', 'ج'];
    final timeStr =
        '٠٠:${toKurdishDigits(_timeLeft.toString().padLeft(2, '0'))}';

    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(16),
      children: [
        // Top status bar
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.teal500.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.teal500.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selectedScience!.icon} ${_selectedScience!.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.teal700,
                        fontSize: 13.5,
                      ),
                    ),
                    Text(
                      'پرسیاری ${toKurdishDigits(_qIndex + 1)} لە ${toKurdishDigits(_questions.length)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _timeLeft <= 10
                        ? AppColors.rose600
                        : AppColors.amber500,
                  ),
                ),
                child: Text(
                  '⏱️ $timeStr',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: _timeLeft <= 10 ? AppColors.rose600 : AppColors.amber600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.teal700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'نمرە: ${toKurdishDigits(_score)}/١٠٠',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (_qIndex + 1) / _questions.length,
            minHeight: 7,
            color: AppColors.teal500,
          ),
        ),
        const SizedBox(height: 16),

        // Question card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(22),
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
                '${toKurdishDigits(_qIndex + 1)}. ${q.question}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 16),
              ...List.generate(q.options.length, (i) {
                final isCorrectOpt = i == q.correctIndex;
                final isChosen = _chosenOption == i;

                Color borderColor = isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color(0xFFE5E7EB);
                Color bgColor = isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB);
                String? suffix;

                if (_answered) {
                  if (isCorrectOpt) {
                    borderColor = AppColors.emerald600;
                    bgColor = AppColors.emerald600.withValues(alpha: 0.12);
                    suffix = '✓ ڕاست';
                  } else if (isChosen) {
                    borderColor = AppColors.rose600;
                    bgColor = AppColors.rose600.withValues(alpha: 0.12);
                    suffix = '✗ هەڵە';
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: _answered ? null : () => _chooseOption(i),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 1.8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.12)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              letters[i % letters.length],
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              q.options[i],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          if (suffix != null)
                            Text(
                              suffix,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: isCorrectOpt
                                    ? AppColors.emerald600
                                    : AppColors.rose600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              if (_answered) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _timeLeft == 0 && _chosenOption == null
                        ? AppColors.amber500.withValues(alpha: 0.14)
                        : (_chosenOption == q.correctIndex
                            ? AppColors.emerald600.withValues(alpha: 0.12)
                            : AppColors.rose600.withValues(alpha: 0.12)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _timeLeft == 0 && _chosenOption == null
                            ? '⏳ کاتی ئەم پرسیارە بەسەرچوو!'
                            : (_chosenOption == q.correctIndex
                                ? '✨ وەڵامەکە ڕاستە! (+٥ نمرە)'
                                : '❌ وەڵامەکەت هەڵەیە! وەڵامی ڕاست: ${q.options[q.correctIndex]}'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      if (q.explanation.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          q.explanation,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              FilledButton(
                onPressed: _answered ? _nextQuestion : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.teal700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _qIndex + 1 >= _questions.length
                      ? 'بینینی ئەنجامی کۆتایی 🏆'
                      : 'پرسیاری دواتر ←',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults(ScrollController controller, bool isDark) {
    final correctCount = _score ~/ 5;
    String badge = '⚠️ دەرنەچوو';
    String eval =
        'نمرەکەت خوار ٥٠یە. دەتوانیت سەرلەنوێ دەست بە خوێندنی وانەکان بکەیتەوە لە ئەکادیمیای ڕێبوون.';

    if (_score >= 90) {
      badge = '🌟 زۆر نایاب';
      eval =
          'پیرۆزە! ئاستێکی زانستی یەکجار بەرز و قووڵت هەیە لەم زانستە شەرعییەدا. شایەنی دەستخۆشییەکی گەورەیت!';
    } else if (_score >= 75) {
      badge = '💎 زۆر باش';
      eval =
          'ئاستێکی زۆر باشت تۆمارکرد! زانیارییەکانت زۆر باش و بەهێزن. بەردەوام بە لە بەدواداچوون.';
    } else if (_score >= 60) {
      badge = '👍 باش';
      eval =
          'ئاستێکی باشت هەیە و دەرچوویت. سەردانی وانەکانی ئەکادیمیا بکە بۆ قووڵبوونەوەی زیاتر.';
    } else if (_score >= 50) {
      badge = '📄 مامناوەند';
      eval =
          'نمرەی دەرچوونت بەدەستهێنا. پێشنیاری دیراسەکردنی مەنهەجی سەرەتایی دەکەین.';
    }

    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.amber400, AppColors.amber600],
              ),
            ),
            alignment: Alignment.center,
            child: const Text('🏆', style: TextStyle(fontSize: 44)),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.amber500.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: AppColors.amber600,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'ئەنجامی تاقیکردنەوەی سەربەخۆ',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_selectedScience!.icon} ${_selectedScience!.name}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.teal600,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.teal500.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.teal500.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              const Text(
                'نمرەی کۆتایی لە ١٠٠',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                '${toKurdishDigits(_score)} / ١٠٠',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.teal700,
                ),
              ),
              const Divider(height: 18),
              Text(
                'تۆ بە شێوازی ڕاست وەڵامی ${toKurdishDigits(correctCount)} پرسیارت دایەوە لە کۆی ${toKurdishDigits(_questions.length)} پرسیار.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            eval,
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.7),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => _startQuiz(_selectedScience!),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.teal700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('🔄 دووبارەکردنەوە'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  _timer?.cancel();
                  setState(() {
                    _selectedScience = null;
                    _finished = false;
                  });
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.amber600,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('📚 زانستێکی تر'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

