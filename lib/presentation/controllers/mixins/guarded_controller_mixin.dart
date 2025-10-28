import 'dart:async';

import 'package:get/get.dart';

mixin GuardedControllerMixin on GetxController {
  bool _isDisposed = false;
  final List<Timer> _timers = <Timer>[];

  @override
  void onClose() {
    markDisposed();
    super.onClose();
  }

  void markDisposed() {
    _isDisposed = true;
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }

  T guard<T>(T Function() action) {
    if (_isDisposed) {
      throw StateError('Controller disposed');
    }
    return action();
  }

  Timer registerTimer(Timer timer) {
    if (_isDisposed) {
      timer.cancel();
      return timer;
    }
    _timers.add(timer);
    return timer;
  }

  bool get isDisposed => _isDisposed;
}
