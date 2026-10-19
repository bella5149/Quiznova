import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/option_card.dart';
import '../widgets/quiz_progress_bar.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _showSubmitDialog = false;

  Future<void> _submitQuiz() async {
    if (_showSubmitDialog) return;
    _showSubmitDialog = true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Selesaikan kuis?'),
        content: const Text(
          'Pastikan jawabanmu sudah diperiksa sebelum mengirim hasil.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Periksa lagi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Kirim jawaban'),
          ),
        ],
      ),
    );

    _showSubmitDialog = false;

    if (confirmed != true || !mounted) return;

    final provider = context.read<QuizProvider>();
    final result = provider.submitQuiz();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(result: result),
      ),
    );
  }

  Future<bool> _confirmExit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari kuis?'),
        content: const Text(
          'Kalau keluar, kuis yang sedang dikerjakan akan ditinggalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Lanjut kuis'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final questions = provider.activeQuestions;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Soal kuis belum tersedia.'),
        ),
      );
    }

    final index = provider.currentIndex.clamp(0, questions.length - 1);
    final question = questions[index];
    final selectedAnswer = provider.userAnswers[question.id];
    final isFlagged = provider.flaggedQuestions[question.id] ?? false;
    final isLast = index == questions.length - 1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await _confirmExit();

        if (shouldExit && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Quiznova',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          leading: IconButton(
            tooltip: 'Keluar dari kuis',
            icon: const Icon(Icons.close_rounded),
            onPressed: () async {
              final shouldExit = await _confirmExit();

              if (shouldExit && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            IconButton(
              tooltip: isFlagged ? 'Hapus bookmark' : 'Bookmark soal',
              onPressed: () => provider.toggleFlag(question.id),
              icon: Icon(
                isFlagged
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: isFlagged ? Colors.amber : null,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth =
                  constraints.maxWidth > 700 ? 640.0 : double.infinity;

              return Center(
                child: SizedBox(
                  width: maxWidth,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF0284C7),
                              Color(0xFF4F46E5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'INTERACTIVE KNOWLEDGE CHALLENGE',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hai, ${provider.userName}!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Fokus dan pilih jawaban terbaikmu.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      QuizProgressBar(
                        currentIndex: index,
                        total: questions.length,
                        timeRemaining: provider.timeRemaining,
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF263449)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 11,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDBEAFE),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'SOAL ${index + 1}',
                                    style: const TextStyle(
                                      color: Color(0xFF0369A1),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  question.difficulty,
                                  style: const TextStyle(
                                    color: Color(0xFF7C3AED),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              question.question,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                height: 1.45,
                              ),
                            ),
                            if (question.codeSnippet != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    question.codeSnippet!,
                                    style: const TextStyle(
                                      color: Color(0xFFE2E8F0),
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'PILIH JAWABAN',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(question.options.length, (optionIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: OptionCard(
                            index: optionIndex,
                            label: question.options[optionIndex],
                            isSelected: selectedAnswer == optionIndex,
                            onTap: () {
                              provider.selectAnswer(
                                question.id,
                                optionIndex,
                              );
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: index > 0
                                  ? provider.prevQuestion
                                  : null,
                              icon: const Icon(Icons.arrow_back_rounded),
                              label: const Text('Sebelumnya'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: selectedAnswer == null
                                  ? null
                                  : isLast
                                      ? _submitQuiz
                                      : provider.nextQuestion,
                              icon: Icon(
                                isLast
                                    ? Icons.flag_rounded
                                    : Icons.arrow_forward_rounded,
                              ),
                              label: Text(
                                isLast ? 'Selesai' : 'Berikutnya',
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF0284C7),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Soal ${index + 1} dari ${questions.length}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
