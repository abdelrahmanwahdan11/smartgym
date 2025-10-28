import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../core/constants.dart';
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

  late final List<_NavigationItem> _items = [
    _NavigationItem(
      labelKey: 'home',
      icon: IconlyLight.home,
      page: const HomeDashboardPage(),
    ),
    _NavigationItem(
      labelKey: 'explore',
      icon: IconlyLight.discovery,
      page: const ClassesPage(embed: true),
    ),
    _NavigationItem(
      labelKey: 'gyms',
      icon: IconlyLight.work,
      page: const GymsPage(embed: true),
    ),
    _NavigationItem(
      labelKey: 'schedule',
      icon: IconlyLight.calendar,
      page: const SchedulePage(),
    ),
    _NavigationItem(
      labelKey: 'account',
      icon: IconlyLight.profile,
      page: const AccountPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppConstants.breakpointDesktopMin;
    final isTablet = width >= AppConstants.breakpointTabletMin && width < AppConstants.breakpointDesktopMin;
    final pages = _items.map((item) => item.page).toList(growable: false);
    final content = IndexedStack(index: _index, children: pages);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(width: 280, child: _buildDrawer(context)),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      );
    }

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            _buildRail(context, width),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: _items
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                label: item.labelKey.tr,
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: _index,
      onDestinationSelected: (value) => setState(() => _index = value),
      children: [
        const SizedBox(height: AppConstants.spacingLg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
          child: Text(
            'app_name'.tr,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),
        for (final item in _items)
          NavigationDrawerDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.icon, color: Theme.of(context).colorScheme.primary),
            label: Text(item.labelKey.tr),
          ),
      ],
    );
  }

  Widget _buildRail(BuildContext context, double width) {
    final extended = width >= 840;
    return NavigationRail(
      selectedIndex: _index,
      onDestinationSelected: (value) => setState(() => _index = value),
      extended: extended,
      labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
      destinations: _items
          .map(
            (item) => NavigationRailDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.icon, color: Theme.of(context).colorScheme.primary),
              label: Text(item.labelKey.tr),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.labelKey,
    required this.icon,
    required this.page,
  });

  final String labelKey;
  final IconData icon;
  final Widget page;
}
