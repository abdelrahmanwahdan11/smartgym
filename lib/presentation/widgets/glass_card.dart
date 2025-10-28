import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppConstants.spacingLg),
    this.margin,
    this.gradient,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppConstants.radiusLg);
    final cardColor = gradient == null
        ? colorScheme.surface.withOpacity(0.9)
        : Colors.transparent;

    Widget content = Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: cardColor,
        gradient: gradient,
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: AppConstants.radiusLg,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    content = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: content,
      ),
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
