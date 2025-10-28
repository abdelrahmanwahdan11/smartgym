import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/class_model.dart';
import '../controllers/schedule_controller.dart';
import '../widgets/tag_pill.dart';

class ClassDetailsPage extends StatefulWidget {
  const ClassDetailsPage({super.key});

  @override
  State<ClassDetailsPage> createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  late ClassModel classModel;
  late ScheduleController schedule;
  bool joinedWaitlist = false;
  bool autoConfirm = false;

  @override
  void initState() {
    super.initState();
    classModel = Get.arguments as ClassModel;
    schedule = Get.find<ScheduleController>();
    _restoreWaitlist();
  }

  Future<void> _restoreWaitlist() async {
    final prefs = AppInitializer.prefs;
    setState(() {
      joinedWaitlist = prefs.getBool(_joinKey) ?? false;
      autoConfirm = prefs.getBool(_autoKey) ?? false;
    });
  }

  String get _joinKey => 'waitlist.${classModel.id}';
  String get _autoKey => 'waitlist.auto.${classModel.id}';

  Future<void> _toggleWaitlist() async {
    setState(() {
      joinedWaitlist = !joinedWaitlist;
    });
    await AppInitializer.prefs.setBool(_joinKey, joinedWaitlist);
    Get.snackbar('smart_waitlist'.tr, joinedWaitlist ? 'join_waitlist'.tr : 'cancel'.tr);
  }

  Future<void> _toggleAuto(bool value) async {
    setState(() {
      autoConfirm = value;
    });
    await AppInitializer.prefs.setBool(_autoKey, value);
  }

  @override
  Widget build(BuildContext context) {
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
          Text('requirements'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...classModel.requirements.map((e) => ListTile(leading: const Icon(Icons.check), title: Text(e))),
          const SizedBox(height: 16),
          Text('${'capacity'.tr}: ${classModel.capacity} | ${'booked'.tr}: ${classModel.booked}'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              await schedule.addBooking(
                BookingModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: 'guest',
                  classId: classModel.id,
                  status: 'booked',
                  token: 'PASS',
                  createdAt: DateTime.now(),
                ),
              );
              Get.snackbar('book'.tr, 'success'.tr);
            },
            child: Text('book'.tr),
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () => Get.toNamed(AppRoutes.qrPass), child: Text('qr_pass'.tr)),
          const SizedBox(height: 32),
          Text('smart_waitlist'.tr, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('auto_confirm'.tr, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text('auto_confirm'.tr),
            value: autoConfirm,
            onChanged: joinedWaitlist ? _toggleAuto : null,
          ),
          FilledButton.tonal(
            onPressed: _toggleWaitlist,
            child: Text(joinedWaitlist ? 'cancel'.tr : 'join_waitlist'.tr),
          ),
        ],
      ),
    );
  }
}
