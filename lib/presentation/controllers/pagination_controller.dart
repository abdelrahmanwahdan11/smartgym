import 'package:get/get.dart';
import 'mixins/guarded_controller_mixin.dart';

import '../../application/services/pagination_service.dart';

class AppPaginationController extends GetxController with GuardedControllerMixin {
  AppPaginationController(this._paginationService);

  final PaginationService _paginationService;

  List<T> paginate<T>(List<T> items, int page, int pageSize) {
    return _paginationService.page(items, page, pageSize);
  }
}
