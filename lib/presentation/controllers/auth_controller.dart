import 'dart:async';

import 'package:get/get.dart';
import 'mixins/guarded_controller_mixin.dart';

import '../../core/app_initializer.dart';
import '../models/user_model.dart';
import '../../data/local_data/seed_loader.dart';

class AuthController extends GetxController with GuardedControllerMixin {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _restoreUser();
  }

  Future<void> _restoreUser() async {
    final stored = AppInitializer.prefs.getString('auth.user');
    if (stored != null && stored.isNotEmpty) {
      currentUser.value = UserModel.fromJsonString(stored);
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final users = SeedLoader.tryGet('assets/data/users.json');
    final list = users?['items'] as List<dynamic>? ?? [];
    for (final raw in list) {
      final user = UserModel.fromMap(raw as Map<String, dynamic>);
      if (user.email.toLowerCase() == email.toLowerCase()) {
        await _persist(user);
        currentUser.value = user;
        isLoading.value = false;
        return true;
      }
    }
    error.value = 'Invalid credentials';
    isLoading.value = false;
    return false;
  }

  Future<void> signup(UserModel user) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    await _persist(user);
    currentUser.value = user;
  }

  Future<void> continueAsGuest() async {
    currentUser.value = UserModel.guest();
    await _persist(currentUser.value!);
  }

  Future<void> logout() async {
    currentUser.value = null;
    await AppInitializer.prefs.remove('auth.user');
  }

  Future<void> _persist(UserModel user) async {
    await AppInitializer.prefs.setString('auth.user', user.toJsonString());
  }
}
