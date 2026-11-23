import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap ?? () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.paper,
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'G',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4285F4),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: TextStyle(fontFamily: 'Arial', fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}