import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveMiniPage extends StatelessWidget {
  const LiveMiniPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = [
      {'title': 'HIIT Power 15', 'time': '18:00'},
      {'title': 'Mobility Reset', 'time': '19:30'},
    ];
    return Scaffold(
      appBar: AppBar(title: Text('live_mini'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...sessions.map((session) => Card(
                child: ListTile(
                  title: Text(session['title']!),
                  subtitle: Text(session['time']!),
                  trailing: FilledButton(
                    onPressed: () => Get.snackbar('live_mini'.tr, 'join'.tr),
                    child: Text('join'.tr),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
