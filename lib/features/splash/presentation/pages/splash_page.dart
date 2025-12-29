import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/core/theme/theme_manager/theme_provider.dart';
import 'package:skeleton/generated/l10n.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Placeholder(
      child: Center(
        child: Text('SplashPage', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primary)),
      ),
    );

    Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(flex: 3, child: Placeholder()),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ref.read(themeProvider.notifier).setDark();
              },
              child: Text(S.of(context).dark),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ref.read(themeProvider.notifier).setLight();
              },
              child: Text(S.of(context).light),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ref.read(themeProvider.notifier).setSystem();
              },
              child: Text(S.of(context).system),
            ),
          ),
        ],
      ),
    );
  }
}
