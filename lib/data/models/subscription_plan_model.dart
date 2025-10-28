class SubscriptionPlanModel {
  final String id;
  final String name;
  final String period;
  final double price;
  final String limits;
  final List<String> perks;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.period,
    required this.price,
    required this.limits,
    required this.perks,
  });

  factory SubscriptionPlanModel.fromMap(Map<String, dynamic> map) => SubscriptionPlanModel(
        id: map['id'] as String,
        name: map['name'] as String? ?? '',
        period: map['period'] as String? ?? '',
        price: (map['price'] as num? ?? 0).toDouble(),
        limits: map['limits'] as String? ?? '',
        perks: (map['perks'] as List<dynamic>? ?? []).cast<String>(),
      );
}
