import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Center(
        child: Text('HomePage', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).secondary)),
      ),
    );
  }
}
