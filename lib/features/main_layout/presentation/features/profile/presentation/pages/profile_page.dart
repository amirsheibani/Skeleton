import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Center(
        child: Text('ProfilePage', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).secondary)),
      ),
    );
  }
}
