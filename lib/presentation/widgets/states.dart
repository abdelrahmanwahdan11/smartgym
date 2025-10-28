import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ListEmptyState extends StatelessWidget {
  const ListEmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          if (onRetry != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: FilledButton(onPressed: onRetry, child: const Text('Retry')),
            ),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key, this.height = 120});

  final double height;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceVariant;
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fadeIn(duration: 400.ms)
        .shimmer(duration: 1.seconds);
  }
}
