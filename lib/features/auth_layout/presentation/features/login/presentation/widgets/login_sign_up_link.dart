import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeleton/app/router.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/generated/l10n.dart';

class LoginSignUpLink extends StatelessWidget {
  const LoginSignUpLink({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greenColor = theme.green;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.current.dont_have_account,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.text.shade60,
          ),
        ),
        TextButton(
          onPressed: () {
            context.go(AppRouterPath.register.path);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            S.current.sign_up,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: greenColor.shade60,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

