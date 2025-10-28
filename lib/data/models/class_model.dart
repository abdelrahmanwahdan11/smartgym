class ClassModel {
  final String id;
  final String title;
  final String type;
  final String level;
  final int durationMin;
  final String intensity;
  final int caloriesEst;
  final String gymId;
  final String trainerId;
  final DateTime startTime;
  final int capacity;
  final int booked;
  final List<String> requirements;
  final String description;

  ClassModel({
    required this.id,
    required this.title,
    required this.type,
    required this.level,
    required this.durationMin,
    required this.intensity,
    required this.caloriesEst,
    required this.gymId,
    required this.trainerId,
    required this.startTime,
    required this.capacity,
    required this.booked,
    required this.requirements,
    required this.description,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map) => ClassModel(
        id: map['id'] as String,
        title: map['title'] as String? ?? '',
        type: map['type'] as String? ?? '',
        level: map['level'] as String? ?? '',
        durationMin: map['duration_min'] as int? ?? 0,
        intensity: map['intensity'] as String? ?? '',
        caloriesEst: map['calories_est'] as int? ?? 0,
        gymId: map['gym_id'] as String? ?? '',
        trainerId: map['trainer_id'] as String? ?? '',
        startTime: DateTime.tryParse(map['start_time'] as String? ?? '') ?? DateTime.now(),
        capacity: map['capacity'] as int? ?? 0,
        booked: map['booked'] as int? ?? 0,
        requirements: (map['requirements'] as List<dynamic>? ?? []).cast<String>(),
        description: map['description'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'type': type,
        'level': level,
        'duration_min': durationMin,
        'intensity': intensity,
        'calories_est': caloriesEst,
        'gym_id': gymId,
        'trainer_id': trainerId,
        'start_time': startTime.toIso8601String(),
        'capacity': capacity,
        'booked': booked,
        'requirements': requirements,
        'description': description,
      };
}
