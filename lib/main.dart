import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/app_initializer.dart';
import 'core/bindings/initial_binding.dart';
import 'core/error/app_error_boundary.dart';
import 'core/localization/app_translations.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'presentation/controllers/locale_controller.dart';
import 'presentation/controllers/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  AppErrorBoundary.install();
  runApp(const GymPassportApp());
}

class GymPassportApp extends StatelessWidget {
  const GymPassportApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final localeController = Get.put(LocaleController());

    return Obx(
      () => GetMaterialApp(
        title: 'Gym Passport',
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: localeController.locale.value,
        fallbackLocale: const Locale('en', 'US'),
        theme: AppTheme.light(themeController.primaryColor.value),
        darkTheme: AppTheme.dark(themeController.primaryColor.value),
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        initialBinding: InitialBinding(),
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        unknownRoute: GetPage(name: '/error', page: () => const AppCrashScreen()),
        defaultTransition: Transition.fadeIn,
      ),
    );
  }
}
