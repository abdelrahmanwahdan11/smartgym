import '../../core/app_initializer.dart';
import '../local_data/seed_loader.dart';
import '../models/trainer_model.dart';
import 'provider_repository.dart';

class TrainersRepository {
  TrainersRepository({ProviderRepository? providerRepository})
      : _providerRepository = providerRepository ?? ProviderRepository(AppInitializer.store);

  final ProviderRepository _providerRepository;

  Future<List<TrainerModel>> fetchTrainers() async {
    final seed = SeedLoader.tryGet('assets/data/trainers.json');
    final items = seed?['items'] as List<dynamic>? ?? [];
    final seeded = items
        .map((e) => TrainerModel.fromMap(e as Map<String, dynamic>))
        .toList();
    final overlay = _providerRepository.overlayTrainers();
    return [...seeded, ...overlay];
  }

  Future<TrainerModel?> findById(String id) async {
    final items = await fetchTrainers();
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }
}
