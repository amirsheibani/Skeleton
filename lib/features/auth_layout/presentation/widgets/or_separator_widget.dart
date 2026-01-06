import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/generated/l10n.dart';

class OrSeparatorWidget extends StatelessWidget {
  const OrSeparatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.text.shade90,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            S.current.or,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.text.shade60,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.text.shade90,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

