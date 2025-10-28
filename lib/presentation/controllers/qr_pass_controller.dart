import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'mixins/guarded_controller_mixin.dart';

class QrPassController extends GetxController with GuardedControllerMixin {
  final RxString token = ''.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _generateToken();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _generateToken());
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void refresh() => _generateToken();

  void _generateToken() {
    final random = Random();
    final part = () => List.generate(4, (_) => random.nextInt(10)).join();
    token.value = 'PASS-${part()}-${part()}';
  }

  List<List<bool>> buildPixelGrid() {
    final random = Random(token.value.hashCode);
    return List.generate(10, (_) {
      return List.generate(10, (_) => random.nextBool());
    });
  }
}
