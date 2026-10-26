import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  const AnswerOption({
    super.key,
    required this.label,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF6658D3) : Colors.transparent;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Semantics(
      button: true,
      selected: selected,
      label: '$label. $text',
      child: Material(
        color: selected
            ? const Color(0xFF6658D3).withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            constraints: const BoxConstraints(minHeight: 62),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected
                    ? const Color(0xFF6658D3)
                    : Theme.of(context).dividerColor.withValues(alpha: 0.4),
                width: selected ? 1.7 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? color : Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? const Color(0xFF6658D3) : textColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.3,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF6658D3),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
