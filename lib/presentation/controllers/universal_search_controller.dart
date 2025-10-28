import 'dart:async';

import 'package:get/get.dart';

import '../../application/services/index_service.dart';
import '../../application/services/synonyms_service.dart';
import '../../data/models/class_model.dart';
import '../../data/models/gym_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/trainer_model.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/repositories/gyms_repository.dart';
import '../../data/repositories/products_repository.dart';
import '../../data/repositories/trainers_repository.dart';
import 'mixins/guarded_controller_mixin.dart';

class UniversalSearchController extends GetxController with GuardedControllerMixin {
  UniversalSearchController(
    this._classesRepository,
    this._gymsRepository,
    this._trainersRepository,
    this._productsRepository,
    this._indexService,
    this._synonymsService,
  );

  final ClassesRepository _classesRepository;
  final GymsRepository _gymsRepository;
  final TrainersRepository _trainersRepository;
  final ProductsRepository _productsRepository;
  final IndexService _indexService;
  final SynonymsService _synonymsService;

  final RxBool isLoading = true.obs;
  final RxString query = ''.obs;
  final RxList<String> suggestions = <String>[].obs;

  final RxList<ClassModel> classResults = <ClassModel>[].obs;
  final RxList<GymModel> gymResults = <GymModel>[].obs;
  final RxList<TrainerModel> trainerResults = <TrainerModel>[].obs;
  final RxList<ProductModel> productResults = <ProductModel>[].obs;

  late Map<String, ClassIndexEntry> _classIndex;
  late Map<String, GymIndexEntry> _gymIndex;
  late Map<String, TrainerIndexEntry> _trainerIndex;
  late Map<String, ProductIndexEntry> _productIndex;
  late Map<String, GymModel> _gymById;
  late Map<String, TrainerModel> _trainerById;

  List<ClassModel> _allClasses = const [];
  List<GymModel> _allGyms = const [];
  List<TrainerModel> _allTrainers = const [];
  List<ProductModel> _allProducts = const [];

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final classes = await _classesRepository.fetchClasses();
    final gyms = await _gymsRepository.fetchGyms();
    final trainers = await _trainersRepository.fetchTrainers();
    final products = await _productsRepository.fetchProducts();

    _allClasses = classes;
    _allGyms = gyms;
    _allTrainers = trainers;
    _allProducts = products;

    _classIndex = _indexService.buildClassIndex(
      classes: classes,
      gyms: gyms,
      trainers: trainers,
    );
    _gymIndex = _indexService.buildGymIndex(gyms);
    _trainerIndex = _indexService.buildTrainerIndex(trainers);
    _productIndex = _indexService.buildProductIndex(products);
    _gymById = {for (final gym in gyms) gym.id: gym};
    _trainerById = {for (final trainer in trainers) trainer.id: trainer};

    _buildSuggestions();
    _applyQuery('');
    isLoading.value = false;
  }

  void updateQuery(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _applyQuery(value);
    });
  }

  void _applyQuery(String value) {
    query.value = value;
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      classResults.assignAll(_allClasses.take(6));
      gymResults.assignAll(_allGyms.take(6));
      trainerResults.assignAll(_allTrainers.take(6));
      productResults.assignAll(_allProducts.take(6));
      return;
    }

    final baseTerms = trimmed.toLowerCase().split(RegExp(r'\s+')).where((element) => element.isNotEmpty);
    final terms = _synonymsService.expandTerms(baseTerms);

    classResults.assignAll(_indexService.searchClasses(_classIndex, terms).take(10));
    gymResults.assignAll(_indexService.searchGyms(_gymIndex, terms).take(10));
    trainerResults.assignAll(_indexService.searchTrainers(_trainerIndex, terms).take(10));
    productResults.assignAll(_indexService.searchProducts(_productIndex, terms).take(10));
  }

  void _buildSuggestions() {
    final classTitles = _allClasses.map((e) => e.title);
    final gymNames = _allGyms.map((e) => e.name);
    final trainerNames = _allTrainers.map((e) => e.name);
    final productNames = _allProducts.map((e) => e.name);
    final combined = <String>{
      ...classTitles,
      ...gymNames,
      ...trainerNames,
      ...productNames,
    }..removeWhere((element) => element.trim().isEmpty);
    final sorted = combined.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    suggestions.assignAll(sorted.take(12));
  }

  String gymNameFor(String id) => _gymById[id]?.name ?? '';

  String trainerNameFor(String id) => _trainerById[id]?.name ?? '';

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
