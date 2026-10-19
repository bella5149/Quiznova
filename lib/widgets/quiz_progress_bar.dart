import 'package:flutter/material.dart';

class QuizProgressBar extends StatelessWidget {
  final int currentIndex;
  final int total;
  final int timeRemaining;

  const QuizProgressBar({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = total > 0
        ? ((currentIndex + 1) / total).clamp(0.0, 1.0)
        : 0.0;

    final isUrgent = timeRemaining <= 30;
    final timerColor = isUrgent
        ? const Color(0xFFEF4444)
        : const Color(0xFF0284C7);

    final minutes = (timeRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (timeRemaining % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF263449)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Soal ${total == 0 ? 0 : currentIndex + 1} dari $total',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : const Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: timerColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 17,
                      color: timerColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$minutes:$seconds',
                      style: TextStyle(
                        color: timerColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        fontFeatures: const [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF0284C7),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).round()}% selesai',
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
