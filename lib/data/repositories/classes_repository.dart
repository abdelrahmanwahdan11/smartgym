import '../../core/app_initializer.dart';
import '../local_data/seed_loader.dart';
import '../models/class_model.dart';
import 'provider_repository.dart';

class ClassesRepository {
  ClassesRepository({ProviderRepository? providerRepository})
      : _providerRepository = providerRepository ?? ProviderRepository(AppInitializer.store);

  final ProviderRepository _providerRepository;

  Future<List<ClassModel>> fetchClasses() async {
    final seed = SeedLoader.tryGet('assets/data/classes.json');
    final items = seed?['items'] as List<dynamic>? ?? [];
    final seeded = items
        .map((e) => ClassModel.fromMap(e as Map<String, dynamic>))
        .toList();
    final overlay = _providerRepository.overlayClasses();
    return [...seeded, ...overlay];
  }
}
