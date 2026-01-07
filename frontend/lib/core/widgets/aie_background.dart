import 'package:flutter/material.dart';
import 'package:aie/core/theme/app_colors.dart';

/// Tło aplikacji (gradient jak na ekranie logowania).
class AieBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AieBackground({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surface2, AppColors.background2],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
