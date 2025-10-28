import '../../data/models/class_model.dart';
import '../../data/models/gym_model.dart';
import '../../data/models/trainer_model.dart';

class ClassIndexEntry {
  ClassIndexEntry({
    required this.classModel,
    required this.gymName,
    required this.trainerName,
  });

  final ClassModel classModel;
  final String gymName;
  final String trainerName;

  Iterable<_WeightedField> get fields => [
        _WeightedField(text: classModel.title, weight: 3),
        _WeightedField(text: classModel.type, weight: 2),
        _WeightedField(text: classModel.level, weight: 1.5),
        _WeightedField(text: classModel.intensity, weight: 1.2),
        _WeightedField(text: classModel.description, weight: 1),
        _WeightedField(text: gymName, weight: 1.5),
        _WeightedField(text: trainerName, weight: 1.5),
        _WeightedField(text: classModel.requirements.join(' '), weight: 1.1),
      ];
}

class IndexService {
  Map<String, ClassIndexEntry> buildClassIndex({
    required Iterable<ClassModel> classes,
    required Iterable<GymModel> gyms,
    required Iterable<TrainerModel> trainers,
  }) {
    final gymById = {for (final gym in gyms) gym.id: gym.name};
    final trainerById = {for (final trainer in trainers) trainer.id: trainer.name};
    final map = <String, ClassIndexEntry>{};
    for (final item in classes) {
      map[item.id] = ClassIndexEntry(
        classModel: item,
        gymName: gymById[item.gymId] ?? '',
        trainerName: trainerById[item.trainerId] ?? '',
      );
    }
    return map;
  }

  List<ClassModel> searchClasses(
    Map<String, ClassIndexEntry> index,
    String query,
  ) {
    if (query.trim().isEmpty) {
      return index.values.map((e) => e.classModel).toList();
    }
    final terms = query.toLowerCase().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    final scores = <String, double>{};
    for (final entry in index.entries) {
      double score = 0;
      for (final term in terms) {
        for (final field in entry.value.fields) {
          if (field.text.isEmpty) continue;
          if (field.text.toLowerCase().contains(term)) {
            score += field.weight;
          }
        }
      }
      if (score > 0) {
        scores[entry.key] = score;
      }
    }
    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.map((e) => index[e.key]!.classModel).toList();
  }
}

class _WeightedField {
  const _WeightedField({required this.text, required this.weight});

  final String text;
  final double weight;
}
