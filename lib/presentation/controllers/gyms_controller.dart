import 'dart:async';
import 'dart:ui';

import 'package:get/get.dart';

import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../core/app_initializer.dart';
import '../../core/constants.dart';
import '../../data/models/gym_model.dart';
import '../../data/repositories/gyms_repository.dart';
import 'mixins/guarded_controller_mixin.dart';

class GymsController extends GetxController with GuardedControllerMixin {
  GymsController(
    this._repository,
    this._searchService,
    this._paginationService,
  );

  final GymsRepository _repository;
  final SearchService _searchService;
  final PaginationService _paginationService;
  final _store = AppInitializer.store;

  final RxList<GymModel> _allGyms = <GymModel>[].obs;
  final RxList<GymModel> displayed = <GymModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString query = ''.obs;
  final RxInt page = 0.obs;
  final RxString viewMode = 'list'.obs;
  final RxString gridDensity = 'comfortable'.obs;
  final RxSet<String> amenityFilters = <String>{}.obs;

  List<GymModel> _currentFiltered = const [];
  List<String> _amenityOptions = const [];
  final int pageSize = AppConstants.paginationPageSize;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
    loadGyms();
  }

  List<String> get amenityOptions => _amenityOptions;

  List<GymModel> get filteredGyms => _currentFiltered;

  List<String> get searchSuggestions =>
      _allGyms.map((gym) => gym.name).where((name) => name.trim().isNotEmpty).toList(growable: false);

  Future<void> loadGyms() async {
    isLoading.value = true;
    final items = await _repository.fetchGyms();
    _allGyms.assignAll(items);
    _computeAmenityOptions();
    _resetPagination();
    _applySearch();
    isLoading.value = false;
  }

  Future<void> refresh() async => loadGyms();

  void updateQuery(String value) {
    query.value = value;
    _resetPagination();
    _applySearch();
  }

  void toggleAmenity(String amenity) {
    if (amenityFilters.contains(amenity)) {
      amenityFilters.remove(amenity);
    } else {
      amenityFilters.add(amenity);
    }
    amenityFilters.refresh();
    _resetPagination();
    _applySearch();
  }

  bool isAmenityActive(String amenity) => amenityFilters.contains(amenity);

  void setViewMode(String mode) {
    if (viewMode.value == mode) {
      return;
    }
    viewMode.value = mode;
    unawaited(_store.setString('ui.view_mode.gyms', mode));
  }

  void setGridDensity(String density) {
    if (gridDensity.value == density) {
      return;
    }
    gridDensity.value = density;
    unawaited(_store.setString('ui.grid_density', density));
  }

  void loadMore() {
    if (isLoadingMore.value || !hasMore.value || viewMode.value == 'map') {
      return;
    }
    isLoadingMore.value = true;
    page.value += 1;
    final next = _paginationService.page(_currentFiltered, page.value, pageSize);
    if (next.isNotEmpty) {
      displayed.addAll(next);
    }
    if (displayed.length >= _currentFiltered.length) {
      hasMore.value = false;
    }
    isLoadingMore.value = false;
  }

  Offset normalizedPositionFor(GymModel gym) {
    final hash = gym.id.hashCode;
    final xSeed = (hash & 0xFFFF) / 0xFFFF;
    final ySeed = ((hash >> 16) & 0xFFFF) / 0xFFFF;
    final x = 0.1 + (xSeed.clamp(0.0, 1.0) * 0.8);
    final y = 0.1 + (ySeed.clamp(0.0, 1.0) * 0.8);
    return Offset(x, y);
  }

  void _resetPagination() {
    page.value = 0;
    displayed.clear();
    hasMore.value = true;
  }

  void _applySearch() {
    final filtered = _filtered;
    _currentFiltered = filtered;
    final firstPage = _paginationService.page(filtered, 0, pageSize);
    displayed.assignAll(firstPage);
    hasMore.value = displayed.length < filtered.length;
  }

  List<GymModel> get _filtered {
    final base = _searchService.search(
      _allGyms,
      query.value,
      (item) => [
        item.name,
        item.locationText,
        ...item.amenities,
        ...item.equipment,
      ],
    );
    if (amenityFilters.isEmpty) {
      return base;
    }
    final filters = amenityFilters.map((e) => e.toLowerCase()).toList();
    return base.where((gym) {
      final amenities = gym.amenities.map((e) => e.toLowerCase()).toSet();
      return filters.every(amenities.contains);
    }).toList();
  }

  void _computeAmenityOptions() {
    final set = <String>{};
    for (final gym in _allGyms) {
      for (final amenity in gym.amenities) {
        if (amenity.trim().isEmpty) continue;
        set.add(amenity);
      }
    }
    final list = set.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    _amenityOptions = list;
  }

  void _loadPreferences() {
    viewMode.value = _store.getString('ui.view_mode.gyms') ?? 'list';
    gridDensity.value = _store.getString('ui.grid_density') ?? 'comfortable';
  }
}
