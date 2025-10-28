import 'package:flutter/material.dart';

import '../../core/constants.dart';

class ParallaxHeader extends StatelessWidget {
  const ParallaxHeader({
    super.key,
    required this.image,
    this.title,
    this.subtitle,
    this.height = 280,
  });

  final Widget image;
  final Widget? title;
  final Widget? subtitle;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: height,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
          StretchMode.blurBackground,
        ],
        titlePadding: const EdgeInsetsDirectional.only(
          start: AppConstants.spacingLg,
          bottom: AppConstants.spacingLg,
          end: AppConstants.spacingLg,
        ),
        title: title == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.headlineSmall!,
                    child: title!,
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
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(tag: image.hashCode, child: image),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.45),
                    colorScheme.surface.withOpacity(0.0),
                    colorScheme.surface,
                  ],
                  stops: const [0, 0.45, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
