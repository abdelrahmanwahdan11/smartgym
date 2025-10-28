import 'package:flutter/material.dart';

import '../../core/constants.dart';

class GradientAppBar extends StatelessWidget {
  const GradientAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.expandedHeight = 160,
  });

  final Widget title;
  final Widget? subtitle;
  final List<Widget>? actions;
  final double expandedHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar.large(
      pinned: true,
      expandedHeight: expandedHeight,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(
          start: AppConstants.spacingLg,
          bottom: AppConstants.spacingLg,
          end: AppConstants.spacingLg,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: Theme.of(context).textTheme.headlineSmall!,
              child: title,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppConstants.spacingXs),
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: colorScheme.onSurfaceVariant),
                child: subtitle!,
              ),
            ],
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.primaryContainer.withOpacity(0.85),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
