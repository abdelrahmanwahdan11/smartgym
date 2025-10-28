import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../data/models/product_model.dart';
import '../controllers/cart_controller.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductModel product = Get.arguments as ProductModel;
    final cart = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
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
                    child: Text(
                      '$count',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: const Center(child: Icon(Icons.shopping_bag_outlined, size: 64)),
          ),
          const SizedBox(height: 16),
          Text('${product.price.toStringAsFixed(2)} USD',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: product.tags.map((e) => Chip(label: Text(e))).toList()),
          const SizedBox(height: 16),
          Text(product.details, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              await cart.addItem(product);
              Get.snackbar('added'.tr, 'added_to_cart'.tr);
            },
            child: Text('add_to_cart'.tr),
          ),
        ],
      ),
    );
  }
}
