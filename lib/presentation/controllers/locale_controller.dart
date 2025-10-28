import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_initializer.dart';

class LocaleController extends GetxController {
  final Rx<Locale> locale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final code = AppInitializer.prefs.getString('locale.current');
    if (code != null) {
      final parts = code.split('_');
      locale.value = Locale(parts[0], parts.length > 1 ? parts[1] : '');
    }
  }

  Future<void> updateLocale(Locale newLocale) async {
    locale.value = newLocale;
    final code = '${newLocale.languageCode}_${newLocale.countryCode ?? ''}';
    await AppInitializer.prefs.setString('locale.current', code);
    Get.updateLocale(newLocale);
  }

  Future<void> reset() async {
    await updateLocale(const Locale('en', 'US'));
  }
}
