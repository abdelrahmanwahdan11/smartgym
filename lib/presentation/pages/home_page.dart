import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'account_page.dart';
import 'classes_page.dart';
import 'gyms_page.dart';
import 'home_dashboard_page.dart';
import 'schedule_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final List<Widget> _tabs = const [
    HomeDashboardPage(),
    ClassesPage(embed: true),
    GymsPage(embed: true),
    SchedulePage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(icon: const Icon(IconlyLight.home), label: 'home'.tr),
          NavigationDestination(icon: const Icon(IconlyLight.discovery), label: 'explore'.tr),
          NavigationDestination(icon: const Icon(IconlyLight.work), label: 'gyms'.tr),
          NavigationDestination(icon: const Icon(IconlyLight.calendar), label: 'schedule'.tr),
          NavigationDestination(icon: const Icon(IconlyLight.profile), label: 'account'.tr),
        ],
      ),
    );
  }
}
