class ReportModel {
  final String id;
  final String postId;
  final String reason;
  final DateTime date;
  final String status;

  const ReportModel({
    required this.id,
    required this.postId,
    required this.reason,
    required this.date,
    this.status = 'pending',
  });

  ReportModel copyWith({String? status}) => ReportModel(
        id: id,
        postId: postId,
        reason: reason,
        date: date,
        status: status ?? this.status,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'post_id': postId,
        'reason': reason,
        'date': date.toIso8601String(),
        'status': status,
      };

  factory ReportModel.fromMap(Map<String, dynamic> map) => ReportModel(
        id: map['id'] as String,
        postId: map['post_id'] as String? ?? '',
        reason: map['reason'] as String? ?? '',
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
        status: map['status'] as String? ?? 'pending',
      );
}
