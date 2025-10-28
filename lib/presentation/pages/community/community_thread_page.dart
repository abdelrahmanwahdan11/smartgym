import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/communities_controller.dart';
import '../../../data/models/community_post_model.dart';

class CommunityThreadPage extends StatefulWidget {
  const CommunityThreadPage({super.key});

  @override
  State<CommunityThreadPage> createState() => _CommunityThreadPageState();
}

class _CommunityThreadPageState extends State<CommunityThreadPage> {
  final CommunitiesController controller = Get.find<CommunitiesController>();
  late final CommunityThreadEntry? entry;
  final TextEditingController replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final postId = Get.arguments as String;
    entry = _findPost(postId);
  }

  CommunityThreadEntry? _findPost(String id) {
    for (final post in controller.posts) {
      if (post.id == id) {
        return CommunityThreadEntry(root: post);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final current = entry;
    if (current == null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text('no_results'.tr)));
    }
    return Scaffold(
      appBar: AppBar(title: Text(current.root.community)),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final refreshed = controller.posts.firstWhereOrNull((p) => p.id == current.root.id);
              if (refreshed == null) {
                return Center(child: Text('no_results'.tr));
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: ListTile(
                      title: Text(refreshed.text),
                      subtitle: Text('${refreshed.author} • ${refreshed.createdAt.toLocal().toString().split(' ').first}'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('replies'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...refreshed.replies.map((reply) => Card(
                        child: ListTile(
                          title: Text(reply.text),
                          subtitle: Text('${reply.author} • ${reply.createdAt.toLocal().toString().split(' ').first}'),
                        ),
                      )),
                ],
              );
            }),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: replyController,
                      decoration: InputDecoration(labelText: 'reply'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () async {
                      if (replyController.text.isEmpty) return;
                      await controller.addReply(current.root.id, 'You', replyController.text);
                      replyController.clear();
                    },
                    child: Text('post'.tr),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityThreadEntry {
  CommunityThreadEntry({required this.root});

  final CommunityPostModel root;
}
