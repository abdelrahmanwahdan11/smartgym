class ChallengeModel {
  ChallengeModel({
    required this.id,
    required this.title,
    required this.type,
    required this.start,
    required this.end,
    required this.goal,
    required this.joined,
    required this.progress,
  });

  final String id;
  final String title;
  final String type;
  final DateTime start;
  final DateTime end;
  final String goal;
  final bool joined;
  final double progress;

  ChallengeModel copyWith({
    bool? joined,
    double? progress,
  }) => ChallengeModel(
        id: id,
        title: title,
        type: type,
        start: start,
        end: end,
        goal: goal,
        joined: joined ?? this.joined,
        progress: progress ?? this.progress,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'type': type,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'goal': goal,
        'joined': joined,
        'progress': progress,
      };

  factory ChallengeModel.fromMap(Map<String, dynamic> map) => ChallengeModel(
        id: map['id'] as String? ?? '',
        title: map['title'] as String? ?? '',
        type: map['type'] as String? ?? '',
        start: DateTime.tryParse(map['start'] as String? ?? '') ?? DateTime.now(),
        end: DateTime.tryParse(map['end'] as String? ?? '') ?? DateTime.now().add(const Duration(days: 7)),
        goal: map['goal'] as String? ?? '',
        joined: map['joined'] as bool? ?? false,
        progress: (map['progress'] as num?)?.toDouble() ?? 0,
      );
}
