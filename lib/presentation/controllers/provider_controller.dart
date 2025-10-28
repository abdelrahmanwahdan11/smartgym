import 'package:get/get.dart';

import '../../application/services/roles_service.dart';
import '../../data/models/class_model.dart';
import '../../data/models/gym_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/provider_change_model.dart';
import '../../data/models/trainer_model.dart';
import '../../data/repositories/provider_repository.dart';
import 'mixins/guarded_controller_mixin.dart';

class ProviderController extends GetxController with GuardedControllerMixin {
  ProviderController(this._repository, this._rolesService);

  final ProviderRepository _repository;
  final RolesService _rolesService;

  final RxList<GymModel> gyms = <GymModel>[].obs;
  final RxList<TrainerModel> trainers = <TrainerModel>[].obs;
  final RxList<ClassModel> classes = <ClassModel>[].obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  final RxList<ProviderChangeModel> _undoStack = <ProviderChangeModel>[].obs;
  final RxList<ProviderChangeModel> _redoStack = <ProviderChangeModel>[].obs;

  bool get canEdit => _rolesService.hasRole('gym_admin') || _rolesService.hasRole('admin');

  @override
  void onInit() {
    super.onInit();
    _refresh();
  }

  Future<void> _refresh() async {
    gyms.assignAll(_repository.overlayGyms());
    trainers.assignAll(_repository.overlayTrainers());
    classes.assignAll(_repository.overlayClasses());
    products.assignAll(_repository.overlayProducts());
  }

  Future<void> upsertGym(GymModel model) async {
    if (!canEdit) return;
    await _repository.upsertGym(model);
    _record('gym', 'upsert', model.toMap());
    await _refresh();
  }

  Future<void> upsertTrainer(TrainerModel model) async {
    if (!canEdit) return;
    await _repository.upsertTrainer(model);
    _record('trainer', 'upsert', model.toMap());
    await _refresh();
  }

  Future<void> upsertClass(ClassModel model) async {
    if (!canEdit) return;
    await _repository.upsertClass(model);
    _record('class', 'upsert', model.toMap());
    await _refresh();
  }

  Future<void> upsertProduct(ProductModel model) async {
    if (!canEdit) return;
    await _repository.upsertProduct(model);
    _record('product', 'upsert', model.toMap());
    await _refresh();
  }

  Future<void> deleteGym(String id) async {
    if (!canEdit) return;
    final snapshot = _findSnapshot(gyms, id, (gym) => gym.toMap());
    await _repository.deleteGym(id);
    if (snapshot != null) {
      _record('gym', 'delete', snapshot);
    }
    await _refresh();
  }

  Future<void> deleteTrainer(String id) async {
    if (!canEdit) return;
    final snapshot = _findSnapshot(trainers, id, (trainer) => trainer.toMap());
    await _repository.deleteTrainer(id);
    if (snapshot != null) {
      _record('trainer', 'delete', snapshot);
    }
    await _refresh();
  }

  Future<void> deleteClass(String id) async {
    if (!canEdit) return;
    final snapshot = _findSnapshot(classes, id, (klass) => klass.toMap());
    await _repository.deleteClass(id);
    if (snapshot != null) {
      _record('class', 'delete', snapshot);
    }
    await _refresh();
  }

  Future<void> deleteProduct(String id) async {
    if (!canEdit) return;
    final snapshot = _findSnapshot(products, id, (product) => product.toMap());
    await _repository.deleteProduct(id);
    if (snapshot != null) {
      _record('product', 'delete', snapshot);
    }
    await _refresh();
  }

  Future<void> undo() async {
    if (_undoStack.isEmpty) return;
    final change = _undoStack.removeLast();
    _redoStack.add(change);
    switch (change.entity) {
      case 'gym':
        if (change.operation == 'delete') {
          await _repository.upsertGym(GymModel.fromMap(change.snapshot));
        } else {
          await _repository.deleteGym(change.snapshot['id'] as String);
        }
        break;
      case 'trainer':
        if (change.operation == 'delete') {
          await _repository.upsertTrainer(TrainerModel.fromMap(change.snapshot));
        } else {
          await _repository.deleteTrainer(change.snapshot['id'] as String);
        }
        break;
      case 'class':
        if (change.operation == 'delete') {
          await _repository.upsertClass(ClassModel.fromMap(change.snapshot));
        } else {
          await _repository.deleteClass(change.snapshot['id'] as String);
        }
        break;
      case 'product':
        if (change.operation == 'delete') {
          await _repository.upsertProduct(ProductModel.fromMap(change.snapshot));
        } else {
          await _repository.deleteProduct(change.snapshot['id'] as String);
        }
        break;
    }
    await _refresh();
  }

  Future<void> redo() async {
    if (_redoStack.isEmpty) return;
    final change = _redoStack.removeLast();
    switch (change.entity) {
      case 'gym':
        if (change.operation == 'delete') {
          await _repository.deleteGym(change.snapshot['id'] as String);
        } else {
          await _repository.upsertGym(GymModel.fromMap(change.snapshot));
        }
        break;
      case 'trainer':
        if (change.operation == 'delete') {
          await _repository.deleteTrainer(change.snapshot['id'] as String);
        } else {
          await _repository.upsertTrainer(TrainerModel.fromMap(change.snapshot));
        }
        break;
      case 'class':
        if (change.operation == 'delete') {
          await _repository.deleteClass(change.snapshot['id'] as String);
        } else {
          await _repository.upsertClass(ClassModel.fromMap(change.snapshot));
        }
        break;
      case 'product':
        if (change.operation == 'delete') {
          await _repository.deleteProduct(change.snapshot['id'] as String);
        } else {
          await _repository.upsertProduct(ProductModel.fromMap(change.snapshot));
        }
        break;
    }
    await _refresh();
  }

  Future<String> exportOverlay() => _repository.exportOverlay();

  Future<void> importOverlay(String json) async {
    await _repository.importOverlay(json);
    await _refresh();
  }

  void _record(String entity, String op, Map<String, dynamic> snapshot) {
    _undoStack.add(ProviderChangeModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      entity: entity,
      operation: op,
      snapshot: snapshot,
      date: DateTime.now(),
    ));
    _redoStack.clear();
  }

  Map<String, dynamic>? _findSnapshot<T>(
    List<T> items,
    String id,
    Map<String, dynamic> Function(T) mapper,
  ) {
    for (final item in items) {
      final dynamic dynamicItem = item;
      if (dynamicItem.id == id) {
        return mapper(item);
      }
    }
    return null;
  }
}
