import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/core/widgets/gold_ornament.dart';
import 'package:tilet/core/widgets/primary_button.dart';
import 'package:tilet/core/widgets/textile_footer.dart';
import 'package:tilet/core/widgets/tilet_logo.dart';
import 'package:tilet/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tilet/features/auth/presentation/bloc/auth_event.dart';
import 'package:tilet/features/auth/presentation/bloc/auth_state.dart';
import 'package:tilet/features/auth/presentation/widgets/auth_inut.dart';
import 'package:tilet/features/auth/presentation/widgets/google_button.dart';
import 'package:tilet/features/auth/presentation/widgets/or_dvider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(message),
      ),
    );
  }

  void _submit() {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    // Split "Full Name" into first_name and last_name for Django
    final nameParts = fullName.split(RegExp(r'\s+'));
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            email: email,
            password: password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status || prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.isAuthenticated) {
          Navigator.pop(context, true);
        } else if (state.errorMessage != null) {
          _showError(state.errorMessage!);
        }
      },
      builder: (context, state) {
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
                            onPressed: () => Navigator.pop(context, false),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.ink,
                            ),
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
                        AuthInput(
                          controller: _fullNameController,
                          label: 'Full Name',
                          icon: Icons.person_outline,
                        ),
                        AuthInput(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        AuthInput(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        AuthInput(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        AuthInput(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 2),
                        PrimaryButton(
                          label: state.isLoading
                              ? 'Creating Account...'
                              : 'Create Account',
                          onTap: state.isLoading ? () {} : _submit,
                        ),
                        const OrDivider(),
                        const GoogleButton(),
                        const SizedBox(height: 13),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context, false),
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
      },
    );
  }
}