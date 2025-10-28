import 'package:get/get.dart';

import '../../presentation/bindings/classes_binding.dart';
import '../../presentation/bindings/gyms_binding.dart';
import '../../presentation/bindings/home_binding.dart';
import '../../presentation/bindings/store_binding.dart';
import '../../presentation/bindings/trainers_binding.dart';
import '../../presentation/bindings/timers_binding.dart';
import '../../presentation/pages/account_page.dart';
import '../../presentation/pages/cart_page.dart';
import '../../presentation/pages/buddy/buddy_match_page.dart';
import '../../presentation/pages/class_details_page.dart';
import '../../presentation/pages/classes_page.dart';
import '../../presentation/pages/checkout_page.dart';
import '../../presentation/pages/challenges/challenge_details_page.dart';
import '../../presentation/pages/challenges/challenges_page.dart';
import '../../presentation/pages/community/communities_page.dart';
import '../../presentation/pages/community/community_thread_page.dart';
import '../../presentation/pages/gyms_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/inbody_page.dart';
import '../../presentation/pages/injury/injury_adapt_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/diet/diet_planner_page.dart';
import '../../presentation/pages/diet/grocery_list_page.dart';
import '../../presentation/pages/notifications_page.dart';
import '../../presentation/pages/onboarding_page.dart';
import '../../presentation/pages/product_details_page.dart';
import '../../presentation/pages/program/program_designer_page.dart';
import '../../presentation/pages/progress_page.dart';
import '../../presentation/pages/qr_pass_page.dart';
import '../../presentation/pages/reminders_page.dart';
import '../../presentation/pages/hydration/hydration_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/share_card_page.dart';
import '../../presentation/pages/signup_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/store_page.dart';
import '../../presentation/pages/steps/steps_page.dart';
import '../../presentation/pages/sleep/sleep_coach_page.dart';
import '../../presentation/pages/trainer_details_page.dart';
import '../../presentation/pages/trainers_page.dart';
import '../../presentation/pages/wallet_page.dart';
import '../../presentation/pages/timers_page.dart';
import '../../presentation/pages/physio/physio_page.dart';
import '../../presentation/pages/stories/stories_page.dart';
import '../../presentation/pages/live/live_mini_page.dart';
import '../routes/app_routes.dart';
import '../../presentation/pages/gym_details_page.dart';
import '../../presentation/pages/schedule_page.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingPage()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.signup, page: () => const SignupPage()),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.classes,
      page: () => const ClassesPage(),
      binding: ClassesBinding(),
    ),
    GetPage(
      name: '${AppRoutes.classDetails}/:id',
      page: () => const ClassDetailsPage(),
    ),
    GetPage(
      name: AppRoutes.gyms,
      page: () => const GymsPage(),
      binding: GymsBinding(),
    ),
    GetPage(
      name: '${AppRoutes.gymDetails}/:id',
      page: () => const GymDetailsPage(),
    ),
    GetPage(
      name: AppRoutes.trainers,
      page: () => const TrainersPage(),
      binding: TrainersBinding(),
    ),
    GetPage(
      name: '${AppRoutes.trainerDetails}/:id',
      page: () => const TrainerDetailsPage(),
    ),
    GetPage(name: AppRoutes.schedule, page: () => const SchedulePage()),
    GetPage(name: AppRoutes.inbody, page: () => const InBodyPage()),
    GetPage(name: AppRoutes.progress, page: () => const ProgressPage()),
    GetPage(
      name: AppRoutes.store,
      page: () => const StorePage(),
      binding: StoreBinding(),
    ),
    GetPage(name: AppRoutes.cart, page: () => const CartPage()),
    GetPage(name: AppRoutes.checkout, page: () => const CheckoutPage()),
    GetPage(
      name: '${AppRoutes.product}/:id',
      page: () => const ProductDetailsPage(),
    ),
    GetPage(name: AppRoutes.wallet, page: () => const WalletPage()),
    GetPage(name: AppRoutes.shareCard, page: () => const ShareCardPage()),
    GetPage(name: AppRoutes.qrPass, page: () => const QrPassPage()),
    GetPage(name: AppRoutes.reminders, page: () => const RemindersPage()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsPage()),
    GetPage(name: AppRoutes.account, page: () => const AccountPage()),
    GetPage(
      name: AppRoutes.timers,
      page: () => const TimersPage(),
      binding: TimersBinding(),
    ),
    GetPage(name: AppRoutes.programDesigner, page: () => const ProgramDesignerPage()),
    GetPage(name: AppRoutes.challenges, page: () => const ChallengesPage()),
    GetPage(name: '${AppRoutes.challengeDetails}/:id', page: () => const ChallengeDetailsPage()),
    GetPage(name: AppRoutes.communities, page: () => const CommunitiesPage()),
    GetPage(name: AppRoutes.communityThread, page: () => const CommunityThreadPage()),
    GetPage(name: AppRoutes.diet, page: () => const DietPlannerPage()),
    GetPage(name: AppRoutes.grocery, page: () => const GroceryListPage()),
    GetPage(name: AppRoutes.hydration, page: () => const HydrationPage()),
    GetPage(name: AppRoutes.steps, page: () => const StepsPage()),
    GetPage(name: AppRoutes.sleep, page: () => const SleepCoachPage()),
    GetPage(name: AppRoutes.injury, page: () => const InjuryAdaptPage()),
    GetPage(name: AppRoutes.physio, page: () => const PhysioPage()),
    GetPage(name: AppRoutes.stories, page: () => const StoriesPage()),
    GetPage(name: AppRoutes.liveMini, page: () => const LiveMiniPage()),
    GetPage(name: AppRoutes.buddy, page: () => const BuddyMatchPage()),
  ];
}
