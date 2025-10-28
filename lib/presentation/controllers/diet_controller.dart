import 'dart:convert';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../data/models/grocery_item_model.dart';
import '../../data/models/macro_plan_model.dart';
import 'inbody_controller.dart';

class DietController extends GetxController {
  final InBodyController _inBodyController = Get.find();

  final Rx<MacroPlanModel> macroPlan =
      MacroPlanModel(proteinG: 120, carbsG: 220, fatG: 70, calories: 2200, template: 'custom').obs;
  final RxList<GroceryItemModel> groceryItems = <GroceryItemModel>[].obs;

  static const _macroKey = 'diet.macros';
  static const _groceryKey = 'diet.grocery';

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    final macroRaw = AppInitializer.prefs.getString(_macroKey);
    if (macroRaw != null && macroRaw.isNotEmpty) {
      final map = jsonDecode(macroRaw) as Map<String, dynamic>;
      macroPlan.value = MacroPlanModel.fromMap(map);
    } else {
      _recalculate('custom');
    }
    final groceryRaw = AppInitializer.prefs.getString(_groceryKey);
    if (groceryRaw != null && groceryRaw.isNotEmpty) {
      final list = (jsonDecode(groceryRaw) as List<dynamic>)
          .map((e) => GroceryItemModel.fromMap(e as Map<String, dynamic>))
          .toList();
      groceryItems.assignAll(list);
    }
  }

  Future<void> applyTemplate(String template) async {
    _recalculate(template);
    await _persistMacros();
  }

  void _recalculate(String template) {
    final weight = _inBodyController.latestWeight == 0 ? 70 : _inBodyController.latestWeight;
    final baseCalories = (weight * 30).round();
    int targetCalories = baseCalories;
    Map<String, double> ratios;
    switch (template) {
      case 'cut':
        targetCalories = (baseCalories - 400).clamp(1200, 3500);
        ratios = {'protein': 0.35, 'carbs': 0.35, 'fat': 0.3};
        break;
      case 'bulk':
        targetCalories = (baseCalories + 300).clamp(1500, 4000);
        ratios = {'protein': 0.3, 'carbs': 0.45, 'fat': 0.25};
        break;
      case 'keto':
        ratios = {'protein': 0.2, 'carbs': 0.1, 'fat': 0.7};
        break;
      case 'if':
        ratios = {'protein': 0.33, 'carbs': 0.42, 'fat': 0.25};
        break;
      default:
        ratios = {'protein': 0.3, 'carbs': 0.45, 'fat': 0.25};
        break;
    }
    final protein = ((targetCalories * ratios['protein']!) / 4).round();
    final carbs = ((targetCalories * ratios['carbs']!) / 4).round();
    final fat = ((targetCalories * ratios['fat']!) / 9).round();
    macroPlan.value = MacroPlanModel(
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      calories: targetCalories,
      template: template,
    );
  }

  Future<void> addItem(String title) async {
    final item = GroceryItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    groceryItems.add(item);
    await _persistGrocery();
  }

  Future<void> toggleItem(String id) async {
    final index = groceryItems.indexWhere((element) => element.id == id);
    if (index == -1) return;
    final item = groceryItems[index];
    groceryItems[index] = item.copyWith(checked: !item.checked);
    await _persistGrocery();
  }

  Future<void> removeItem(String id) async {
    groceryItems.removeWhere((element) => element.id == id);
    await _persistGrocery();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = groceryItems.removeAt(oldIndex);
    groceryItems.insert(newIndex, item);
    await _persistGrocery();
  }

  Future<void> _persistMacros() async {
    await AppInitializer.prefs.setString(_macroKey, jsonEncode(macroPlan.value.toMap()));
  }

  Future<void> _persistGrocery() async {
    await AppInitializer.prefs
        .setString(_groceryKey, jsonEncode(groceryItems.map((e) => e.toMap()).toList()));
  }
}
