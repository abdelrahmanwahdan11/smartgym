class MacroPlanModel {
  MacroPlanModel({
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.calories,
    required this.template,
  });

  final int proteinG;
  final int carbsG;
  final int fatG;
  final int calories;
  final String template;

  MacroPlanModel copyWith({
    int? proteinG,
    int? carbsG,
    int? fatG,
    int? calories,
    String? template,
  }) => MacroPlanModel(
        proteinG: proteinG ?? this.proteinG,
        carbsG: carbsG ?? this.carbsG,
        fatG: fatG ?? this.fatG,
        calories: calories ?? this.calories,
        template: template ?? this.template,
      );

  Map<String, dynamic> toMap() => {
        'protein_g': proteinG,
        'carbs_g': carbsG,
        'fat_g': fatG,
        'calories': calories,
        'template': template,
      };

  factory MacroPlanModel.fromMap(Map<String, dynamic> map) => MacroPlanModel(
        proteinG: map['protein_g'] as int? ?? 0,
        carbsG: map['carbs_g'] as int? ?? 0,
        fatG: map['fat_g'] as int? ?? 0,
        calories: map['calories'] as int? ?? 0,
        template: map['template'] as String? ?? 'custom',
      );
}
