import 'package:flutter/material.dart';

import '../../core/constants.dart';

class FabDock extends StatelessWidget {
  const FabDock({
    super.key,
    required this.children,
    this.backgroundOpacity = 0.92,
  }) : assert(children.length <= 3);

  final List<Widget> children;
  final double backgroundOpacity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final padding = MediaQuery.of(context).viewPadding;

    return SafeArea(
      minimum: EdgeInsets.only(
        left: AppConstants.spacingLg,
        right: AppConstants.spacingLg,
        bottom: AppConstants.spacingLg + padding.bottom,
      ),
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(backgroundOpacity),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
          border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.all(AppConstants.spacingSm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              Flexible(child: children[i]),
              if (i != children.length - 1)
                const SizedBox(width: AppConstants.spacingSm),
            ],
          ],
        ),
      ),
    );
  }
}
