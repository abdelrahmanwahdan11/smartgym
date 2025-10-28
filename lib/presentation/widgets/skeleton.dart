import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius = 12,
  });

  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final base = colorScheme.surfaceVariant.withOpacity(0.3);
    final highlight = colorScheme.primary.withOpacity(0.12);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: const Duration(milliseconds: 1200), color: highlight)
        .fadeIn(duration: const Duration(milliseconds: 200));
  }
}
