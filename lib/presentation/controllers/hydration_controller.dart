import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../data/models/hydration_log_model.dart';

class HydrationController extends GetxController {
  final RxDouble goalLiters = 2.5.obs;
  final RxInt todayTotal = 0.obs;
  final RxList<HydrationLogModel> logs = <HydrationLogModel>[].obs;
  final RxBool reminderEnabled = false.obs;
  final RxInt reminderCountdown = 0.obs;

  Timer? _reminderTimer;

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    goalLiters.value = AppInitializer.prefs.getDouble('hydration.goal') ?? 2.5;
    reminderEnabled.value = AppInitializer.prefs.getBool('hydration.reminder') ?? false;
    final raw = AppInitializer.prefs.getString('hydration.logs');
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => HydrationLogModel.fromMap(e as Map<String, dynamic>))
          .toList();
      logs.assignAll(list);
    }
    _ensureTodayEntry();
    if (reminderEnabled.value) {
      _startTimer();
    }
  }

  void _ensureTodayEntry() {
    final today = DateTime.now();
    final existing = logs.firstWhereOrNull((element) => _isSameDay(element.date, today));
    if (existing == null) {
      final entry = HydrationLogModel(date: DateTime(today.year, today.month, today.day), mlTotal: 0);
      logs.add(entry);
      _persistLogs();
      todayTotal.value = 0;
    } else {
      todayTotal.value = existing.mlTotal;
    }
  }

  Future<void> setGoal(double liters) async {
    goalLiters.value = liters;
    await AppInitializer.prefs.setDouble('hydration.goal', liters);
  }

  Future<void> logWater(int ml) async {
    _ensureTodayEntry();
    final today = DateTime.now();
    final index = logs.indexWhere((element) => _isSameDay(element.date, today));
    if (index == -1) return;
    final current = logs[index];
    final updated = current.copyWith(mlTotal: current.mlTotal + ml);
    logs[index] = updated;
    todayTotal.value = updated.mlTotal;
    await _persistLogs();
  }

  Future<void> toggleReminder(bool value) async {
    reminderEnabled.value = value;
    await AppInitializer.prefs.setBool('hydration.reminder', value);
    if (value) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    reminderCountdown.value = 1800;
    _reminderTimer?.cancel();
    _reminderTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!reminderEnabled.value) {
        _stopTimer();
        return;
      }
      if (reminderCountdown.value > 0) {
        reminderCountdown.value -= 1;
      } else {
        Get.snackbar('hydration'.tr, 'log_water'.tr);
        reminderCountdown.value = 1800;
      }
    });
  }

  void _stopTimer() {
    _reminderTimer?.cancel();
    _reminderTimer = null;
  }

  Future<void> _persistLogs() async {
    final encoded = jsonEncode(logs.map((e) => e.toMap()).toList());
    await AppInitializer.prefs.setString('hydration.logs', encoded);
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}
