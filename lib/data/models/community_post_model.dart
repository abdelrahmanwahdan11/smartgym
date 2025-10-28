class CommunityPostModel {
  CommunityPostModel({
    required this.id,
    required this.community,
    required this.author,
    required this.text,
    required this.createdAt,
    this.replies = const [],
  });

  final String id;
  final String community;
  final String author;
  final String text;
  final DateTime createdAt;
  final List<CommunityPostModel> replies;

  CommunityPostModel copyWith({
    List<CommunityPostModel>? replies,
  }) => CommunityPostModel(
        id: id,
        community: community,
        author: author,
        text: text,
        createdAt: createdAt,
        replies: replies ?? this.replies,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'community': community,
        'author': author,
        'text': text,
        'created_at': createdAt.toIso8601String(),
        'replies': replies.map((e) => e.toMap()).toList(),
      };

  factory CommunityPostModel.fromMap(Map<String, dynamic> map) => CommunityPostModel(
        id: map['id'] as String? ?? '',
        community: map['community'] as String? ?? '',
        author: map['author'] as String? ?? '',
        text: map['text'] as String? ?? '',
        createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
        replies: (map['replies'] as List<dynamic>? ?? [])
            .map((e) => CommunityPostModel.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
}
