import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/buddy_controller.dart';

class BuddyMatchPage extends StatefulWidget {
  const BuddyMatchPage({super.key});

  @override
  State<BuddyMatchPage> createState() => _BuddyMatchPageState();
}

class _BuddyMatchPageState extends State<BuddyMatchPage> {
  final BuddyController controller = Get.find<BuddyController>();
  final TextEditingController nameController = TextEditingController(text: 'Guest');
  final RxSet<String> selectedGoals = <String>{}.obs;
  final RxSet<String> selectedDays = <String>{}.obs;
  final RxSet<String> selectedGyms = <String>{'gym_001'}.obs;

  @override
  void initState() {
    super.initState();
    final profile = controller.profile.value;
    if (profile != null) {
      nameController.text = profile.name;
      selectedGoals.addAll(profile.goals);
      selectedDays.addAll(profile.availableDays);
      selectedGyms
        ..clear()
        ..addAll(profile.nearbyGymIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('buddy_match'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'name'.tr),
          ),
          const SizedBox(height: 12),
          Text('goals'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 8,
                children: controller.goalOptions
                    .map((goal) => FilterChip(
                          label: Text(goal),
                          selected: selectedGoals.contains(goal),
                          onSelected: (value) {
                            if (value) {
                              selectedGoals.add(goal);
                            } else {
                              selectedGoals.remove(goal);
                            }
                          },
                        ))
                    .toList(),
              )),
          const SizedBox(height: 16),
          Text('weekly_split'.tr, style: Theme.of(context).textTheme.titleMedium),
          Obx(() => Wrap(
                spacing: 8,
                children: controller.dayOptions
                    .map((day) => FilterChip(
                          label: Text(day.tr),
                          selected: selectedDays.contains(day),
                          onSelected: (value) {
                            if (value) {
                              selectedDays.add(day);
                            } else {
                              selectedDays.remove(day);
                            }
                          },
                        ))
                    .toList(),
              )),
          const SizedBox(height: 16),
          Text('gyms'.tr, style: Theme.of(context).textTheme.titleMedium),
          Obx(() => Wrap(
                spacing: 8,
                children: ['gym_001', 'gym_002', 'gym_003', 'gym_004']
                    .map((gym) => FilterChip(
                          label: Text(gym.toUpperCase()),
                          selected: selectedGyms.contains(gym),
                          onSelected: (value) {
                            if (value) {
                              selectedGyms.add(gym);
                            } else {
                              selectedGyms.remove(gym);
                            }
                          },
                        ))
                    .toList(),
              )),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => controller.saveProfile(
              name: nameController.text,
              goals: selectedGoals.toList(),
              days: selectedDays.toList(),
              gyms: selectedGyms.toList(),
            ),
            child: Text('save'.tr),
          ),
          const SizedBox(height: 24),
          Text('suggested', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.matches.isEmpty) {
              return Text('no_results'.tr);
            }
            return Column(
              children: controller.matches
                  .map((match) => Card(
                        child: ListTile(
                          title: Text(match.name),
                          subtitle: Text('${match.goals.join(', ')} • ${match.availableDays.map((e) => e.tr).join(', ')}'),
                          trailing: TextButton(
                            onPressed: () => Get.snackbar('buddy_match'.tr, 'join'.tr),
                            child: Text('join'.tr),
                          ),
                        ),
                      ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}
