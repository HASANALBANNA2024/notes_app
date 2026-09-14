import 'package:flutter/material.dart';

import '../app_theme.dart';

/// Custom screen widget with dynamic background support
class ScreenBackground extends StatelessWidget {
  final Widget child;
  final bool isGradient;
  final Color? backgroundColor;

  const ScreenBackground({
    super.key,
    required this.child,
    this.isGradient = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: isGradient
            ? const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.moss, AppTheme.mossDeep],
                ),
              )
            : null,
        child: SafeArea(child: child),
      ),
    );
  }
}
