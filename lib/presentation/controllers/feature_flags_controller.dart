import 'dart:convert';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../core/feature_flags.dart';

class FeatureFlagsController extends GetxController {
  final Rx<FeatureFlags> flags = FeatureFlags.defaults().obs;

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    final raw = AppInitializer.prefs.getString('feature_flags.v3');
    if (raw == null || raw.isEmpty) {
      flags.value = FeatureFlags.defaults();
      return;
    }
    final map = jsonDecode(raw) as Map<String, dynamic>;
    flags.value = FeatureFlags.fromMap(map);
  }

  Future<void> updateFlag({bool? communities, bool? buddyMatch, bool? miniLive}) async {
    final updated = flags.value.copyWith(
      communities: communities,
      buddyMatch: buddyMatch,
      miniLive: miniLive,
    );
    flags.value = updated;
    await AppInitializer.prefs.setString('feature_flags.v3', jsonEncode(updated.toMap()));
  }
}
