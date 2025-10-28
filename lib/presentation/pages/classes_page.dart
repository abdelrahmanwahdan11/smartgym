import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/classes_controller.dart';
import '../widgets/paginator_list.dart';
import '../widgets/search_bar.dart';
import '../widgets/states.dart';
import '../widgets/tag_pill.dart';

class ClassesPage extends GetView<ClassesController> {
  const ClassesPage({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final body = Column(
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
                final item = controller.displayed[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Wrap(
                    spacing: 6,
                    children: [
                      TagPill(label: item.type),
                      TagPill(label: item.level),
                      TagPill(label: '${item.durationMin} min'),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${item.capacity - item.booked} spots'),
                      Text(item.intensity),
                    ],
                  ),
                  onTap: () => Get.toNamed('${AppRoutes.classDetails}/${item.id}', arguments: item),
                );
              },
            );
          }),
        ),
      ],
    );

    if (embed) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: Text('classes'.tr)),
      body: body,
    );
  }
}
