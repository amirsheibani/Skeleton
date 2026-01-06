import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/generated/l10n.dart';

class LoginForgotPasswordWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const LoginForgotPasswordWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greenColor = theme.green;
    return TextButton(
      onPressed: onPressed ?? () {
        // TODO: Navigate to forgot password page
        print('Forgot password');
      },
      child: Text(
        S.current.forgot_password,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: greenColor.shade60,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

