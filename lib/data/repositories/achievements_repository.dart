import '../local_data/seed_loader.dart';
import '../models/achievement_model.dart';

class AchievementsRepository {
  Future<List<AchievementModel>> fetchAchievements() async {
    final seed = SeedLoader.tryGet('assets/data/achievements.json');
    final items = seed?['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => AchievementModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
