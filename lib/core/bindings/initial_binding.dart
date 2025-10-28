import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../application/services/format_service.dart';
import '../../application/services/i18n_audit_service.dart';
import '../../application/services/index_service.dart';
import '../../application/services/moderation_service.dart';
import '../../application/services/pagination_service.dart';
import '../../application/services/roles_service.dart';
import '../../application/services/search_service.dart';
import '../../application/services/synonyms_service.dart';
import '../../core/app_initializer.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/repositories/gyms_repository.dart';
import '../../data/repositories/products_repository.dart';
import '../../data/repositories/provider_repository.dart';
import '../../data/repositories/trainers_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/buddy_controller.dart';
import '../../presentation/controllers/cart_controller.dart';
import '../../presentation/controllers/challenges_controller.dart';
import '../../presentation/controllers/communities_controller.dart';
import '../../presentation/controllers/diet_controller.dart';
import '../../presentation/controllers/feature_flags_controller.dart';
import '../../presentation/controllers/formatting_controller.dart';
import '../../presentation/controllers/hydration_controller.dart';
import '../../presentation/controllers/moderation_controller.dart';
import '../../presentation/controllers/pagination_controller.dart';
import '../../presentation/controllers/program_controller.dart';
import '../../presentation/controllers/provider_controller.dart';
import '../../presentation/controllers/qr_pass_controller.dart';
import '../../presentation/controllers/reminders_controller.dart';
import '../../presentation/controllers/schedule_controller.dart';
import '../../presentation/controllers/search_controller.dart';
import '../../presentation/controllers/security_controller.dart';
import '../../presentation/controllers/share_card_controller.dart';
import '../../presentation/controllers/sleep_controller.dart';
import '../../presentation/controllers/steps_controller.dart';
import '../../presentation/controllers/inbody_controller.dart';
import '../../presentation/controllers/injury_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final store = AppInitializer.store;

    Get.put(SynonymsService());
    Get.lazyPut(() => IndexService());
    Get.lazyPut(() => SearchService(Get.find<SynonymsService>()));
    Get.lazyPut(() => PaginationService());

    final formatService = FormatService(store);
    // ignore: discarded_futures
    formatService.load();
    Get.put(formatService);

    final rolesService = RolesService(store);
    // ignore: discarded_futures
    rolesService.load();
    Get.put(rolesService);

    final actionLog = ActionLogService(store);
    // ignore: discarded_futures
    actionLog.load();
    Get.put(actionLog);

    final moderationService = ModerationService(store);
    // ignore: discarded_futures
    moderationService.load();
    Get.put(moderationService);

    final i18nAudit = I18nAuditService();
    i18nAudit.runAudit();
    Get.put(i18nAudit);

    final providerRepository = ProviderRepository(store);
    Get.put(providerRepository);

    Get.lazyPut(() => ClassesRepository(providerRepository: providerRepository));
    Get.lazyPut(() => GymsRepository(providerRepository: providerRepository));
    Get.lazyPut(() => TrainersRepository(providerRepository: providerRepository));
    Get.lazyPut(() => ProductsRepository(providerRepository: providerRepository));

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
    Get.put(SecurityController());
    Get.put(FormattingController(formatService));
    Get.put(ProviderController(providerRepository, rolesService));
    Get.put(ModerationController(moderationService));
  }
}
