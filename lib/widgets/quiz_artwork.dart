import 'package:flutter/material.dart';

class QuizArtwork extends StatelessWidget {
  const QuizArtwork({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: compact ? 1.15 : 1.35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: compact ? 116 : 150,
            height: compact ? 116 : 150,
            decoration: const BoxDecoration(
              color: Color(0xFF7D70E5),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            top: compact ? 15 : 22,
            right: compact ? 14 : 24,
            child: const _FloatingIcon(
              icon: Icons.auto_awesome_rounded,
              color: Color(0xFFFFD76D),
              size: 42,
            ),
          ),
          Positioned(
            left: compact ? 12 : 22,
            bottom: compact ? 18 : 28,
            child: const _FloatingIcon(
              icon: Icons.lightbulb_rounded,
              color: Color(0xFFFFD76D),
              size: 46,
            ),
          ),
          Icon(
            Icons.quiz_rounded,
            size: compact ? 98 : 128,
            color: Colors.white,
          ),
          Positioned(
            right: compact ? 6 : 10,
            bottom: compact ? 24 : 32,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFB9F3DE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF246C55),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  const _FloatingIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: size);
  }
}
