class BookingModel {
  final String id;
  final String userId;
  final String classId;
  final String status;
  final String token;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.classId,
    required this.status,
    required this.token,
    required this.createdAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) => BookingModel(
        id: map['id'] as String,
        userId: map['user_id'] as String? ?? '',
        classId: map['class_id'] as String? ?? '',
        status: map['status'] as String? ?? 'active',
        token: map['token'] as String? ?? '',
        createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
      );
}
