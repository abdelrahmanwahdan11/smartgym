import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductModel product = Get.arguments as ProductModel;
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
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
          FilledButton(onPressed: () => Get.snackbar('Added', 'Added to cart'), child: const Text('Add to cart')),
        ],
      ),
    );
  }
}
