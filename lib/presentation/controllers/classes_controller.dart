import 'package:get/get.dart';

import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../data/models/class_model.dart';
import '../../data/repositories/classes_repository.dart';

class ClassesController extends GetxController {
  ClassesController(
    this._repository,
    this._searchService,
    this._paginationService,
  );

  final ClassesRepository _repository;
  final SearchService _searchService;
  final PaginationService _paginationService;

  final RxList<ClassModel> _allClasses = <ClassModel>[].obs;
  final RxList<ClassModel> displayed = <ClassModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString query = ''.obs;
  final RxInt page = 0.obs;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    loadClasses();
  }

  Future<void> loadClasses() async {
    isLoading.value = true;
    final items = await _repository.fetchClasses();
    _allClasses.assignAll(items);
    _resetPagination();
    _applySearch();
    isLoading.value = false;
  }

  void updateQuery(String value) {
    query.value = value;
    _resetPagination();
    _applySearch();
  }

  Future<void> refresh() async {
    await loadClasses();
  }

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

  List<ClassModel> get _filtered => _searchService.search(
        _allClasses,
        query.value,
        (item) => [
          item.title,
          item.type,
          item.level,
          item.intensity,
          item.description,
        ],
      );
}
