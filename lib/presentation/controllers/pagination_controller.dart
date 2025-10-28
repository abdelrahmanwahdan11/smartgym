import 'package:get/get.dart';

import '../../application/services/pagination_service.dart';

class AppPaginationController extends GetxController {
  AppPaginationController(this._paginationService);

  final PaginationService _paginationService;

  List<T> paginate<T>(List<T> items, int page, int pageSize) {
    return _paginationService.page(items, page, pageSize);
  }
}
