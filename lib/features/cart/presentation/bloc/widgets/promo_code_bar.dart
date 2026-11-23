import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';

class PromoCodeBar extends StatelessWidget {
  const PromoCodeBar({super.key, this.onApply});
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 18, right: 6),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: AppColors.ink,
              ),
              decoration: InputDecoration(
                hintText: 'Add promo code',
                hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          TextButton(
            onPressed: onApply ?? () {},
            child: const Text(
              'Apply',
              style: TextStyle(
                fontFamily: 'Arial',
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}