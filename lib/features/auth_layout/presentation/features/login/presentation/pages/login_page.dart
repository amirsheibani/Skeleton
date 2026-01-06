import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeleton/app/router.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/features/auth_layout/presentation/widgets/auth_logo_widget.dart';
import 'package:skeleton/features/auth_layout/presentation/widgets/facebook_login_button.dart';
import 'package:skeleton/features/auth_layout/presentation/widgets/google_login_button.dart';
import 'package:skeleton/features/auth_layout/presentation/widgets/or_separator_widget.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/manager/login_provider.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/manager/login_state.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/widgets/login_forgot_password_widget.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/widgets/login_password_field.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/widgets/login_remember_me_widget.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/widgets/login_sign_up_link.dart';
import 'package:skeleton/generated/l10n.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _handleSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(loginProvider.notifier).signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  void _handleGoogleLogin() {
    ref.read(loginProvider.notifier).signInWithGoogle();
  }

  void _handleFacebookLogin() {
    ref.read(loginProvider.notifier).signInWithFacebook();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greenColor = theme.green;
    final loginState = ref.watch(loginProvider);
    final isLoading = loginState is LoginLoading;

    // Listen to login state changes
    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next is LoginSuccess) {
        // Navigate to home on successful login
        context.go(AppRouterPath.home.path);
      } else if (next is LoginFailed) {
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
                      greenColor.shade90.withOpacity(0.1),
                      Colors.purple.withOpacity(0.05),
                      greenColor.shade80.withOpacity(0.1),
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
                    const SizedBox(height: 40),

                    // Logo and App Name
                    const AuthLogoWidget(),
                    const SizedBox(height: 48),

                    // Sign in title
                    Text(
                      S.current.sign_in,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: greenColor.shade50,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

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
                        if (!value.contains('@')) {
                          return S.current.validation_email_invalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    LoginPasswordField(controller: _passwordController),
                    const SizedBox(height: 16),

                    // Remember Me and Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LoginRememberMeWidget(
                          initialValue: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value;
                            });
                          },
                        ),
                        const LoginForgotPasswordWidget(),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Sign in button
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
                        onPressed: isLoading ? null : _handleSignIn,
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
                                    S.current.sign_in_button,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
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

                    // Sign up link
                    const LoginSignUpLink(),
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
