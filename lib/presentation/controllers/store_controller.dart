import 'package:get/get.dart';
import 'mixins/guarded_controller_mixin.dart';

import '../../application/services/pagination_service.dart';
import '../../application/services/search_service.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/products_repository.dart';

class StoreController extends GetxController with GuardedControllerMixin {
  StoreController(
    this._repository,
    this._searchService,
    this._paginationService,
  );

  final ProductsRepository _repository;
  final SearchService _searchService;
  final PaginationService _paginationService;

  final RxList<ProductModel> _all = <ProductModel>[].obs;
  final RxList<ProductModel> displayed = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString query = ''.obs;
  final RxString category = ''.obs;
  final RxBool priceAscending = true.obs;
  final RxInt page = 0.obs;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    final items = await _repository.fetchProducts();
    _all.assignAll(items);
    _applySorting();
    _resetPagination();
    _applyFilters();
    isLoading.value = false;
  }

  void updateQuery(String value) {
    query.value = value;
    _resetPagination();
    _applyFilters();
  }

  void selectCategory(String value) {
    category.value = value;
    _resetPagination();
    _applyFilters();
  }

  void togglePriceSort() {
    priceAscending.toggle();
    _applySorting();
    _resetPagination();
    _applyFilters();
  }

  Future<void> refresh() async => loadProducts();

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

  void _applySorting() {
    final sorted = [..._all];
    sorted.sort((a, b) => priceAscending.value
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price));
    _all.assignAll(sorted);
  }

  void _applyFilters() {
    final filtered = _filtered;
    final first = _paginationService.page(filtered, 0, pageSize);
    displayed.assignAll(first);
    hasMore.value = displayed.length < filtered.length;
  }

  void _resetPagination() {
    page.value = 0;
    displayed.clear();
    hasMore.value = true;
  }

  List<String> get categories {
    final values = _all.map((p) => p.category).toSet().toList()..sort();
    return ['All', ...values];
  }

  List<ProductModel> get _filtered {
    final base = category.value.isEmpty
        ? _all
        : _all.where((p) => p.category == category.value).toList();
    return _searchService.search(
      base,
      query.value,
      (item) => [
        item.name,
        item.category,
        ...item.tags,
        item.details,
      ],
    );
  }
}
