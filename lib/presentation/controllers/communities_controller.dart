import 'dart:convert';

import 'package:get/get.dart';
import 'mixins/guarded_controller_mixin.dart';

import '../../core/app_initializer.dart';
import '../../data/models/community_post_model.dart';

class CommunitiesController extends GetxController with GuardedControllerMixin {
  final RxList<CommunityPostModel> posts = <CommunityPostModel>[].obs;

  static const _key = 'communities.posts';

  final List<String> communityFilters = const [
    'HIIT Crew',
    'Yoga Flow',
    'Strength Builders',
    'Mobility Reset',
  ];

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    final raw = AppInitializer.prefs.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => CommunityPostModel.fromMap(e as Map<String, dynamic>))
          .toList();
      posts.assignAll(list);
    }
  }

  Future<void> addPost(String community, String author, String text) async {
    final post = CommunityPostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      community: community,
      author: author,
      text: text,
      createdAt: DateTime.now(),
    );
    posts.insert(0, post);
    await _persist();
  }

  Future<void> addReply(String parentId, String author, String text) async {
    final index = posts.indexWhere((element) => element.id == parentId);
    if (index == -1) return;
    final parent = posts[index];
    final reply = CommunityPostModel(
      id: '${parentId}_${DateTime.now().millisecondsSinceEpoch}',
      community: parent.community,
      author: author,
      text: text,
      createdAt: DateTime.now(),
    );
    final updatedReplies = [...parent.replies, reply];
    posts[index] = parent.copyWith(replies: updatedReplies);
    await _persist();
  }

  List<CommunityPostModel> postsFor(String community) {
    return posts.where((element) => element.community == community).toList();
  }

  Future<void> _persist() async {
    await AppInitializer.prefs
        .setString(_key, jsonEncode(posts.map((e) => e.toMap()).toList()));
  }
}
