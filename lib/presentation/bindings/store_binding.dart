import 'package:get/get.dart';

import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../data/repositories/products_repository.dart';
import '../controllers/store_controller.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProductsRepository>()) {
      Get.lazyPut(() => ProductsRepository());
    }
    if (!Get.isRegistered<StoreController>()) {
      Get.lazyPut(() => StoreController(
            Get.find<ProductsRepository>(),
            Get.find<SearchService>(),
            Get.find<PaginationService>(),
          ));
    }
  }
}
