import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../core/constants.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/class_model.dart';
import '../../data/models/gym_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/trainer_model.dart';
import '../controllers/universal_search_controller.dart';
import '../widgets/m3_search_bar.dart';
import '../widgets/rating_stars.dart';
import '../widgets/tag_pill.dart';
import '../widgets/states.dart';

class UniversalSearchPage extends GetView<UniversalSearchController> {
  const UniversalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('search'.tr)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            children: [
              Obx(
                () => M3SearchBar(
                  hintText: 'search_placeholder'.tr,
                  suggestions: controller.suggestions.toList(growable: false),
                  onQueryChanged: controller.updateQuery,
                  onSubmitted: controller.updateQuery,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final hasAny = controller.classResults.isNotEmpty ||
                      controller.gymResults.isNotEmpty ||
                      controller.trainerResults.isNotEmpty ||
                      controller.productResults.isNotEmpty;
                  if (!hasAny) {
                    return Center(child: ListEmptyState(message: 'no_results'.tr));
                  }
                  return ListView(
                    children: [
                      _ResultSection<ClassModel>(
                        title: 'classes'.tr,
                        items: controller.classResults,
                        itemBuilder: (context, item) => _ClassResultTile(
                          item: item,
                          gymName: controller.gymNameFor(item.gymId),
                          trainerName: controller.trainerNameFor(item.trainerId),
                        ),
                      ),
                      _ResultSection<GymModel>(
                        title: 'gyms'.tr,
                        items: controller.gymResults,
                        itemBuilder: (context, item) => _GymResultTile(item: item),
                      ),
                      _ResultSection<TrainerModel>(
                        title: 'trainers'.tr,
                        items: controller.trainerResults,
                        itemBuilder: (context, item) => _TrainerResultTile(item: item),
                      ),
                      _ResultSection<ProductModel>(
                        title: 'store'.tr,
                        items: controller.productResults,
                        itemBuilder: (context, item) => _ProductResultTile(item: item),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultSection<T> extends StatelessWidget {
  const _ResultSection({
    required this.title,
    required this.items,
    required this.itemBuilder,
  });

  final String title;
  final Iterable<T> items;
  final Widget Function(BuildContext, T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          ...items.map((item) => itemBuilder(context, item)),
        ],
      ),
    );
  }
}

class _ClassResultTile extends StatelessWidget {
  const _ClassResultTile({
    required this.item,
    required this.gymName,
    required this.trainerName,
  });

  final ClassModel item;
  final String gymName;
  final String trainerName;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: const Icon(IconlyLight.calendar),
        ),
        title: Text(item.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                TagPill(label: item.type),
                TagPill(label: item.level),
                TagPill(label: '${item.durationMin} min'),
              ],
            ),
            if (gymName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(gymName, style: Theme.of(context).textTheme.bodySmall),
              ),
            if (trainerName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(trainerName, style: Theme.of(context).textTheme.bodySmall),
              ),
          ],
        ),
        onTap: () => Get.toNamed('${AppRoutes.classDetails}/${item.id}'),
      ),
    );
  }
}

class _GymResultTile extends StatelessWidget {
  const _GymResultTile({required this.item});

  final GymModel item;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: const Icon(IconlyLight.work),
        ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.locationText),
            const SizedBox(height: 4),
            RatingStars(rating: item.rating),
          ],
        ),
        trailing: item.discount > 0
            ? Chip(
                avatar: const Icon(Icons.local_offer, size: 16),
                label: Text('-${item.discount}%'),
              )
            : null,
        onTap: () => Get.toNamed('${AppRoutes.gymDetails}/${item.id}'),
      ),
    );
  }
}

class _TrainerResultTile extends StatelessWidget {
  const _TrainerResultTile({required this.item});

  final TrainerModel item;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: const Icon(IconlyLight.profile),
        ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.specialties.join(', ')),
            const SizedBox(height: 4),
            RatingStars(rating: item.rating),
          ],
        ),
        onTap: () => Get.toNamed('${AppRoutes.trainerDetails}/${item.id}'),
      ),
    );
  }
}

class _ProductResultTile extends StatelessWidget {
  const _ProductResultTile({required this.item});

  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: const Icon(IconlyLight.buy),
        ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.category),
            const SizedBox(height: 4),
            if (item.tags.isNotEmpty)
              Text(item.tags.take(3).join(', '), style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        trailing: Text('USD ${item.price.toStringAsFixed(2)}'),
        onTap: () => Get.toNamed('${AppRoutes.product}/${item.id}'),
      ),
    );
  }
}
