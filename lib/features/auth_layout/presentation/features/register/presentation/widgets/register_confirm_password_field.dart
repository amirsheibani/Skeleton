import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/generated/l10n.dart';

class RegisterConfirmPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;

  const RegisterConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
  });

  @override
  State<RegisterConfirmPasswordField> createState() => _RegisterConfirmPasswordFieldState();
}

class _RegisterConfirmPasswordFieldState extends State<RegisterConfirmPasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greenColor = theme.green;
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: S.current.confirm_password,
        hintText: S.current.confirm_password,
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
          return S.current.validation_confirm_password_required;
        }
        if (value != widget.passwordController.text) {
          return S.current.validation_passwords_not_match;
        }
        return null;
      },
    );
  }
}

