import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GoldOrnament extends StatelessWidget {
  const GoldOrnament({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 24, child: Divider(color: AppColors.gold, thickness: 1)),
        Icon(Icons.diamond_outlined, color: AppColors.gold, size: 16),
        SizedBox(width: 24, child: Divider(color: AppColors.gold, thickness: 1)),
      ],
    );
  }
}