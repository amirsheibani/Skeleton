import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';

class AuthLogoWidget extends StatelessWidget {
  const AuthLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final greenColor = Theme.of(context).green;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: greenColor.shade60,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.power,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'venzo',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: greenColor.shade60,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

