import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/cart_controller.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cart'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: controller.clear,
            tooltip: 'clear_cart'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return Center(child: Text('cart_empty'.tr));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => controller.removeItem(item.id),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(item.tags.join(', '), style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _QuantityControl(
                                value: item.qty,
                                onChanged: (value) => controller.updateQuantity(item.id, value),
                              ),
                              Text('${item.subtotal.toStringAsFixed(2)} USD',
                                  style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('total'.tr, style: Theme.of(context).textTheme.titleMedium),
                          Text('${controller.itemCount} ${'items'.tr}',
                              style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                      Text('${controller.total.toStringAsFixed(2)} USD',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Get.toNamed(AppRoutes.checkout),
                    child: Text('proceed'.tr),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(value.toString(), style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
