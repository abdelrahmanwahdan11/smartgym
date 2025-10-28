import '../local_data/seed_loader.dart';
import '../models/class_model.dart';

class ClassesRepository {
  Future<List<ClassModel>> fetchClasses() async {
    final seed = SeedLoader.tryGet('assets/data/classes.json');
    final items = seed?['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => ClassModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
