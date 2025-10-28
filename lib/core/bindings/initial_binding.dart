import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/index_service.dart';
import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../core/app_initializer.dart';
import '../../data/repositories/classes_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/cart_controller.dart';
import '../../presentation/controllers/buddy_controller.dart';
import '../../presentation/controllers/challenges_controller.dart';
import '../../presentation/controllers/communities_controller.dart';
import '../../presentation/controllers/diet_controller.dart';
import '../../presentation/controllers/feature_flags_controller.dart';
import '../../presentation/controllers/hydration_controller.dart';
import '../../presentation/controllers/pagination_controller.dart';
import '../../presentation/controllers/program_controller.dart';
import '../../presentation/controllers/search_controller.dart';
import '../../presentation/controllers/share_card_controller.dart';
import '../../presentation/controllers/qr_pass_controller.dart';
import '../../presentation/controllers/inbody_controller.dart';
import '../../presentation/controllers/injury_controller.dart';
import '../../presentation/controllers/schedule_controller.dart';
import '../../presentation/controllers/sleep_controller.dart';
import '../../presentation/controllers/reminders_controller.dart';
import '../../presentation/controllers/steps_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IndexService());
    Get.lazyPut(() => SearchService());
    Get.lazyPut(() => PaginationService());
    final actionLog = ActionLogService(AppInitializer.store);
    actionLog.load();
    Get.put(actionLog);
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
    Get.put(FeatureFlagsController());
    Get.put(ProgramController(Get.find<ClassesRepository>()));
    Get.put(HydrationController());
    Get.put(DietController());
    Get.put(StepsController());
    Get.put(SleepController());
    Get.put(InjuryController());
    Get.put(ChallengesController());
    Get.put(CommunitiesController());
    Get.put(BuddyController());
  }
}
