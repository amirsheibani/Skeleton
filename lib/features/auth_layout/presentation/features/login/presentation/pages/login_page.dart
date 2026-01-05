import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Center(
        child: Text('LoginPage', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primary)),
      ),
    );
  }
}
