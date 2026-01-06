import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeleton/app/router.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/features/auth_layout/presentation/widgets/facebook_login_button.dart';
import 'package:skeleton/features/auth_layout/presentation/widgets/google_login_button.dart';
import 'package:skeleton/features/auth_layout/presentation/widgets/or_separator_widget.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/manager/login_provider.dart';
import 'package:skeleton/features/auth_layout/presentation/features/register/presentation/manager/register_provider.dart';
import 'package:skeleton/features/auth_layout/presentation/features/register/presentation/manager/register_state.dart';
import 'package:skeleton/features/auth_layout/presentation/features/register/presentation/widgets/register_confirm_password_field.dart';
import 'package:skeleton/features/auth_layout/presentation/features/register/presentation/widgets/register_password_field.dart';
import 'package:skeleton/features/auth_layout/presentation/features/register/presentation/widgets/register_sign_in_link.dart';
import 'package:skeleton/generated/l10n.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(registerProvider.notifier).signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _fullNameController.text.trim(),
          );
    }
  }

  void _handleGoogleLogin() {
    // Use login provider for social login
    ref.read(loginProvider.notifier).signInWithGoogle();
  }

  void _handleFacebookLogin() {
    // Use login provider for social login
    ref.read(loginProvider.notifier).signInWithFacebook();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greenColor = theme.green;
    final registerState = ref.watch(registerProvider);
    final isLoading = registerState is RegisterLoading;

    // Listen to register state changes
    ref.listen<RegisterState>(registerProvider, (previous, next) {
      if (next is RegisterSuccess) {
        // Navigate to home on successful registration
        context.go(AppRouterPath.home.path);
      } else if (next is RegisterFailed) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient blurs
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple.withOpacity(0.05),
                      Colors.blue.withOpacity(0.05),
                      greenColor.shade90.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: isLoading
                            ? null
                            : () {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go(AppRouterPath.login.path);
                                }
                              },
                        color: theme.text.shade30,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Sign up title
                    Text(
                      S.current.sign_up,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.text.shade10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Full name field
                    TextFormField(
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: S.current.full_name,
                        hintText: S.current.full_name,
                        prefixIcon: Icon(Icons.person_outline, color: greenColor.shade60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.text.shade90),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.text.shade90),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: greenColor.shade60, width: 2),
                        ),
                        filled: true,
                        fillColor: theme.base.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.current.validation_full_name_required;
                        }
                        if (value.trim().split(' ').length < 2) {
                          return S.current.validation_full_name_invalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: S.current.email,
                        hintText: S.current.email_placeholder,
                        prefixIcon: Icon(Icons.email_outlined, color: greenColor.shade60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.text.shade90),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.text.shade90),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: greenColor.shade60, width: 2),
                        ),
                        filled: true,
                        fillColor: theme.base.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.current.validation_email_required;
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return S.current.validation_email_invalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    RegisterPasswordField(controller: _passwordController),
                    const SizedBox(height: 20),

                    // Confirm password field
                    RegisterConfirmPasswordField(
                      controller: _confirmPasswordController,
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: 32),

                    // Sign up button
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            greenColor.shade80,
                            greenColor.shade60,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S.current.sign_up_button,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: greenColor.shade40,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // OR separator
                    const OrSeparatorWidget(),
                    const SizedBox(height: 32),

                    // Social login buttons
                    GoogleLoginButton(onPressed: isLoading ? () {} : _handleGoogleLogin),
                    const SizedBox(height: 16),
                    FacebookLoginButton(onPressed: isLoading ? () {} : _handleFacebookLogin),
                    const SizedBox(height: 40),

                    // Sign in link
                    const RegisterSignInLink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
