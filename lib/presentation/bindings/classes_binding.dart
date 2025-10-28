import 'package:get/get.dart';

import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../data/repositories/classes_repository.dart';
import '../controllers/classes_controller.dart';

class ClassesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ClassesRepository>()) {
      Get.lazyPut(() => ClassesRepository());
    }
    if (!Get.isRegistered<ClassesController>()) {
      Get.lazyPut(() => ClassesController(
            Get.find<ClassesRepository>(),
            Get.find<SearchService>(),
            Get.find<PaginationService>(),
          ));
    }
  }
}
