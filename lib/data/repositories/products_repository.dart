import '../local_data/seed_loader.dart';
import '../models/product_model.dart';

class ProductsRepository {
  Future<List<ProductModel>> fetchProducts() async {
    final seed = SeedLoader.tryGet('assets/data/products.json');
    final items = seed?['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => ProductModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
