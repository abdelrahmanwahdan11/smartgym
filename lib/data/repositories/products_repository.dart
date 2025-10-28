import '../../core/app_initializer.dart';
import '../local_data/seed_loader.dart';
import '../models/product_model.dart';
import 'provider_repository.dart';

class ProductsRepository {
  ProductsRepository({ProviderRepository? providerRepository})
      : _providerRepository = providerRepository ?? ProviderRepository(AppInitializer.store);

  final ProviderRepository _providerRepository;

  Future<List<ProductModel>> fetchProducts() async {
    final seed = SeedLoader.tryGet('assets/data/products.json');
    final items = seed?['items'] as List<dynamic>? ?? [];
    final seeded = items
        .map((e) => ProductModel.fromMap(e as Map<String, dynamic>))
        .toList();
    final overlay = _providerRepository.overlayProducts();
    return [...seeded, ...overlay];
  }
}
