import 'package:flutter/material.dart';

import '../../data/models/booking_model.dart';

class ConflictTimeline extends StatelessWidget {
  const ConflictTimeline({
    super.key,
    required this.windows,
  });

  final List<ConflictTimelineItem> windows;

  @override
  Widget build(BuildContext context) {
    if (windows.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final item = windows[index];
          return InputChip(
            label: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  '${_formatTime(item.start)} - ${_formatTime(item.end)}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            onPressed: item.onTap,
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: windows.length,
      ),
    );
  }

  String _formatTime(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

class ConflictTimelineItem {
  ConflictTimelineItem({
    required this.booking,
    required this.start,
    required this.end,
    required this.title,
    this.onTap,
  });

  final BookingModel booking;
  final DateTime start;
  final DateTime end;
  final String title;
  final VoidCallback? onTap;
}
