import 'package:get/get.dart';

import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../data/repositories/trainers_repository.dart';
import '../controllers/trainers_controller.dart';

class TrainersBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TrainersRepository>()) {
      Get.lazyPut(() => TrainersRepository());
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
