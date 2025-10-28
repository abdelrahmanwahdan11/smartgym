import 'dart:convert';

import '../local_data/local_store.dart';
import '../models/class_model.dart';
import '../models/gym_model.dart';
import '../models/product_model.dart';
import '../models/trainer_model.dart';

class ProviderRepository {
  ProviderRepository(this.store);

  final LocalStore store;

  static const _gymKey = 'provider.gyms';
  static const _trainerKey = 'provider.trainers';
  static const _classKey = 'provider.classes';
  static const _productKey = 'provider.products';

  Map<String, dynamic> _read(String key) => store.getJson(key) ?? <String, dynamic>{};

  Future<void> _write(String key, Map<String, dynamic> value) => store.setJson(key, value);

  List<GymModel> overlayGyms() => _read(_gymKey)
      .values
      .whereType<Map<String, dynamic>>()
      .map(GymModel.fromMap)
      .toList();

  List<TrainerModel> overlayTrainers() => _read(_trainerKey)
      .values
      .whereType<Map<String, dynamic>>()
      .map(TrainerModel.fromMap)
      .toList();

  List<ClassModel> overlayClasses() => _read(_classKey)
      .values
      .whereType<Map<String, dynamic>>()
      .map(ClassModel.fromMap)
      .toList();

  List<ProductModel> overlayProducts() => _read(_productKey)
      .values
      .whereType<Map<String, dynamic>>()
      .map(ProductModel.fromMap)
      .toList();

  Future<void> upsertGym(GymModel model) async {
    final current = _read(_gymKey);
    current[model.id] = model.toMap();
    await _write(_gymKey, current);
  }

  Future<void> upsertTrainer(TrainerModel model) async {
    final current = _read(_trainerKey);
    current[model.id] = model.toMap();
    await _write(_trainerKey, current);
  }

  Future<void> upsertClass(ClassModel model) async {
    final current = _read(_classKey);
    current[model.id] = model.toMap();
    await _write(_classKey, current);
  }

  Future<void> upsertProduct(ProductModel model) async {
    final current = _read(_productKey);
    current[model.id] = model.toMap();
    await _write(_productKey, current);
  }

  Future<void> deleteGym(String id) async {
    final current = _read(_gymKey);
    current.remove(id);
    await _write(_gymKey, current);
  }

  Future<void> deleteTrainer(String id) async {
    final current = _read(_trainerKey);
    current.remove(id);
    await _write(_trainerKey, current);
  }

  Future<void> deleteClass(String id) async {
    final current = _read(_classKey);
    current.remove(id);
    await _write(_classKey, current);
  }

  Future<void> deleteProduct(String id) async {
    final current = _read(_productKey);
    current.remove(id);
    await _write(_productKey, current);
  }

  Future<String> exportOverlay() async {
    final payload = {
      _gymKey: _read(_gymKey),
      _trainerKey: _read(_trainerKey),
      _classKey: _read(_classKey),
      _productKey: _read(_productKey),
    };
    return jsonEncode(payload);
  }

  Future<void> importOverlay(String json) async {
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    for (final entry in decoded.entries) {
      final value = (entry.value as Map<String, dynamic>?) ?? <String, dynamic>{};
      await _write(entry.key, value);
    }
  }
}
