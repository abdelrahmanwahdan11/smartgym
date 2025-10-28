import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/route_args.dart';
import '../../data/models/trainer_model.dart';
import '../../data/repositories/trainers_repository.dart';

class TrainerDetailsPage extends StatefulWidget {
  const TrainerDetailsPage({super.key});

  @override
  State<TrainerDetailsPage> createState() => _TrainerDetailsPageState();
}

class _TrainerDetailsPageState extends State<TrainerDetailsPage> {
  TrainerModel? trainer;
  bool isLoading = true;
  late final TrainerDetailsArgs args;

  @override
  void initState() {
    super.initState();
    args = TrainerDetailsArgs.from(Get.parameters, Get.arguments);
    _load();
  }

  Future<void> _load() async {
    final repo = Get.find<TrainersRepository>();
    final resolved = args.initial ?? await repo.findById(args.id);
    if (!mounted) return;
    setState(() {
      trainer = resolved;
      isLoading = false;
    });
    if (resolved == null) {
      Get.snackbar('errors'.tr, 'unexpected_error'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolved = trainer;
    return Scaffold(
      appBar: AppBar(title: Text(resolved?.name ?? 'loading'.tr)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : resolved == null
              ? Center(child: Text('unexpected_error'.tr))
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    CircleAvatar(radius: 48, child: Text(resolved.name.substring(0, 1))),
                    const SizedBox(height: 16),
                    Text(resolved.bio, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    Text('specialties'.tr, style: Theme.of(context).textTheme.titleMedium),
                    Wrap(spacing: 8, children: resolved.specialties.map((e) => Chip(label: Text(e))).toList()),
                    const SizedBox(height: 16),
                    Text('certifications'.tr, style: Theme.of(context).textTheme.titleMedium),
                    Column(
                      children: resolved.certifications
                          .map((e) => ListTile(leading: const Icon(Icons.verified), title: Text(e)))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('rates'.tr, style: Theme.of(context).textTheme.titleMedium),
                    ...resolved.rates.entries
                        .map((e) => ListTile(title: Text(e.key), trailing: Text('${e.value}'))),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => Get.snackbar('success'.tr, 'personal_requested'.tr),
                      child: Text('book_personal'.tr),
                    ),
                  ],
                ),
    );
  }
}
