import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = List.generate(10, (index) => 'Notification ${index + 1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(notifications[index]),
          subtitle: const Text('New offers and class updates'),
        ),
      ),
    );
  }
}
