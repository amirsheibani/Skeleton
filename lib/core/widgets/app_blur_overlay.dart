import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';

class AppBlurOverlay extends StatefulWidget {
  final Widget child;
  final Duration blurVisibleDuration;


  const AppBlurOverlay({
    required this.child, super.key,

    this.blurVisibleDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AppBlurOverlay> createState() => _AppBlurOverlayState();
}

class _AppBlurOverlayState extends State<AppBlurOverlay> with WidgetsBindingObserver {
  bool _isBlurred = false;
  Timer? _restoreTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _restoreTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      setState(() {
        _isBlurred = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      _restoreTimer?.cancel();
      _restoreTimer = Timer(widget.blurVisibleDuration, () {
        if (mounted) {
          setState(() {
            _isBlurred = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isBlurred)
          Positioned.fill(
            child: Container(
              color: Theme.of(context).text.shade30.withOpacity(0.3),
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(color: Colors.transparent),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
