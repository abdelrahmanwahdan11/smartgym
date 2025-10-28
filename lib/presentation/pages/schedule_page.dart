import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/schedule_controller.dart';
import '../widgets/states.dart';

class SchedulePage extends GetView<ScheduleController> {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('schedule'.tr)),
      body: Obx(() {
        if (controller.bookings.isEmpty) {
          return ListEmptyState(message: 'No bookings yet');
        }
        return ListView.builder(
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];
            return ListTile(
              title: Text('Class ${booking.classId}'),
              subtitle: Text('Status: ${booking.status}'),
              trailing: TextButton(
                onPressed: () => controller.cancelBooking(booking.id),
                child: Text('cancel'.tr),
              ),
            );
          },
        );
      }),
    );
  }
}
