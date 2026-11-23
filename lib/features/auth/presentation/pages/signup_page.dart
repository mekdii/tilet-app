import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/core/widgets/gold_ornament.dart';
import 'package:tilet/core/widgets/primary_button.dart';
import 'package:tilet/core/widgets/textile_footer.dart';
import 'package:tilet/core/widgets/tilet_logo.dart';
import 'package:tilet/features/auth/presentation/widgets/auth_inut.dart';
import 'package:tilet/features/auth/presentation/widgets/google_button.dart';
import 'package:tilet/features/auth/presentation/widgets/or_dvider.dart';
import 'package:tilet/features/home/presentation/pages/home_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  void _openHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 22),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: AppColors.ink),
                      ),
                    ),
                    const SizedBox(height: 3),
                    const TiletLogo(),
                    const SizedBox(height: 12),
                    const Text(
                      'Join Our Family',
                      style: TextStyle(fontSize: 18, color: AppColors.ink),
                    ),
                    const SizedBox(height: 9),
                    const GoldOrnament(),
                    const SizedBox(height: 22),
                    const AuthInput(
                      label: 'Full Name',
                      icon: Icons.person_outline,
                    ),
                    const AuthInput(
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const AuthInput(
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const AuthInput(
                      label: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const AuthInput(
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 2),
                    PrimaryButton(
                      label: 'Create Account',
                      onTap: () => _openHome(context),
                    ),
                    const OrDivider(),
                    const GoogleButton(),
                    const SizedBox(height: 13),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(fontFamily: 'Arial', fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: AppColors.forest,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Arial',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const TextileFooter(height: 48),
          ],
        ),
      ),
    );
  }
}