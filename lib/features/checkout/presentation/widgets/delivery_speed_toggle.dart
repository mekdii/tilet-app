import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/features/checkout/presentation/bloc/checkout_state.dart';

class DeliverySpeedToggle extends StatelessWidget {
  const DeliverySpeedToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final DeliveryMethod selected;
  final ValueChanged<DeliveryMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.forest, width: 1.2),
      ),
      child: Row(
        children: [
          _Option(
            title: 'Standard',
            subtitle: '• Free',
            isSelected: selected == DeliveryMethod.standard,
            onTap: () => onChanged(DeliveryMethod.standard),
          ),
          _Option(
            title: 'Express',
            subtitle: '• ETB 250',
            isSelected: selected == DeliveryMethod.express,
            onTap: () => onChanged(DeliveryMethod.express),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.forest : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.cream : AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 12,
                  color: isSelected ? AppColors.goldLight : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}