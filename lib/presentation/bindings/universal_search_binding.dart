import 'package:get/get.dart';

import '../../application/services/index_service.dart';
import '../../application/services/synonyms_service.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/repositories/gyms_repository.dart';
import '../../data/repositories/products_repository.dart';
import '../../data/repositories/trainers_repository.dart';
import '../controllers/universal_search_controller.dart';

class UniversalSearchBinding extends Bindings {
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
    if (!Get.isRegistered<ProductsRepository>()) {
      Get.lazyPut(() => ProductsRepository());
    }
    Get.lazyPut(
      () => UniversalSearchController(
        Get.find<ClassesRepository>(),
        Get.find<GymsRepository>(),
        Get.find<TrainersRepository>(),
        Get.find<ProductsRepository>(),
        Get.find<IndexService>(),
        Get.find<SynonymsService>(),
      ),
    );
  }
}
