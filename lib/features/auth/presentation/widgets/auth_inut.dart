import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';

class AuthInput extends StatefulWidget {
  const AuthInput({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.controller,
  });

  final String label;
  final IconData icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword && obscure,
        keyboardType: widget.keyboardType,
        style: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 15,
          color: AppColors.ink,
        ),
        decoration: InputDecoration(
          hintText: widget.label,
          hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
          filled: true,
          fillColor: AppColors.paper,
          prefixIcon: Icon(widget.icon, color: AppColors.forest, size: 21),
          suffixIcon: widget.isPassword
              ? IconButton(
                  splashRadius: 18,
                  onPressed: () => setState(() => obscure = !obscure),
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.muted,
                    size: 19,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
          ),
        ),
      ),
    );
  }
}