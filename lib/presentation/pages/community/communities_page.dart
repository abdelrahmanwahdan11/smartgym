import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/communities_controller.dart';
import '../../../core/routes/app_routes.dart';

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CommunitiesController controller = Get.find<CommunitiesController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('communities'.tr),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'gyms'.tr),
            Tab(text: 'goals'.tr),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showComposer(context),
        child: const Icon(Icons.edit),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CommunityList(controller: controller, filter: _gymCommunities()),
          _CommunityList(controller: controller, filter: _goalCommunities()),
        ],
      ),
    );
  }

  List<String> _gymCommunities() => controller.communityFilters.take(2).toList();

  List<String> _goalCommunities() => controller.communityFilters.skip(2).toList();

  Future<void> _showComposer(BuildContext context) async {
    String? selected = controller.communityFilters.first;
    final textController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('new_post'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: selected,
              items: controller.communityFilters
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => selected = value),
            ),
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'message'.tr),
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('cancel'.tr)),
          FilledButton(
            onPressed: () async {
              await controller.addPost(selected ?? controller.communityFilters.first, 'You', textController.text);
              Get.back();
            },
            child: Text('post'.tr),
          ),
        ],
      ),
    );
  }
}

class _CommunityList extends StatelessWidget {
  const _CommunityList({required this.controller, required this.filter});

  final CommunitiesController controller;
  final List<String> filter;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final communities = filter;
      return ListView(
        padding: const EdgeInsets.all(16),
        children: communities
            .map((community) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(community, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...controller.postsFor(community).map(
                      (post) => Card(
                        child: ListTile(
                          title: Text(post.text),
                          subtitle: Text('${post.author} • ${post.createdAt.toLocal().toString().split(' ').first}'),
                          onTap: () => Get.toNamed(AppRoutes.communityThread, arguments: post.id),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ))
            .toList(),
      );
    });
  }
}
