import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';

class SizeSelector extends StatelessWidget {
  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSelected,
  });

  final List<String> sizes;
  final String selectedSize;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: sizes.map((size) {
        final isSelected = size == selectedSize;
        return GestureDetector(
          onTap: () => onSelected(size),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.forest : AppColors.paper,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? AppColors.goldBorder : AppColors.line,
                width: isSelected ? 1.4 : 1,
              ),
            ),
            child: Text(
              size,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.cream : AppColors.ink,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}