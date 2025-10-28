import 'package:get/get.dart';

import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../data/models/gym_model.dart';
import '../../data/repositories/gyms_repository.dart';

class GymsController extends GetxController {
  GymsController(
    this._repository,
    this._searchService,
    this._paginationService,
  );

  final GymsRepository _repository;
  final SearchService _searchService;
  final PaginationService _paginationService;

  final RxList<GymModel> _allGyms = <GymModel>[].obs;
  final RxList<GymModel> displayed = <GymModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString query = ''.obs;
  final RxInt page = 0.obs;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    loadGyms();
  }

  Future<void> loadGyms() async {
    isLoading.value = true;
    final items = await _repository.fetchGyms();
    _allGyms.assignAll(items);
    _resetPagination();
    _applySearch();
    isLoading.value = false;
  }

  void updateQuery(String value) {
    query.value = value;
    _resetPagination();
    _applySearch();
  }

  Future<void> refresh() async => loadGyms();

  void loadMore() {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    page.value += 1;
    final next = _paginationService.page(_filtered, page.value, pageSize);
    if (next.isNotEmpty) {
      displayed.addAll(next);
    }
    if (next.length < pageSize) {
      hasMore.value = false;
    }
    isLoadingMore.value = false;
  }

  void _resetPagination() {
    page.value = 0;
    displayed.clear();
    hasMore.value = true;
  }

  void _applySearch() {
    final filtered = _filtered;
    final firstPage = _paginationService.page(filtered, 0, pageSize);
    displayed.assignAll(firstPage);
    hasMore.value = displayed.length < filtered.length;
  }

  List<GymModel> get _filtered => _searchService.search(
        _allGyms,
        query.value,
        (item) => [
          item.name,
          item.locationText,
          ...item.amenities,
          ...item.equipment,
        ],
      );
}
