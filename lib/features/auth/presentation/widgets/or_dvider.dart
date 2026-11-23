import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.line)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13),
            child: Text(
              'or',
              style: TextStyle(color: AppColors.ink, fontFamily: 'Arial'),
            ),
          ),
          Expanded(child: Divider(color: AppColors.line)),
        ],
      ),
    );
  }
}