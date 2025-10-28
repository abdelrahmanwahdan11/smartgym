import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: ListView(
        children: const [
          ListTile(title: Text('Export data'), subtitle: Text('Download JSON export')), 
          ListTile(title: Text('Delete data'), subtitle: Text('Remove all local data')), 
          ListTile(title: Text('Developer mocks'), subtitle: Text('Toggle sensors, analytics, etc.')), 
        ],
      ),
    );
  }
}
