import 'package:get/get.dart';

import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/repositories/gyms_repository.dart';
import '../../data/repositories/trainers_repository.dart';
import '../controllers/classes_controller.dart';
import '../controllers/gyms_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/trainers_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ClassesRepository>()) {
      Get.lazyPut(() => ClassesRepository());
    }
    if (!Get.isRegistered<GymsRepository>()) {
      Get.lazyPut(() => GymsRepository());
    }
    if (!Get.isRegistered<TrainersRepository>()) {
      Get.lazyPut(() => TrainersRepository());
    }
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut(() => HomeController(
            Get.find<ClassesRepository>(),
            Get.find<GymsRepository>(),
            Get.find<TrainersRepository>(),
          ));
    }
    if (!Get.isRegistered<ClassesController>()) {
      Get.lazyPut(() => ClassesController(
            Get.find<ClassesRepository>(),
            Get.find<SearchService>(),
            Get.find<PaginationService>(),
          ));
    }
    if (!Get.isRegistered<GymsController>()) {
      Get.lazyPut(() => GymsController(
            Get.find<GymsRepository>(),
            Get.find<SearchService>(),
            Get.find<PaginationService>(),
          ));
    }
    if (!Get.isRegistered<TrainersController>()) {
      Get.lazyPut(() => TrainersController(
            Get.find<TrainersRepository>(),
            Get.find<SearchService>(),
            Get.find<PaginationService>(),
          ));
    }
  }
}
