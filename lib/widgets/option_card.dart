
import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final int index;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.index,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  static const List<String> _letters = ['A', 'B', 'C', 'D', 'E'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = isSelected
        ? const Color(0xFF0284C7)
        : isDark
            ? const Color(0xFF334155)
            : const Color(0xFFE2E8F0);

    final backgroundColor = isSelected
        ? const Color(0xFF0284C7).withValues(alpha: isDark ? 0.18 : 0.07)
        : Theme.of(context).cardTheme.color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.7 : 1,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0284C7)
                      : isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  index >= 0 && index < _letters.length
                      ? _letters[index]
                      : '${index + 1}',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isDark
                            ? Colors.white70
                            : const Color(0xFF475569),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w600,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected
                    ? const Color(0xFF0284C7)
                    : const Color(0xFFCBD5E1),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
