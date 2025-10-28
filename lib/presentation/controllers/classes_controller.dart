import 'package:get/get.dart';

import '../../application/services/index_service.dart';
import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../data/models/class_model.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/repositories/gyms_repository.dart';
import '../../data/repositories/trainers_repository.dart';

class ClassesController extends GetxController {
  ClassesController(
    this._repository,
    this._searchService,
    this._paginationService,
    this._gymsRepository,
    this._trainersRepository,
    this._indexService,
  );

  final ClassesRepository _repository;
  final SearchService _searchService;
  final PaginationService _paginationService;
  final GymsRepository _gymsRepository;
  final TrainersRepository _trainersRepository;
  final IndexService _indexService;

  final RxList<ClassModel> _allClasses = <ClassModel>[].obs;
  final RxList<ClassModel> displayed = <ClassModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString query = ''.obs;
  final RxInt page = 0.obs;
  final int pageSize = 10;
  Map<String, ClassIndexEntry> _index = {};

  @override
  void onInit() {
    super.onInit();
    loadClasses();
  }

  Future<void> loadClasses() async {
    isLoading.value = true;
    final items = await _repository.fetchClasses();
    final gyms = await _gymsRepository.fetchGyms();
    final trainers = await _trainersRepository.fetchTrainers();
    _allClasses.assignAll(items);
    _index = _indexService.buildClassIndex(
      classes: items,
      gyms: gyms,
      trainers: trainers,
    );
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

  List<ClassModel> get _filtered {
    if (_index.isEmpty) {
      return _searchService.search(
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
    final results = _indexService.searchClasses(_index, query.value);
    if (results.isEmpty) {
      return query.value.trim().isEmpty ? _allClasses : <ClassModel>[];
    }
    return results;
  }
}
