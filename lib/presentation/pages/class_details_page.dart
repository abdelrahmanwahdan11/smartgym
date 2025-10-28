import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/class_model.dart';
import '../controllers/schedule_controller.dart';
import '../widgets/tag_pill.dart';

class ClassDetailsPage extends StatelessWidget {
  const ClassDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ClassModel classModel = Get.arguments as ClassModel;
    final schedule = Get.find<ScheduleController>();
    return Scaffold(
      appBar: AppBar(title: Text(classModel.title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: const Center(child: Icon(Icons.fitness_center, size: 64)),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TagPill(label: classModel.type),
              TagPill(label: classModel.level),
              TagPill(label: '${classModel.durationMin} min'),
              TagPill(label: classModel.intensity),
            ],
          ),
          const SizedBox(height: 16),
          Text(classModel.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Text('Requirements', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...classModel.requirements.map((e) => ListTile(leading: const Icon(Icons.check), title: Text(e))),
          const SizedBox(height: 16),
          Text('Capacity: ${classModel.capacity} | Booked: ${classModel.booked}'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              schedule.addBooking(
                BookingModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: 'guest',
                  classId: classModel.id,
                  status: 'booked',
                  token: 'PASS',
                  createdAt: DateTime.now(),
                ),
              );
              Get.snackbar('Booked', 'Added to schedule');
            },
            child: Text('book'.tr),
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () => Get.toNamed(AppRoutes.qrPass), child: Text('qr_pass'.tr)),
        ],
      ),
    );
  }
}
