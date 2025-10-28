import '../local_data/seed_loader.dart';
import '../models/gym_model.dart';

class GymsRepository {
  Future<List<GymModel>> fetchGyms() async {
    final seed = SeedLoader.tryGet('assets/data/gyms.json');
    final items = seed?['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => GymModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
