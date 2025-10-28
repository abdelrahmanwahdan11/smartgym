import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = List.generate(10, (index) => index + 1);
    return Scaffold(
      appBar: AppBar(title: Text('notifications'.tr)),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) => ListTile(
          title: Text('${'notifications'.tr} ${notifications[index]}'),
          subtitle: Text('new_offers'.tr),
        ),
      ),
    );
  }
}
