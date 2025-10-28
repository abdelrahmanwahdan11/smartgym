import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/schedule_controller.dart';
import '../widgets/tag_pill.dart';
import '../widgets/states.dart';
import '../widgets/conflict_timeline.dart';

class SchedulePage extends GetView<ScheduleController> {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('schedule'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async => controller.clearAll(),
            tooltip: 'clear_all'.tr,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              final ics = controller.generateIcs();
              await Clipboard.setData(ClipboardData(text: ics));
              Get.snackbar('export_ics'.tr, 'copied'.tr);
            },
            tooltip: 'export_ics'.tr,
          ),
          IconButton(
            icon: const Icon(Icons.view_week),
            onPressed: () => Get.toNamed(AppRoutes.programDesigner),
            tooltip: 'program_designer'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.bookings.isEmpty) {
          return ListEmptyState(message: 'schedule_empty'.tr);
        }
        final conflicts = controller.conflictWindows()
            .map(
              (window) => ConflictTimelineItem(
                booking: window.booking,
                start: window.start,
                end: window.end,
                title: window.title,
                onTap: () {
                  final idx = controller.bookings
                      .indexWhere((element) => element.id == window.booking.id);
                  if (idx >= 0) {
                    final context = controllerKeyForIndex(idx).currentContext;
                    if (context != null) {
                      Scrollable.ensureVisible(
                        context,
                        duration: const Duration(milliseconds: 280),
                      );
                    }
                  }
                },
              ),
            )
            .toList();
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.bookings.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return ConflictTimeline(windows: conflicts);
              }
              final booking = controller.bookings[index - 1];
              final classModel = controller.classFor(booking.classId);
              final startTime = classModel?.startTime;
              final timeText = startTime != null
                  ? '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}'
                  : '';
              final hasConflict = conflicts.any((item) => item.booking.id == booking.id);
              return Card(
                key: controllerKeyForIndex(index - 1),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(controller.classTitle(booking.classId)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (timeText.isNotEmpty)
                        Text('schedule_time_label'.trParams({'time': timeText})),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (classModel != null && classModel.level.isNotEmpty)
                            TagPill(label: classModel.level),
                          if (classModel != null && classModel.intensity.isNotEmpty)
                            TagPill(label: classModel.intensity),
                          TagPill(label: '${classModel?.durationMin ?? 0} min'),
                          if (hasConflict)
                            Chip(
                              label: Text('conflicts'.tr),
                              backgroundColor: Theme.of(context).colorScheme.errorContainer,
                              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                            ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(booking.status.tr),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => controller.cancelBooking(booking.id),
                        child: Text('cancel'.tr),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

final _controllerKeys = <int, GlobalKey>{};

GlobalKey controllerKeyForIndex(int index) {
  return _controllerKeys.putIfAbsent(index, () => GlobalKey());
}
