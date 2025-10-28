import 'package:get/get.dart';
import 'mixins/guarded_controller_mixin.dart';

import '../../data/models/class_model.dart';
import '../../data/models/gym_model.dart';
import '../../data/models/trainer_model.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/repositories/gyms_repository.dart';
import '../../data/repositories/trainers_repository.dart';

class HomeController extends GetxController with GuardedControllerMixin {
  HomeController(
    this._classesRepository,
    this._gymsRepository,
    this._trainersRepository,
  );

  final ClassesRepository _classesRepository;
  final GymsRepository _gymsRepository;
  final TrainersRepository _trainersRepository;

  final RxList<ClassModel> suggestedClasses = <ClassModel>[].obs;
  final RxList<GymModel> featuredGyms = <GymModel>[].obs;
  final RxList<TrainerModel> topTrainers = <TrainerModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHighlights();
  }

  Future<void> loadHighlights() async {
    isLoading.value = true;
    final classes = await _classesRepository.fetchClasses();
    final gyms = await _gymsRepository.fetchGyms();
    final trainers = await _trainersRepository.fetchTrainers();
    suggestedClasses.assignAll(classes.take(5).toList());
    featuredGyms.assignAll(gyms.take(5).toList());
    topTrainers.assignAll(trainers.take(5).toList());
    isLoading.value = false;
  }
}
