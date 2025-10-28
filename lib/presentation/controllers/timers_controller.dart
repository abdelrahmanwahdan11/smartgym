import 'dart:async';

import 'package:get/get.dart';

enum TimerMode { hiit, emom, amrap, tabata }

class TimersController extends GetxController {
  final Rx<TimerMode> mode = TimerMode.hiit.obs;
  final RxInt workSeconds = 45.obs;
  final RxInt restSeconds = 15.obs;
  final RxInt rounds = 8.obs;
  final RxInt currentRound = 1.obs;
  final RxBool isWorkPhase = true.obs;
  final RxInt timeLeft = 45.obs;
  final RxBool isRunning = false.obs;

  Timer? _ticker;

  void setMode(TimerMode newMode) {
    mode.value = newMode;
    switch (newMode) {
      case TimerMode.hiit:
        workSeconds.value = 45;
        restSeconds.value = 15;
        rounds.value = 8;
        break;
      case TimerMode.emom:
        workSeconds.value = 60;
        restSeconds.value = 0;
        rounds.value = 10;
        break;
      case TimerMode.amrap:
        workSeconds.value = 300;
        restSeconds.value = 0;
        rounds.value = 1;
        break;
      case TimerMode.tabata:
        workSeconds.value = 20;
        restSeconds.value = 10;
        rounds.value = 8;
        break;
    }
    reset();
  }

  void setWorkSeconds(int value) {
    workSeconds.value = value.clamp(5, 3600);
    if (!isRunning.value && isWorkPhase.value) {
      timeLeft.value = workSeconds.value;
    }
  }

  void setRestSeconds(int value) {
    restSeconds.value = value.clamp(0, 3600);
    if (!isRunning.value && !isWorkPhase.value) {
      timeLeft.value = restSeconds.value;
    }
  }

  void setRounds(int value) {
    rounds.value = value.clamp(1, 99);
    if (currentRound.value > rounds.value) {
      currentRound.value = rounds.value;
    }
  }

  void start() {
    if (isRunning.value) return;
    isRunning.value = true;
    if (timeLeft.value <= 0) {
      timeLeft.value = isWorkPhase.value ? workSeconds.value : restSeconds.value;
    }
    _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void stop() {
    _ticker?.cancel();
    _ticker = null;
    isRunning.value = false;
  }

  void reset() {
    stop();
    currentRound.value = 1;
    isWorkPhase.value = true;
    timeLeft.value = workSeconds.value;
  }

  void _onTick() {
    if (timeLeft.value > 0) {
      timeLeft.value -= 1;
      return;
    }

    if (isWorkPhase.value) {
      if (restSeconds.value > 0) {
        isWorkPhase.value = false;
        timeLeft.value = restSeconds.value;
        return;
      }
      _advanceRound();
    } else {
      _advanceRound();
    }
  }

  void _advanceRound() {
    final nextRound = currentRound.value + 1;
    if (nextRound > rounds.value) {
      stop();
      Get.snackbar('timers'.tr, 'success'.tr);
      reset();
      return;
    }

    currentRound.value = nextRound;
    isWorkPhase.value = true;
    timeLeft.value = workSeconds.value;
  }

  @override
  void onClose() {
    stop();
    super.onClose();
  }
}
