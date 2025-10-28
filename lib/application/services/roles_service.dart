import 'package:get/get.dart';

import '../../data/local_data/local_store.dart';

class RolesService extends GetxService {
  RolesService(this.store);

  final LocalStore store;

  static const _key = 'roles.active';

  final RxSet<String> _roles = <String>{'user'}.obs;

  Future<void> load() async {
    final list = store.getStringList(_key) ?? <String>['user'];
    _roles
      ..clear()
      ..addAll(list);
  }

  Set<String> get roles => _roles.toSet();

  bool hasRole(String role) {
    if (_roles.contains('admin')) return true;
    return _roles.contains(role);
  }

  Future<void> toggleRole(String role, bool enabled) async {
    if (enabled) {
      _roles.add(role);
    } else {
      if (role == 'user') return;
      _roles.remove(role);
    }
    await store.setStringList(_key, _roles.toList());
  }

  Future<void> setRoles(Iterable<String> roles) async {
    _roles
      ..clear()
      ..addAll(roles);
    if (_roles.isEmpty) {
      _roles.add('user');
    }
    await store.setStringList(_key, _roles.toList());
  }

  Future<void> reset() => setRoles(const ['user']);

  static RolesService get to => Get.find<RolesService>();
}
