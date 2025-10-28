import 'package:get/get.dart';

import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../data/repositories/gyms_repository.dart';
import '../controllers/gyms_controller.dart';

class GymsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GymsRepository>()) {
      Get.lazyPut(() => GymsRepository());
    }
    if (!Get.isRegistered<GymsController>()) {
      Get.lazyPut(() => GymsController(
            Get.find<GymsRepository>(),
            Get.find<SearchService>(),
            Get.find<PaginationService>(),
          ));
    }
  }
}
