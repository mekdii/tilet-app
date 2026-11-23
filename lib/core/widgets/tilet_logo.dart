import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TiletLogo extends StatelessWidget {
  const TiletLogo({
    super.key,
    this.compact = false,
    this.onDark = false,
  });

  final bool compact;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.diamond_outlined,
          color: onDark ? AppColors.goldLight : AppColors.gold,
          size: compact ? 22 : 34,
        ),
        const SizedBox(width: 6),
        Text(
          'Tilet',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: onDark ? const Color(0xFFFFFBF2) : AppColors.forest,
            fontSize: compact ? 28 : 44,
            height: 1,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }
}