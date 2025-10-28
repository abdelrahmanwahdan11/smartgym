import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/store_controller.dart';
import '../widgets/paginator_list.dart';
import '../widgets/search_bar.dart';
import '../widgets/states.dart';

class StorePage extends GetView<StoreController> {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('store'.tr),
        actions: [IconButton(onPressed: controller.togglePriceSort, icon: const Icon(Icons.sort))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DebouncedSearchBar(
              hintText: 'search_placeholder'.tr,
              onChanged: controller.updateQuery,
            ),
          ),
          SizedBox(
            height: 48,
            child: Obx(() {
              final categories = controller.categories;
              return ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: categories
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(e),
                            selected: controller.category.value == (e == 'All' ? '' : e),
                            onSelected: (_) => controller.selectCategory(e == 'All' ? '' : e),
                          ),
                        ))
                    .toList(),
              );
            }),
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
                  final product = controller.displayed[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(product.name.substring(0, 1))),
                      title: Text(product.name),
                      subtitle: Text(product.tags.join(', ')),
                      trailing: Text('${product.price.toStringAsFixed(2)} USD'),
                      onTap: () => Get.toNamed('${AppRoutes.product}/${product.id}', arguments: product),
                    ),
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
