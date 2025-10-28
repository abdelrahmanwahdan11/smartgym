import 'dart:convert';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/class_model.dart';
import '../../data/repositories/classes_repository.dart';

class ScheduleController extends GetxController {
  ScheduleController(this._classesRepository);

  final ClassesRepository _classesRepository;

  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxMap<String, ClassModel> _classesById = <String, ClassModel>{}.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  Future<void> _restore() async {
    isLoading.value = true;
    await _loadClasses();
    final raw = AppInitializer.prefs.getString('schedule.bookings');
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => BookingModel.fromMap(e as Map<String, dynamic>))
          .toList();
      bookings.assignAll(list);
    }
    isLoading.value = false;
  }

  Future<void> _persist() async {
    final encoded = jsonEncode(bookings.map((e) => e.toMap()).toList());
    await AppInitializer.prefs.setString('schedule.bookings', encoded);
  }

  Future<void> _loadClasses() async {
    final classes = await _classesRepository.fetchClasses();
    _classesById.assignAll({for (final c in classes) c.id: c});
  }

  Future<void> addBooking(BookingModel booking) async {
    bookings.removeWhere((element) => element.classId == booking.classId);
    bookings.add(booking);
    await _persist();
  }

  Future<void> cancelBooking(String id) async {
    bookings.removeWhere((element) => element.id == id);
    await _persist();
  }

  String classTitle(String classId) => _classesById[classId]?.title ?? classId;

  DateTime? classStart(String classId) => _classesById[classId]?.startTime;

  ClassModel? classFor(String classId) => _classesById[classId];

  Future<void> clearAll() async {
    bookings.clear();
    await _persist();
  }

  Future<void> refreshData() async {
    await _loadClasses();
    bookings.refresh();
  }

  List<ClassModel> get availableClasses => _classesById.values.toList()
    ..sort((a, b) => a.title.compareTo(b.title));
}
