class ReminderModel {
  final String id;
  final String classId;
  final DateTime time;
  final List<String> itemsToBring;
  final bool enabled;

  ReminderModel({
    required this.id,
    required this.classId,
    required this.time,
    required this.itemsToBring,
    required this.enabled,
  });

  factory ReminderModel.fromMap(Map<String, dynamic> map) => ReminderModel(
        id: map['id'] as String,
        classId: map['class_id'] as String? ?? '',
        time: DateTime.tryParse(map['time'] as String? ?? '') ?? DateTime.now(),
        itemsToBring: (map['items_to_bring'] as List<dynamic>? ?? []).cast<String>(),
        enabled: map['enabled'] as bool? ?? true,
      );

  ReminderModel copyWith({bool? enabled}) => ReminderModel(
        id: id,
        classId: classId,
        time: time,
        itemsToBring: itemsToBring,
        enabled: enabled ?? this.enabled,
      );
}
