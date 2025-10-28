import '../../core/app_initializer.dart';
import '../local_data/seed_loader.dart';
import '../models/gym_model.dart';
import 'provider_repository.dart';

class GymsRepository {
  GymsRepository({ProviderRepository? providerRepository})
      : _providerRepository = providerRepository ?? ProviderRepository(AppInitializer.store);

  final ProviderRepository _providerRepository;

  Future<List<GymModel>> fetchGyms() async {
    final seed = SeedLoader.tryGet('assets/data/gyms.json');
    final items = seed?['items'] as List<dynamic>? ?? [];
    final seeded = items
        .map((e) => GymModel.fromMap(e as Map<String, dynamic>))
        .toList();
    final overlay = _providerRepository.overlayGyms();
    return [...seeded, ...overlay];
  }

  Future<GymModel?> findById(String id) async {
    final items = await fetchGyms();
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }
}
