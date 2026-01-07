import 'package:flutter/material.dart';
import 'kiosk_service.dart';

const _ADMIN_PIN = "7391"; // در نسخه نهایی SecureStorage

void showKioskExit(BuildContext context) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text("PIN مدیریتی"),
      content: TextField(
        controller: controller,
        obscureText: true,
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (controller.text == _ADMIN_PIN) {
              await KioskService.stop();
              Navigator.pop(context);
            }
          },
          child: const Text("خروج"),
        )
      ],
    ),
  );
}
