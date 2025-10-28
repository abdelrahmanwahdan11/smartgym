import 'dart:convert';

import 'package:get/get.dart';
import 'mixins/guarded_controller_mixin.dart';

import '../../application/services/ics_exporter.dart';
import '../../core/app_initializer.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/class_model.dart';
import '../../data/repositories/classes_repository.dart';

class ScheduleController extends GetxController with GuardedControllerMixin {
  ScheduleController(this._classesRepository);

  final ClassesRepository _classesRepository;

  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxMap<String, ClassModel> _classesById = <String, ClassModel>{}.obs;
  final RxBool isLoading = false.obs;
  final IcsExporter _icsExporter = const IcsExporter();

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

  String generateIcs() {
    final detailedBookings = bookings.map((booking) {
      final classModel = _classesById[booking.classId];
      return BookingModel(
        id: booking.id,
        userId: booking.userId,
        classId: booking.classId,
        status: booking.status,
        token: booking.token,
        createdAt: booking.createdAt,
        startTime: classModel?.startTime ?? booking.startTime,
        endTime: classModel == null
            ? booking.endTime
            : classModel.startTime.add(Duration(minutes: classModel.durationMin)),
        title: classModel?.title ?? booking.title,
      );
    }).toList();
    return _icsExporter.exportFromBookings(detailedBookings);
  }

  List<BookingConflictWindow> conflictWindows() {
    final segments = bookings
        .map((booking) {
          final classModel = _classesById[booking.classId];
          final start = classModel?.startTime ?? booking.startTime;
          final end = classModel == null
              ? booking.endTime
              : classModel.startTime.add(Duration(minutes: classModel.durationMin));
          if (start == null) {
            return null;
          }
          return BookingConflictWindow(
            booking: booking,
            start: start,
            end: end ?? start.add(const Duration(minutes: 45)),
            title: classModel?.title ?? booking.title ?? booking.classId,
          );
        })
        .whereType<BookingConflictWindow>()
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    final conflicts = <BookingConflictWindow>[];
    for (var i = 0; i < segments.length; i++) {
      for (var j = i + 1; j < segments.length; j++) {
        if (segments[i].end.isAfter(segments[j].start)) {
          conflicts.add(segments[i]);
          conflicts.add(segments[j]);
        } else {
          break;
        }
      }
    }
    final unique = {
      for (final item in conflicts) item.booking.id: item,
    };
    return unique.values.toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }
}

class BookingConflictWindow {
  BookingConflictWindow({
    required this.booking,
    required this.start,
    required this.end,
    required this.title,
  });

  final BookingModel booking;
  final DateTime start;
  final DateTime end;
  final String title;
}
