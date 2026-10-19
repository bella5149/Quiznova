import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_model.dart';
import '../providers/quiz_provider.dart';

class ReviewScreen extends StatelessWidget {
  final QuizResult result;

  const ReviewScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuizProvider>();
    final questions = provider.activeQuestions;
    final answers = provider.userAnswers;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembahasan Jawaban',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth =
                constraints.maxWidth > 700 ? 680.0 : double.infinity;

            return Center(
              child: SizedBox(
                width: maxWidth,
                child: questions.isEmpty
                    ? const Center(
                        child: Text('Data soal tidak tersedia.'),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(18),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF0284C7),
                                  Color(0xFF4F46E5),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.menu_book_rounded,
                                  size: 42,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Yuk, pelajari lagi!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${result.correctCount} benar • ${result.wrongCount} salah',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...List.generate(questions.length, (index) {
                            final question = questions[index];
                            final selectedAnswer = answers[question.id];
                            final correctIndex =
                                question.correctAnswerIndex;
                            final isCorrect =
                                selectedAnswer == correctIndex;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardTheme.color,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF263449)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 11,
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDBEAFE),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'SOAL ${index + 1}',
                                          style: const TextStyle(
                                            color: Color(0xFF0369A1),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        isCorrect
                                            ? Icons.check_circle_rounded
                                            : Icons.cancel_rounded,
                                        color: isCorrect
                                            ? const Color(0xFF10B981)
                                            : const Color(0xFFEF4444),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isCorrect ? 'Benar' : 'Salah',
                                        style: TextStyle(
                                          color: isCorrect
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFFEF4444),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    question.question,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      height: 1.5,
                                    ),
                                  ),
                                  if (question.codeSnippet != null) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0F172A),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          question.codeSnippet!,
                                          style: const TextStyle(
                                            color: Color(0xFFE2E8F0),
                                            fontFamily: 'monospace',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  ...List.generate(
                                    question.options.length,
                                    (optionIndex) {
                                      final isChosen =
                                          selectedAnswer == optionIndex;
                                      final isAnswer =
                                          correctIndex == optionIndex;

                                      Color? background;
                                      Color border;

                                      if (isAnswer) {
                                        background = const Color(0xFF10B981)
                                            .withValues(alpha: 0.09);
                                        border =
                                            const Color(0xFF10B981);
                                      } else if (isChosen) {
                                        background = const Color(0xFFEF4444)
                                            .withValues(alpha: 0.08);
                                        border =
                                            const Color(0xFFEF4444);
                                      } else {
                                        background = isDark
                                            ? const Color(0xFF0F172A)
                                            : Colors.white;
                                        border = isDark
                                            ? const Color(0xFF263449)
                                            : const Color(0xFFE2E8F0);
                                      }

                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 13,
                                          vertical: 13,
                                        ),
                                        decoration: BoxDecoration(
                                          color: background,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(color: border),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                question.options[optionIndex],
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  height: 1.4,
                                                  fontWeight:
                                                      isChosen || isAnswer
                                                          ? FontWeight.w800
                                                          : FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            if (isAnswer)
                                              const Icon(
                                                Icons.check_circle_rounded,
                                                color: Color(0xFF10B981),
                                                size: 19,
                                              )
                                            else if (isChosen)
                                              const Icon(
                                                Icons.cancel_rounded,
                                                color: Color(0xFFEF4444),
                                                size: 19,
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7C3AED)
                                          .withValues(alpha: 0.08),
                                      borderRadius:
                                          BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.lightbulb_rounded,
                                              color: Color(0xFF8B5CF6),
                                              size: 19,
                                            ),
                                            SizedBox(width: 7),
                                            Text(
                                              'Pembahasan',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          question.explanation,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : const Color(0xFF475569),
                                            fontSize: 13,
                                            height: 1.55,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                          FilledButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Kembali ke Hasil'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
