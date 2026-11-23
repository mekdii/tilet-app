import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/core/widgets/primary_button.dart';
import 'package:tilet/core/widgets/textile_footer.dart';
import 'package:tilet/core/widgets/tilet_logo.dart';
import 'package:tilet/features/auth/presentation/pages/signup_page.dart';
import 'package:tilet/features/auth/presentation/widgets/auth_inut.dart';
import 'package:tilet/features/auth/presentation/widgets/google_button.dart';
import 'package:tilet/features/auth/presentation/widgets/or_dvider.dart';
import 'package:tilet/features/home/presentation/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _openHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.forest,
        body: Column(
          children: [
            // Compact Deep Forest Green Header
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    TiletLogo(onDark: true),
                    SizedBox(height: 8),
                    Text(
                      'Habesha Kemis for Every You',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFD8D0BE),
                        fontSize: 15,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Expanded Cream Form Sheet
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 16),
                  child: Column(
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: AppColors.forest,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Please log in to continue',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: AppColors.muted,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 26),
                      const AuthInput(
                        label: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const AuthInput(
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                      ),
                      const SizedBox(height: 4),
                      PrimaryButton(
                        label: 'Log In',
                        onTap: () => _openHome(context),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.forest,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      const OrDivider(),
                      const GoogleButton(),
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Don’t have an account? ',
                            style: TextStyle(fontFamily: 'Arial', fontSize: 13),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignUpPage(),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.forest,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
