class ProgramDayModel {
  ProgramDayModel({
    required this.weekday,
    required this.classIds,
    this.notes = '',
  });

  final String weekday;
  final List<String> classIds;
  final String notes;

  ProgramDayModel copyWith({
    List<String>? classIds,
    String? notes,
  }) => ProgramDayModel(
        weekday: weekday,
        classIds: classIds ?? this.classIds,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toMap() => {
        'weekday': weekday,
        'class_ids': classIds,
        'notes': notes,
      };

  factory ProgramDayModel.fromMap(Map<String, dynamic> map) => ProgramDayModel(
        weekday: map['weekday'] as String? ?? '',
        classIds: (map['class_ids'] as List<dynamic>? ?? []).cast<String>(),
        notes: map['notes'] as String? ?? '',
      );
}

class ProgramModel {
  ProgramModel({
    required this.id,
    required this.name,
    required this.goal,
    required this.days,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String goal;
  final List<ProgramDayModel> days;
  final DateTime createdAt;

  ProgramModel copyWith({
    String? name,
    String? goal,
    List<ProgramDayModel>? days,
  }) => ProgramModel(
        id: id,
        name: name ?? this.name,
        goal: goal ?? this.goal,
        days: days ?? this.days,
        createdAt: createdAt,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'goal': goal,
        'created_at': createdAt.toIso8601String(),
        'days': days.map((e) => e.toMap()).toList(),
      };

  factory ProgramModel.fromMap(Map<String, dynamic> map) => ProgramModel(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        goal: map['goal'] as String? ?? '',
        createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
        days: (map['days'] as List<dynamic>? ?? [])
            .map((e) => ProgramDayModel.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
}
