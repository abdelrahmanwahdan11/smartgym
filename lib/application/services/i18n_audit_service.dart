import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/localization/app_translations.dart';

class I18nAuditService extends GetxService {
  I18nAuditService();

  final RxInt missingKeys = 0.obs;

  static const List<String> criticalKeys = <String>[
    'app_name',
    'login',
    'signup',
    'home',
    'classes',
    'gyms',
    'trainers',
    'store',
    'settings',
    'unexpected_error',
    'retry',
  ];

  void runAudit() {
    final translations = AppTranslations().keys;
    var missing = 0;
    for (final locale in translations.values) {
      for (final key in criticalKeys) {
        if (!locale.containsKey(key)) {
          missing += 1;
        }
      }
    }
    missingKeys.value = missing;
    if (kDebugMode && missing > 0) {
      debugPrint('I18n audit: $missing missing critical keys');
    }
  }
}
