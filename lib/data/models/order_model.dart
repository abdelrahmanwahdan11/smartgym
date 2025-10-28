import 'dart:convert';

class OrderModel {
  final String id;
  final double total;
  final String status;
  final DateTime createdAt;
  final String note;

  const OrderModel({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
    this.note = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'total': total,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'note': note,
      };

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        id: map['id'] as String,
        total: (map['total'] as num?)?.toDouble() ?? 0,
        status: map['status'] as String? ?? 'success',
        createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
        note: map['note'] as String? ?? '',
      );

  String toJsonString() => jsonEncode(toMap());

  factory OrderModel.fromJsonString(String source) =>
      OrderModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
