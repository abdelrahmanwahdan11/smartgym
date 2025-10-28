import 'package:flutter/material.dart';

class TagPill extends StatelessWidget {
  const TagPill({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: 14, color: color),
          if (icon != null) const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
