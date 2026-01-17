import 'package:flutter/material.dart';

/// ThemeExtension that carries app-specific visuals (mainly the background gradient used by AieBackground).
class AieThemeExtension extends ThemeExtension<AieThemeExtension> {
  final Color gradientTop;
  final Color gradientBottom;

  const AieThemeExtension({required this.gradientTop, required this.gradientBottom});

  @override
  AieThemeExtension copyWith({Color? gradientTop, Color? gradientBottom}) {
    return AieThemeExtension(
      gradientTop: gradientTop ?? this.gradientTop,
      gradientBottom: gradientBottom ?? this.gradientBottom,
    );
  }

  @override
  AieThemeExtension lerp(ThemeExtension<AieThemeExtension>? other, double t) {
    if (other is! AieThemeExtension) return this;
    return AieThemeExtension(
      gradientTop: Color.lerp(gradientTop, other.gradientTop, t) ?? gradientTop,
      gradientBottom: Color.lerp(gradientBottom, other.gradientBottom, t) ?? gradientBottom,
    );
  }
}
