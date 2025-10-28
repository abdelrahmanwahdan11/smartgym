import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/schedule_controller.dart';
import '../widgets/tag_pill.dart';
import '../widgets/states.dart';

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
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.bookings.isEmpty) {
          return ListEmptyState(message: 'schedule_empty'.tr);
        }
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final booking = controller.bookings[index];
              final classModel = controller.classFor(booking.classId);
              final startTime = classModel?.startTime;
              final timeText = startTime != null
                  ? '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}'
                  : '';
              return Card(
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
