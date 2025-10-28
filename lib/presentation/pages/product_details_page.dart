import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../core/routes/route_args.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/products_repository.dart';
import '../controllers/cart_controller.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  ProductModel? product;
  bool isLoading = true;
  late final ProductDetailsArgs args;

  @override
  void initState() {
    super.initState();
    args = ProductDetailsArgs.from(Get.parameters, Get.arguments);
    _load();
  }

  Future<void> _load() async {
    final repo = Get.find<ProductsRepository>();
    final resolved = args.initial ?? await repo.findById(args.id);
    if (!mounted) return;
    setState(() {
      product = resolved;
      isLoading = false;
    });
    if (resolved == null) {
      Get.snackbar('errors'.tr, 'unexpected_error'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final resolved = product;
    return Scaffold(
      appBar: AppBar(
        title: Text(resolved?.name ?? 'loading'.tr),
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
                      child: const Center(child: Icon(Icons.shopping_bag_outlined, size: 64)),
                    ),
                    const SizedBox(height: 16),
                    Text('${resolved.price.toStringAsFixed(2)} USD',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, children: resolved.tags.map((e) => Chip(label: Text(e))).toList()),
                    const SizedBox(height: 16),
                    Text(resolved.details, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () async {
                        if (resolved == null) return;
                        await cart.addItem(resolved);
                        Get.snackbar('added'.tr, 'added_to_cart'.tr);
                      },
                      child: Text('add_to_cart'.tr),
                    ),
                  ],
                ),
    );
  }
}
