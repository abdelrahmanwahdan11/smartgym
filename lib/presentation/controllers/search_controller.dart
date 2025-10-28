import 'dart:async';

import 'package:get/get.dart';
import 'mixins/guarded_controller_mixin.dart';

import '../../application/services/search_service.dart';

class AppSearchController extends GetxController with GuardedControllerMixin {
  AppSearchController(this._searchService);

  final SearchService _searchService;
  final RxString query = ''.obs;
  Timer? _debounce;
  final StreamController<String> _queryStream = StreamController.broadcast();

  Stream<String> get queryChanges => _queryStream.stream;

  void updateQuery(String value, {Duration debounce = const Duration(milliseconds: 250)}) {
    _debounce?.cancel();
    _debounce = Timer(debounce, () {
      query.value = value;
      _queryStream.add(value);
    });
  }

  List<T> applySearch<T>(List<T> items, Iterable<String> Function(T item) selector) {
    return _searchService.search(items, query.value, selector);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    _queryStream.close();
    super.onClose();
  }
}
