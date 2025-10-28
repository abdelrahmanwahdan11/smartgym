import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      avatar: map['avatar'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }

  String toJsonString() => jsonEncode(toMap());

  factory UserModel.fromJsonString(String jsonStr) {
    return UserModel.fromMap(jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  factory UserModel.guest() => const UserModel(
        id: 'guest',
        name: 'Guest',
        email: 'guest@example.com',
        avatar: '',
      );
}
