class InjuryAdaptModel {
  InjuryAdaptModel({
    required this.enabled,
    required this.disallowedMovements,
    required this.alternativesNote,
  });

  final bool enabled;
  final List<String> disallowedMovements;
  final String alternativesNote;

  InjuryAdaptModel copyWith({
    bool? enabled,
    List<String>? disallowedMovements,
    String? alternativesNote,
  }) => InjuryAdaptModel(
        enabled: enabled ?? this.enabled,
        disallowedMovements: disallowedMovements ?? this.disallowedMovements,
        alternativesNote: alternativesNote ?? this.alternativesNote,
      );

  Map<String, dynamic> toMap() => {
        'enabled': enabled,
        'disallowed_movements': disallowedMovements,
        'alternatives_note': alternativesNote,
      };

  factory InjuryAdaptModel.fromMap(Map<String, dynamic> map) => InjuryAdaptModel(
        enabled: map['enabled'] as bool? ?? false,
        disallowedMovements: (map['disallowed_movements'] as List<dynamic>? ?? []).cast<String>(),
        alternativesNote: map['alternatives_note'] as String? ?? '',
      );
}
