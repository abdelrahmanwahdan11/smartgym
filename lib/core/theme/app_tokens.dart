import 'package:flutter/material.dart';

class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.spacingXs,
    required this.spacingSm,
    required this.spacingMed,
    required this.spacingLg,
    required this.spacingXl,
    required this.animationFast,
    required this.animationMed,
    required this.animationSlow,
  });

  final double spacingXs;
  final double spacingSm;
  final double spacingMed;
  final double spacingLg;
  final double spacingXl;
  final Duration animationFast;
  final Duration animationMed;
  final Duration animationSlow;

  static const AppTokens defaults = AppTokens(
    spacingXs: 6,
    spacingSm: 10,
    spacingMed: 16,
    spacingLg: 24,
    spacingXl: 32,
    animationFast: Duration(milliseconds: 120),
    animationMed: Duration(milliseconds: 260),
    animationSlow: Duration(milliseconds: 420),
  );

  @override
  AppTokens copyWith({
    double? spacingXs,
    double? spacingSm,
    double? spacingMed,
    double? spacingLg,
    double? spacingXl,
    Duration? animationFast,
    Duration? animationMed,
    Duration? animationSlow,
  }) {
    return AppTokens(
      spacingXs: spacingXs ?? this.spacingXs,
      spacingSm: spacingSm ?? this.spacingSm,
      spacingMed: spacingMed ?? this.spacingMed,
      spacingLg: spacingLg ?? this.spacingLg,
      spacingXl: spacingXl ?? this.spacingXl,
      animationFast: animationFast ?? this.animationFast,
      animationMed: animationMed ?? this.animationMed,
      animationSlow: animationSlow ?? this.animationSlow,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) {
      return this;
    }
    return AppTokens(
      spacingXs: lerpDouble(spacingXs, other.spacingXs, t),
      spacingSm: lerpDouble(spacingSm, other.spacingSm, t),
      spacingMed: lerpDouble(spacingMed, other.spacingMed, t),
      spacingLg: lerpDouble(spacingLg, other.spacingLg, t),
      spacingXl: lerpDouble(spacingXl, other.spacingXl, t),
      animationFast: _lerpDuration(animationFast, other.animationFast, t),
      animationMed: _lerpDuration(animationMed, other.animationMed, t),
      animationSlow: _lerpDuration(animationSlow, other.animationSlow, t),
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;

  static Duration _lerpDuration(Duration a, Duration b, double t) {
    final microseconds = (a.inMicroseconds +
            ((b.inMicroseconds - a.inMicroseconds) * t))
        .round();
    return Duration(microseconds: microseconds);
  }
}
