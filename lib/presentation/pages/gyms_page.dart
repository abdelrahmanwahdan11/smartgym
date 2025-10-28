import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/gyms_controller.dart';
import '../widgets/paginator_list.dart';
import '../widgets/rating_stars.dart';
import '../widgets/search_bar.dart';
import '../widgets/states.dart';

class GymsPage extends GetView<GymsController> {
  const GymsPage({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final content = Column(
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
                final gym = controller.displayed[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1), child: const Icon(Icons.fitness_center)),
                    title: Text(gym.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(gym.locationText),
                        RatingStars(rating: gym.rating),
                        const SizedBox(height: 4),
                        Text('Amenities: ${gym.amenities.take(3).join(', ')}'),
                      ],
                    ),
                    trailing: gym.discount > 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.local_offer, color: Colors.red),
                              Text('-${gym.discount}%'),
                            ],
                          )
                        : null,
                    onTap: () => Get.toNamed('${AppRoutes.gymDetails}/${gym.id}', arguments: gym),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );

    if (embed) return content;

    return Scaffold(
      appBar: AppBar(title: Text('gyms'.tr)),
      body: content,
    );
  }
}
