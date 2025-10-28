import 'dart:convert';

class BookingModel {
  final String id;
  final String userId;
  final String classId;
  final String status;
  final String token;
  final DateTime createdAt;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? title;

  BookingModel({
    required this.id,
    required this.userId,
    required this.classId,
    required this.status,
    required this.token,
    required this.createdAt,
    this.startTime,
    this.endTime,
    this.title,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) => BookingModel(
        id: map['id'] as String,
        userId: map['user_id'] as String? ?? '',
        classId: map['class_id'] as String? ?? '',
        status: map['status'] as String? ?? 'active',
        token: map['token'] as String? ?? '',
        createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
        startTime: DateTime.tryParse(map['start_time'] as String? ?? ''),
        endTime: DateTime.tryParse(map['end_time'] as String? ?? ''),
        title: map['title'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'class_id': classId,
        'status': status,
        'token': token,
        'created_at': createdAt.toIso8601String(),
        if (startTime != null) 'start_time': startTime!.toIso8601String(),
        if (endTime != null) 'end_time': endTime!.toIso8601String(),
        if (title != null) 'title': title,
      };

  String toJsonString() => jsonEncode(toMap());

  factory BookingModel.fromJsonString(String source) =>
      BookingModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
