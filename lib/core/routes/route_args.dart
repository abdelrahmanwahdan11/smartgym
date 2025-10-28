import '../../data/models/class_model.dart';
import '../../data/models/gym_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/trainer_model.dart';

String _readId(Map<String, String?> parameters, dynamic arguments) {
  final fromParams = parameters['id'];
  if (fromParams != null && fromParams.isNotEmpty) {
    return fromParams;
  }
  if (arguments is Map<String, dynamic>) {
    final id = arguments['id'];
    if (id is String && id.isNotEmpty) {
      return id;
    }
  }
  if (arguments is ClassModel) return arguments.id;
  if (arguments is GymModel) return arguments.id;
  if (arguments is TrainerModel) return arguments.id;
  if (arguments is ProductModel) return arguments.id;
  throw ArgumentError('Route id missing');
}

class ClassDetailsArgs {
  ClassDetailsArgs({required this.id, this.initial});

  final String id;
  final ClassModel? initial;

  factory ClassDetailsArgs.from(Map<String, String?> parameters, dynamic arguments) {
    final id = _readId(parameters, arguments);
    return ClassDetailsArgs(
      id: id,
      initial: arguments is ClassModel ? arguments : null,
    );
  }
}

class GymDetailsArgs {
  GymDetailsArgs({required this.id, this.initial});

  final String id;
  final GymModel? initial;

  factory GymDetailsArgs.from(Map<String, String?> parameters, dynamic arguments) {
    final id = _readId(parameters, arguments);
    return GymDetailsArgs(
      id: id,
      initial: arguments is GymModel ? arguments : null,
    );
  }
}

class TrainerDetailsArgs {
  TrainerDetailsArgs({required this.id, this.initial});

  final String id;
  final TrainerModel? initial;

  factory TrainerDetailsArgs.from(Map<String, String?> parameters, dynamic arguments) {
    final id = _readId(parameters, arguments);
    return TrainerDetailsArgs(
      id: id,
      initial: arguments is TrainerModel ? arguments : null,
    );
  }
}

class ProductDetailsArgs {
  ProductDetailsArgs({required this.id, this.initial});

  final String id;
  final ProductModel? initial;

  factory ProductDetailsArgs.from(Map<String, String?> parameters, dynamic arguments) {
    final id = _readId(parameters, arguments);
    return ProductDetailsArgs(
      id: id,
      initial: arguments is ProductModel ? arguments : null,
    );
  }
}
