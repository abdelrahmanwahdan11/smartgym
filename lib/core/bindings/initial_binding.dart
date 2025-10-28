import 'package:get/get.dart';

import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../data/repositories/classes_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/cart_controller.dart';
import '../../presentation/controllers/pagination_controller.dart';
import '../../presentation/controllers/search_controller.dart';
import '../../presentation/controllers/share_card_controller.dart';
import '../../presentation/controllers/qr_pass_controller.dart';
import '../../presentation/controllers/inbody_controller.dart';
import '../../presentation/controllers/schedule_controller.dart';
import '../../presentation/controllers/reminders_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchService());
    Get.lazyPut(() => PaginationService());
    Get.lazyPut(() => ClassesRepository());
    Get.put(AppSearchController(Get.find()));
    Get.put(AppPaginationController(Get.find()));
    Get.put(AuthController());
    Get.put(CartController());
    Get.put(ShareCardController());
    Get.put(QrPassController());
    Get.put(InBodyController());
    Get.put(ScheduleController(Get.find<ClassesRepository>()));
    Get.put(RemindersController());
  }
}
