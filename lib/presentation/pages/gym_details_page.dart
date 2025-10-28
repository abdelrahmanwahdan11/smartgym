import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../core/routes/route_args.dart';
import '../../data/models/gym_model.dart';
import '../../data/repositories/gyms_repository.dart';

class GymDetailsPage extends StatefulWidget {
  const GymDetailsPage({super.key});

  @override
  State<GymDetailsPage> createState() => _GymDetailsPageState();
}

class _GymDetailsPageState extends State<GymDetailsPage> {
  GymModel? gym;
  bool isLoading = true;
  late final GymDetailsArgs args;

  @override
  void initState() {
    super.initState();
    args = GymDetailsArgs.from(Get.parameters, Get.arguments);
    _load();
  }

  Future<void> _load() async {
    final repo = Get.find<GymsRepository>();
    final resolved = args.initial ?? await repo.findById(args.id);
    if (!mounted) return;
    setState(() {
      gym = resolved;
      isLoading = false;
    });
    if (resolved == null) {
      Get.snackbar('errors'.tr, 'unexpected_error'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolved = gym;
    return Scaffold(
      appBar: AppBar(title: Text(resolved?.name ?? 'loading'.tr)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : resolved == null
              ? Center(child: Text('unexpected_error'.tr))
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      ),
                      child: const Center(child: Icon(Icons.home_work_outlined, size: 64)),
                    ),
                    const SizedBox(height: 16),
                    Text(resolved.locationText, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Text('amenities'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: resolved.amenities.map((e) => Chip(label: Text(e))).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('equipment'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Column(
                      children: resolved.equipment
                          .map((e) => ListTile(
                                leading: const Icon(Icons.circle, size: 8),
                                title: Text(e),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Get.toNamed(AppRoutes.classes),
                      child: Text('view_all'.tr),
                    ),
                  ],
                ),
    );
  }
}
