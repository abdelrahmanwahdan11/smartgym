import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../core/constants.dart';
import 'mixins/guarded_controller_mixin.dart';

class SecurityController extends GetxController with GuardedControllerMixin {
  final pinEnabled = false.obs;
  final remainingAttempts = 5.obs;

  DateTime? _lockedUntil;
  String _hash = '';

  @override
  void onInit() {
    super.onInit();
    pinEnabled.value = AppInitializer.prefs.getBool('pin.enabled') ?? false;
    _hash = AppInitializer.prefs.getString('pin.code_hash') ?? '';
  }

  bool get isLocked {
    final until = _lockedUntil;
    if (until == null) return false;
    if (DateTime.now().isAfter(until)) {
      _lockedUntil = null;
      remainingAttempts.value = 5;
      return false;
    }
    return true;
  }

  Future<void> setPin(String pin) async {
    _hash = _simpleHash(pin);
    pinEnabled.value = true;
    remainingAttempts.value = 5;
    await AppInitializer.prefs.setBool('pin.enabled', true);
    await AppInitializer.prefs.setString('pin.code_hash', _hash);
  }

  Future<void> disablePin() async {
    pinEnabled.value = false;
    _hash = '';
    await AppInitializer.prefs.setBool('pin.enabled', false);
    await AppInitializer.prefs.setString('pin.code_hash', '');
  }

  Future<bool> verify(String pin) async {
    if (!pinEnabled.value) return true;
    if (isLocked) {
      return false;
    }
    final hashed = _simpleHash(pin);
    if (hashed == _hash) {
      remainingAttempts.value = 5;
      return true;
    }
    remainingAttempts.value = remainingAttempts.value - 1;
    if (remainingAttempts.value <= 0) {
      _lockedUntil = DateTime.now().add(AppConstants.pinCooldown);
    }
    return false;
  }

  String _simpleHash(String value) {
    var hash = 0;
    for (final code in value.codeUnits) {
      hash = (hash + code * 31) % 0xFFFFFF;
    }
    return hash.toRadixString(16);
  }
}
