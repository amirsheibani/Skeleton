import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/generated/l10n.dart';

class LoginRememberMeWidget extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const LoginRememberMeWidget({
    super.key,
    this.initialValue = true,
    this.onChanged,
  });

  @override
  State<LoginRememberMeWidget> createState() => _LoginRememberMeWidgetState();
}

class _LoginRememberMeWidgetState extends State<LoginRememberMeWidget> {
  late bool _rememberMe;

  @override
  void initState() {
    super.initState();
    _rememberMe = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greenColor = theme.green;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value;
            });
            widget.onChanged?.call(value);
          },
          activeColor: greenColor.shade60,
        ),
        const SizedBox(width: 8),
        Text(
          S.current.remember_me,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.text.shade30,
          ),
        ),
      ],
    );
  }
}

