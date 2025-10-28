import '../local_data/seed_loader.dart';
import '../models/trainer_model.dart';

class TrainersRepository {
  Future<List<TrainerModel>> fetchTrainers() async {
    final seed = SeedLoader.tryGet('assets/data/trainers.json');
    final items = seed?['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => TrainerModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
