import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';

class CartCheckoutBar extends StatelessWidget {
  const CartCheckoutBar({
    super.key,
    required this.formattedTotal,
    required this.onCheckout,
    this.buttonLabel = 'Checkout  ›',
    this.deliveryNote = 'Free delivery',
    this.enabled = true,
    this.isLoading = false,
  });

  final String formattedTotal;
  final VoidCallback onCheckout;
  final String buttonLabel;
  final String deliveryNote;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formattedTotal,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  color: AppColors.ink,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                deliveryNote,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  color: AppColors.forest,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          FilledButton(
            onPressed: (enabled && !isLoading) ? onCheckout : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.forest,
              foregroundColor: AppColors.goldLight,
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              side: const BorderSide(color: AppColors.goldBorder, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.goldLight,
                    ),
                  )
                : Text(
                    buttonLabel,
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}