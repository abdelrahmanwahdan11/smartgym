import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/cart_controller.dart';
import '../controllers/store_controller.dart';
import '../widgets/paginator_list.dart';
import '../widgets/search_bar.dart';
import '../widgets/states.dart';

class StorePage extends GetView<StoreController> {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('store'.tr),
        actions: [
          IconButton(onPressed: controller.togglePriceSort, icon: const Icon(Icons.sort)),
          Obx(() {
            final count = cart.itemCount;
            final icon = IconButton(
              onPressed: () => Get.toNamed(AppRoutes.cart),
              icon: const Icon(Icons.shopping_cart_outlined),
            );
            if (count == 0) {
              return icon;
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                icon,
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            );
          }),
        ],
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
                    .map((e) {
                      final isAll = e == 'All';
                      final value = isAll ? '' : e;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(isAll ? 'all'.tr : e),
                          selected: controller.category.value == value,
                          onSelected: (_) => controller.selectCategory(value),
                        ),
                      );
                    })
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
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${product.price.toStringAsFixed(2)} USD'),
                          TextButton(
                            onPressed: () async {
                              await cart.addItem(product);
                              Get.snackbar('added'.tr, 'added_to_cart'.tr);
                            },
                            child: Text('add_to_cart'.tr),
                          ),
                        ],
                      ),
                      onTap: () => Get.toNamed('${AppRoutes.product}/${product.id}', arguments: product),
                      onLongPress: () async {
                        await cart.addItem(product);
                        Get.snackbar('added'.tr, 'added_to_cart'.tr);
                      },
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
