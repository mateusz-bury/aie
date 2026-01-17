import 'package:flutter/material.dart';
import 'package:aie/core/theme/app_colors.dart';
import 'package:aie/core/theme/aie_theme_extension.dart';

/// App background (gradient). Gradient colors come from theme extension,
/// so the look can be switched in settings.
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
    final ext = Theme.of(context).extension<AieThemeExtension>();
    final top = ext?.gradientTop ?? AppColors.surface2;
    final bottom = ext?.gradientBottom ?? AppColors.background2;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [top, bottom],
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
