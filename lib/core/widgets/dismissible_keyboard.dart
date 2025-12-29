import 'package:flutter/material.dart';

class DismissibleKeyboard extends StatelessWidget {
  final Widget child;

  const DismissibleKeyboard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        // final FocusScopeNode currentFocus = FocusScope.of(context);
        // if (currentFocus.focusedChild != null) {
        //   FocusManager.instance.primaryFocus!.unfocus();
        // }
      },
      child: child,
    );
  }
}
