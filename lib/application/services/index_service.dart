import '../../data/models/class_model.dart';
import '../../data/models/gym_model.dart';
import '../../data/models/product_model.dart';
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

class GymIndexEntry {
  GymIndexEntry({required this.gym});

  final GymModel gym;

  Iterable<_WeightedField> get fields => [
        _WeightedField(text: gym.name, weight: 3),
        _WeightedField(text: gym.locationText, weight: 1.5),
        _WeightedField(text: gym.amenities.join(' '), weight: 1.2),
        _WeightedField(text: gym.equipment.join(' '), weight: 1.1),
      ];
}

class TrainerIndexEntry {
  TrainerIndexEntry({required this.trainer});

  final TrainerModel trainer;

  Iterable<_WeightedField> get fields => [
        _WeightedField(text: trainer.name, weight: 3),
        _WeightedField(text: trainer.specialties.join(' '), weight: 2),
        _WeightedField(text: trainer.certifications.join(' '), weight: 1.5),
        _WeightedField(text: trainer.bio, weight: 1),
      ];
}

class ProductIndexEntry {
  ProductIndexEntry({required this.product});

  final ProductModel product;

  Iterable<_WeightedField> get fields => [
        _WeightedField(text: product.name, weight: 2.5),
        _WeightedField(text: product.category, weight: 1.5),
        _WeightedField(text: product.tags.join(' '), weight: 1.2),
        _WeightedField(text: product.details, weight: 1),
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

  Map<String, GymIndexEntry> buildGymIndex(Iterable<GymModel> gyms) => {
        for (final gym in gyms) gym.id: GymIndexEntry(gym: gym)
      };

  Map<String, TrainerIndexEntry> buildTrainerIndex(Iterable<TrainerModel> trainers) => {
        for (final trainer in trainers) trainer.id: TrainerIndexEntry(trainer: trainer)
      };

  Map<String, ProductIndexEntry> buildProductIndex(Iterable<ProductModel> products) => {
        for (final product in products) product.id: ProductIndexEntry(product: product)
      };

  List<ClassModel> searchClasses(
    Map<String, ClassIndexEntry> index,
    Iterable<String> terms,
  ) {
    final scores = _score(index, terms, (entry) => entry.fields);
    return scores.map((e) => index[e.key]!.classModel).toList();
  }

  List<GymModel> searchGyms(
    Map<String, GymIndexEntry> index,
    Iterable<String> terms,
  ) {
    final scores = _score(index, terms, (entry) => entry.fields);
    return scores.map((e) => index[e.key]!.gym).toList();
  }

  List<TrainerModel> searchTrainers(
    Map<String, TrainerIndexEntry> index,
    Iterable<String> terms,
  ) {
    final scores = _score(index, terms, (entry) => entry.fields);
    return scores.map((e) => index[e.key]!.trainer).toList();
  }

  List<ProductModel> searchProducts(
    Map<String, ProductIndexEntry> index,
    Iterable<String> terms,
  ) {
    final scores = _score(index, terms, (entry) => entry.fields);
    return scores.map((e) => index[e.key]!.product).toList();
  }

  List<MapEntry<String, double>> _score<T>(
    Map<String, T> index,
    Iterable<String> terms,
    Iterable<_WeightedField> Function(T entry) selector,
  ) {
    final filteredTerms = terms.map((e) => e.toLowerCase()).where((e) => e.isNotEmpty).toSet();
    if (filteredTerms.isEmpty) {
      return index.keys.map((e) => MapEntry(e, 0)).toList();
    }

    final docFrequency = <String, int>{for (final term in filteredTerms) term: 0};
    for (final entry in index.entries) {
      for (final term in filteredTerms) {
        final hasTerm = selector(entry.value).any(
          (field) => field.text.toLowerCase().contains(term),
        );
        if (hasTerm) {
          docFrequency[term] = (docFrequency[term] ?? 0) + 1;
        }
      }
    }

    final scores = <String, double>{};
    for (final entry in index.entries) {
      double score = 0;
      for (final term in filteredTerms) {
        for (final field in selector(entry.value)) {
          final text = field.text.toLowerCase();
          if (!text.contains(term)) continue;
          final tf = _termFrequency(text, term);
          final df = (docFrequency[term] ?? 1).toDouble();
          score += (tf * field.weight) / (1 + df);
        }
      }
      if (score > 0) {
        scores[entry.key] = score;
      }
    }
    final ranked = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return ranked;
  }

  double _termFrequency(String text, String term) {
    final occurrences = RegExp(term).allMatches(text).length;
    if (occurrences == 0) return 0;
    return 1 + (occurrences - 1) * 0.5;
  }
}

class _WeightedField {
  const _WeightedField({required this.text, required this.weight});

  final String text;
  final double weight;
}
