import 'package:flutter/material.dart';

import 'package:skeleton/core/theme/app_theme.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Center(
        child: Text('RegisterPage', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primary)),
      ),
    );
  }
}
