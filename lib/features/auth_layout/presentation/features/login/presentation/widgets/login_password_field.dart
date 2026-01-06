import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/generated/l10n.dart';

class LoginPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const LoginPasswordField({
    super.key,
    required this.controller,
  });

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greenColor = theme.green;
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: S.current.password,
        hintText: S.current.your_password,
        prefixIcon: Icon(Icons.lock_outlined, color: greenColor.shade60),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: theme.text.shade60,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
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
          return S.current.validation_password_required;
        }
        if (value.length < 6) {
          return S.current.validation_password_min_length;
        }
        return null;
      },
    );
  }
}

