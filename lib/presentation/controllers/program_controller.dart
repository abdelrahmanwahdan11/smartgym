import 'dart:convert';

import 'package:get/get.dart';
import 'mixins/guarded_controller_mixin.dart';

import '../../core/app_initializer.dart';
import '../../data/models/class_model.dart';
import '../../data/models/program_model.dart';
import '../../data/repositories/classes_repository.dart';
import '../controllers/schedule_controller.dart';

class ProgramController extends GetxController with GuardedControllerMixin {
  ProgramController(this._classesRepository);

  final ClassesRepository _classesRepository;
  final ScheduleController _scheduleController = Get.find();

  final RxList<ClassModel> classes = <ClassModel>[].obs;
  final RxMap<String, ClassModel> _classesById = <String, ClassModel>{}.obs;
  final RxList<ProgramDayModel> days = <ProgramDayModel>[].obs;
  final RxMap<String, String> conflicts = <String, String>{}.obs;
  final RxBool isSaving = false.obs;
  final Rx<ProgramModel?> program = Rx<ProgramModel?>(null);

  static const _storageKey = 'program.current';

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final items = await _classesRepository.fetchClasses();
    classes.assignAll(items);
    _classesById.assignAll({for (final c in items) c.id: c});
    final raw = AppInitializer.prefs.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      program.value = ProgramModel.fromMap(map);
      days.assignAll(program.value!.days);
    } else {
      days.assignAll(_defaultDays());
    }
    _evaluateConflicts();
  }

  Future<void> reload() => _load();

  List<ProgramDayModel> _defaultDays() {
    return _weekdayOrder
        .map((day) => ProgramDayModel(weekday: day, classIds: []))
        .toList();
  }

  void addClass(String weekday, String classId) {
    final index = days.indexWhere((element) => element.weekday == weekday);
    if (index == -1) return;
    final updatedIds = [...days[index].classIds];
    if (!updatedIds.contains(classId)) {
      updatedIds.add(classId);
      days[index] = days[index].copyWith(classIds: updatedIds);
      _updateProgram();
    }
  }

  void removeClass(String weekday, String classId) {
    final index = days.indexWhere((element) => element.weekday == weekday);
    if (index == -1) return;
    final updatedIds = [...days[index].classIds]..remove(classId);
    days[index] = days[index].copyWith(classIds: updatedIds);
    _updateProgram();
  }

  void updateNotes(String weekday, String value) {
    final index = days.indexWhere((element) => element.weekday == weekday);
    if (index == -1) return;
    days[index] = days[index].copyWith(notes: value);
    _updateProgram(recalculate: false);
  }

  Future<void> saveProgram(String name, String goal) async {
    isSaving.value = true;
    final current = ProgramModel(
      id: program.value?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      goal: goal,
      days: days.toList(),
      createdAt: program.value?.createdAt ?? DateTime.now(),
    );
    program.value = current;
    await AppInitializer.prefs.setString(_storageKey, jsonEncode(current.toMap()));
    isSaving.value = false;
    _evaluateConflicts();
  }

  List<ClassModel> classesForDay(String weekday) {
    final ids = days.firstWhereOrNull((element) => element.weekday == weekday)?.classIds ?? [];
    return ids.map((id) => _classesById[id]).whereType<ClassModel>().toList();
  }

  List<ClassModel> suggestionsForDay(String weekday) {
    final weekdayIndex = _weekdayIndex(weekday);
    return classes.where((element) => element.startTime.weekday == weekdayIndex).toList();
  }

  void _updateProgram({bool recalculate = true}) {
    if (program.value != null) {
      program.value = program.value!.copyWith(days: days.toList());
    }
    if (recalculate) {
      _evaluateConflicts();
    }
  }

  void _evaluateConflicts() {
    final Map<String, String> newConflicts = {};
    final bookings = _scheduleController.bookings;
    final dayMap = {for (final day in days) day.weekday: day};
    for (final day in dayMap.values) {
      for (final classId in day.classIds) {
        final model = _classesById[classId];
        if (model == null) continue;
        final conflictsForClass = bookings.where((booking) {
          if (booking.classId == classId) return true;
          final scheduled = _scheduleController.classFor(booking.classId);
          if (scheduled == null) return false;
          final sameDay = scheduled.startTime.weekday == model.startTime.weekday;
          final delta = scheduled.startTime.difference(model.startTime).inMinutes.abs();
          return sameDay && delta < 60;
        }).toList();
        if (conflictsForClass.isNotEmpty) {
          newConflicts[classId] = '${model.title}•${day.weekday}';
        }
      }
    }
    conflicts.assignAll(newConflicts);
  }

  static final List<String> _weekdayOrder = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  int _weekdayIndex(String weekday) {
    switch (weekday) {
      case 'mon':
        return DateTime.monday;
      case 'tue':
        return DateTime.tuesday;
      case 'wed':
        return DateTime.wednesday;
      case 'thu':
        return DateTime.thursday;
      case 'fri':
        return DateTime.friday;
      case 'sat':
        return DateTime.saturday;
      case 'sun':
      default:
        return DateTime.sunday;
    }
  }
}
