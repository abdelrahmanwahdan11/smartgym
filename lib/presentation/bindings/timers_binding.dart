import 'package:get/get.dart';

import '../controllers/timers_controller.dart';

class TimersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TimersController());
  }
}
