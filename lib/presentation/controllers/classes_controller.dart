import 'package:get/get.dart';

import '../../application/services/index_service.dart';
import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../core/app_initializer.dart';
import '../../core/constants.dart';
import '../../data/models/class_model.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/repositories/gyms_repository.dart';
import '../../data/repositories/trainers_repository.dart';
import 'mixins/guarded_controller_mixin.dart';

class ClassesController extends GetxController with GuardedControllerMixin {
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
  final _store = AppInitializer.store;

  final RxList<ClassModel> _allClasses = <ClassModel>[].obs;
  final RxList<ClassModel> displayed = <ClassModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString query = ''.obs;
  final RxInt page = 0.obs;
  final RxString viewMode = 'list'.obs;
  final RxString gridDensity = 'comfortable'.obs;
  final RxBool favoritesOnly = false.obs;
  final RxSet<String> favoriteClassIds = <String>{}.obs;
  final RxMap<String, List<String>> activeFilters = <String, List<String>>{
    'type': <String>[],
    'level': <String>[],
    'intensity': <String>[],
    'duration': <String>[],
    'equipment': <String>[],
  }.obs;

  final int pageSize = AppConstants.paginationPageSize;
  Map<String, ClassIndexEntry> _index = {};

  bool get isGrid => viewMode.value == 'grid';

  List<String> get durationOptions => const ['<=30', '31-45', '46+'];

  List<String> get types => _uniqueSorted((item) => item.type);

  List<String> get levels => _uniqueSorted((item) => item.level);

  List<String> get intensities => _uniqueSorted((item) => item.intensity);

  List<String> get equipments => _equipmentOptions();

  List<String> get quickFilters => types.take(4).toList();

  List<ClassModel> get favorites =>
      _allClasses.where((c) => favoriteClassIds.contains(c.id)).toList();

  List<String> get searchSuggestions {
    final set = <String>{};
    for (final entry in _index.values) {
      set
        ..add(entry.classModel.title)
        ..add(entry.classModel.type)
        ..add(entry.classModel.level)
        ..add(entry.gymName)
        ..add(entry.trainerName);
    }
    return set
        .where((element) => element.trim().isNotEmpty)
        .take(12)
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
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
    await _pruneFavorites();
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

  Future<void> setViewMode(String mode) async {
    if (viewMode.value == mode) {
      return;
    }
    viewMode.value = mode;
    await _store.setString('ui.view_mode.classes', mode);
  }

  Future<void> setGridDensity(String density) async {
    if (gridDensity.value == density) {
      return;
    }
    gridDensity.value = density;
    await _store.setString('ui.grid_density', density);
  }

  Future<void> toggleFavorite(String id) async {
    if (favoriteClassIds.contains(id)) {
      favoriteClassIds.remove(id);
    } else {
      favoriteClassIds.add(id);
    }
    favoriteClassIds.refresh();
    await _persistFavorites();
    _resetPagination();
    _applySearch();
  }

  bool isFavorite(String id) => favoriteClassIds.contains(id);

  void setFavoritesOnly(bool value) {
    if (favoritesOnly.value == value) {
      return;
    }
    favoritesOnly.value = value;
    _resetPagination();
    _applySearch();
  }

  void toggleFilter(String key, String value) {
    final current = List<String>.from(activeFilters[key] ?? <String>[]);
    if (current.contains(value)) {
      current.remove(value);
    } else {
      current.add(value);
    }
    activeFilters[key] = current;
    _resetPagination();
    _applySearch();
  }

  bool isFilterActive(String key, String value) =>
      (activeFilters[key] ?? const <String>[]).contains(value);

  void clearFilters() {
    activeFilters.value = <String, List<String>>{
      'type': <String>[],
      'level': <String>[],
      'intensity': <String>[],
      'duration': <String>[],
      'equipment': <String>[],
    };
    _resetPagination();
    _applySearch();
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
    final trimmed = query.value.trim();
    List<ClassModel> base;
    if (_index.isEmpty) {
      base = _searchService.search(
        _allClasses,
        trimmed,
        (item) => [
          item.title,
          item.type,
          item.level,
          item.intensity,
          item.description,
          item.requirements.join(' '),
        ],
      );
    } else if (trimmed.isEmpty) {
      base = _allClasses.toList();
    } else {
      base = _indexService.searchClasses(_index, _expandedTerms(trimmed));
    }

    var filtered = base.where(_matchesFilters).toList();
    filtered = _orderByFavorites(filtered);
    if (favoritesOnly.value) {
      filtered = filtered
          .where((item) => favoriteClassIds.contains(item.id))
          .toList();
    }
    return filtered;
  }

  bool _matchesFilters(ClassModel item) {
    final typeFilters = activeFilters['type'] ?? const <String>[];
    if (typeFilters.isNotEmpty && !typeFilters.contains(item.type)) {
      return false;
    }
    final levelFilters = activeFilters['level'] ?? const <String>[];
    if (levelFilters.isNotEmpty && !levelFilters.contains(item.level)) {
      return false;
    }
    final intensityFilters = activeFilters['intensity'] ?? const <String>[];
    if (intensityFilters.isNotEmpty &&
        !intensityFilters.contains(item.intensity)) {
      return false;
    }
    final durationFilters = activeFilters['duration'] ?? const <String>[];
    if (durationFilters.isNotEmpty &&
        !durationFilters.contains(_durationBucket(item))) {
      return false;
    }
    final equipmentFilters = activeFilters['equipment'] ?? const <String>[];
    if (equipmentFilters.isNotEmpty) {
      final requirements =
          item.requirements.map((e) => e.toLowerCase().trim()).toList();
      final match = equipmentFilters.any(
        (element) => requirements.contains(element.toLowerCase().trim()),
      );
      if (!match) {
        return false;
      }
    }
    return true;
  }

  String _durationBucket(ClassModel item) {
    final duration = item.durationMin;
    if (duration <= 30) {
      return '<=30';
    }
    if (duration <= 45) {
      return '31-45';
    }
    return '46+';
  }

  List<String> _expandedTerms(String value) {
    final tokens = value
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty);
    return _searchService.synonymsService.expandTerms(tokens);
  }

