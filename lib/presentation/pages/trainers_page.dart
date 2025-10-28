import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/trainers_controller.dart';
import '../widgets/paginator_list.dart';
import '../widgets/rating_stars.dart';
import '../widgets/search_bar.dart';
import '../widgets/states.dart';

class TrainersPage extends GetView<TrainersController> {
  const TrainersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('trainers'.tr)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DebouncedSearchBar(
              hintText: 'search_placeholder'.tr,
              onChanged: controller.updateQuery,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.displayed.isEmpty) {
                return ListEmptyState(message: 'no_results'.tr);
              }
              return PaginatorListView(
                itemCount: controller.displayed.length,
                onEndReached: controller.loadMore,
                hasMore: controller.hasMore.value,
                itemBuilder: (context, index) {
                  final trainer = controller.displayed[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(trainer.name.substring(0, 1))),
                    title: Text(trainer.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trainer.specialties.join(', ')),
                        RatingStars(rating: trainer.rating),
                      ],
                    ),
                    onTap: () => Get.toNamed('${AppRoutes.trainerDetails}/${trainer.id}', arguments: trainer),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
