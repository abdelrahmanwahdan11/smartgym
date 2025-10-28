import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../data/models/sleep_plan_model.dart';

class SleepController extends GetxController {
  final Rx<SleepPlanModel> plan = SleepPlanModel(bedtime: '22:30', wakeTime: '06:30').obs;
  final RxBool alarmEnabled = false.obs;
  final RxInt alarmCountdown = 0.obs;

  Timer? _alarmTimer;

  static const _planKey = 'sleep.plan';
  static const _alarmKey = 'sleep.alarm';

  final List<String> tips = const [
    'Limit screens 60 minutes before bed',
    'Keep room cool and dark',
    'Hydrate earlier in the day',
  ];

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    final raw = AppInitializer.prefs.getString(_planKey);
    if (raw != null && raw.isNotEmpty) {
      plan.value = SleepPlanModel.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    }
    alarmEnabled.value = AppInitializer.prefs.getBool(_alarmKey) ?? false;
    if (alarmEnabled.value) {
      _startAlarmTimer();
    }
  }

  Future<void> setBedtime(String value) async {
    plan.value = plan.value.copyWith(bedtime: value);
    await _persist();
  }

  Future<void> setWakeTime(String value) async {
    plan.value = plan.value.copyWith(wakeTime: value);
    await _persist();
  }

  Future<void> updateNotes(String value) async {
    plan.value = plan.value.copyWith(notes: value);
    await _persist();
  }

  Future<void> toggleAlarm(bool value) async {
    alarmEnabled.value = value;
    await AppInitializer.prefs.setBool(_alarmKey, value);
    if (value) {
      _startAlarmTimer();
    } else {
      _stopAlarmTimer();
    }
  }

  void _startAlarmTimer() {
    _alarmTimer?.cancel();
    alarmCountdown.value = 900;
    _alarmTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!alarmEnabled.value) {
        _stopAlarmTimer();
        return;
      }
      if (alarmCountdown.value > 0) {
        alarmCountdown.value -= 1;
      } else {
        Get.snackbar('sleep_coach'.tr, 'wake_time'.tr);
        alarmCountdown.value = 900;
      }
    });
  }

  void _stopAlarmTimer() {
    _alarmTimer?.cancel();
    _alarmTimer = null;
  }

  Future<void> _persist() async {
    await AppInitializer.prefs.setString(_planKey, jsonEncode(plan.value.toMap()));
  }

  @override
  void onClose() {
    _stopAlarmTimer();
    super.onClose();
  }
}