  List<ClassModel> _orderByFavorites(List<ClassModel> items) {
    if (favoriteClassIds.isEmpty) {
      return items;
    }
    final favs = favoriteClassIds.toSet();
    final sorted = List<ClassModel>.from(items)
      ..sort((a, b) {
        final aFav = favs.contains(a.id);
        final bFav = favs.contains(b.id);
        if (aFav == bFav) {
          return 0;
        }
        return aFav ? -1 : 1;
      });
    return sorted;
  }

  List<String> _uniqueSorted(String Function(ClassModel) selector) {
    final values = _allClasses
        .map(selector)
        .where((value) => value.trim().isNotEmpty)
        .toSet()
        .toList();
    values.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return values;
  }

  List<String> _equipmentOptions() {
    final set = <String>{};
    for (final item in _allClasses) {
      for (final requirement in item.requirements) {
        if (requirement.trim().isEmpty) continue;
        set.add(requirement);
      }
    }
    final list = set.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  void _loadPreferences() {
    viewMode.value = _store.getString('ui.view_mode.classes') ?? 'list';
    gridDensity.value = _store.getString('ui.grid_density') ?? 'comfortable';
    final storedFavorites =
        _store.getStringList('ui.favorites.classes') ?? <String>[];
    favoriteClassIds
      ..clear()
      ..addAll(storedFavorites);
    favoriteClassIds.refresh();
  }

  Future<void> _persistFavorites() async {
    await _store.setStringList(
      'ui.favorites.classes',
      favoriteClassIds.toList(),
    );
  }

  Future<void> _pruneFavorites() async {
    final validIds = _allClasses.map((e) => e.id).toSet();
    final before = favoriteClassIds.length;
    favoriteClassIds.removeWhere((id) => !validIds.contains(id));
    if (favoriteClassIds.length != before) {
      favoriteClassIds.refresh();
      await _persistFavorites();
    }
  }
}
