class BuddyProfileModel {
  BuddyProfileModel({
    required this.id,
    required this.name,
    required this.goals,
    required this.availableDays,
    required this.nearbyGymIds,
  });

  final String id;
  final String name;
  final List<String> goals;
  final List<String> availableDays;
  final List<String> nearbyGymIds;

  BuddyProfileModel copyWith({
    String? name,
    List<String>? goals,
    List<String>? availableDays,
    List<String>? nearbyGymIds,
  }) => BuddyProfileModel(
        id: id,
        name: name ?? this.name,
        goals: goals ?? this.goals,
        availableDays: availableDays ?? this.availableDays,
        nearbyGymIds: nearbyGymIds ?? this.nearbyGymIds,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'goals': goals,
        'available_days': availableDays,
        'nearby_gym_ids': nearbyGymIds,
      };

  factory BuddyProfileModel.fromMap(Map<String, dynamic> map) => BuddyProfileModel(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        goals: (map['goals'] as List<dynamic>? ?? []).cast<String>(),
        availableDays: (map['available_days'] as List<dynamic>? ?? []).cast<String>(),
        nearbyGymIds: (map['nearby_gym_ids'] as List<dynamic>? ?? []).cast<String>(),
      );
}
