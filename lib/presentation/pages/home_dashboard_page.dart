import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/challenges_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/tag_pill.dart';
import '../widgets/rating_stars.dart';

class HomeDashboardPage extends GetView<HomeController> {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final challenges = Get.find<ChallengesController>();
    return RefreshIndicator(
      onRefresh: controller.loadHighlights,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('app_name'.tr),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => Get.toNamed(AppRoutes.classes),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('today_class'.tr, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (controller.suggestedClasses.isEmpty) {
                      return _emptyCard(context);
                    }
                    final today = controller.suggestedClasses.first;
                    return _ClassCard(title: today.title, subtitle: today.description);
                  }),
                  const SizedBox(height: 24),
                  Text('suggested'.tr, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: Obx(() => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.suggestedClasses.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final item = controller.suggestedClasses[index];
                            return _SuggestionCard(item: item.title, subtitle: item.level);
                          },
                        )),
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    final active = challenges.challenges.firstWhereOrNull((element) => element.joined);
                    if (active == null) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('challenge'.tr, style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 8),
                          Text(active.title, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(value: active.progress),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Text('promotions'.tr, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withOpacity(0.6),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Weekly unlimited classes',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white)),
                        const SizedBox(height: 8),
                        Text('Save 20% when you book 5 sessions',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('quick_links'.tr, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                    children: [
                      _QuickLink(
                        icon: IconlyLight.discovery,
                        label: 'classes'.tr,
                        onTap: () => Get.toNamed(AppRoutes.classes),
                      ),
                      _QuickLink(
                        icon: IconlyLight.work,
                        label: 'gyms'.tr,
                        onTap: () => Get.toNamed(AppRoutes.gyms),
                      ),
                      _QuickLink(
                        icon: IconlyLight.profile,
                        label: 'trainers'.tr,
                        onTap: () => Get.toNamed(AppRoutes.trainers),
                      ),
                      _QuickLink(
                        icon: IconlyLight.calendar,
                        label: 'schedule'.tr,
                        onTap: () => Get.toNamed(AppRoutes.schedule),
                      ),
                      _QuickLink(
                        icon: IconlyLight.buy,
                        label: 'store'.tr,
                        onTap: () => Get.toNamed(AppRoutes.store),
                      ),
                      _QuickLink(
                        icon: IconlyLight.shield_done,
                        label: 'share_card'.tr,
                        onTap: () => Get.toNamed(AppRoutes.shareCard),
                      ),
                      _QuickLink(
                        icon: IconlyLight.time_circle,
                        label: 'timers'.tr,
                        onTap: () => Get.toNamed(AppRoutes.timers),
                      ),
                      _QuickLink(
                        icon: IconlyLight.calendar,
                        label: 'program_designer'.tr,
                        onTap: () => Get.toNamed(AppRoutes.programDesigner),
                      ),
                      _QuickLink(
                        icon: IconlyLight.heart,
                        label: 'diet_planner'.tr,
                        onTap: () => Get.toNamed(AppRoutes.diet),
                      ),
                      _QuickLink(
                        icon: IconlyLight.activity,
                        label: 'hydration'.tr,
                        onTap: () => Get.toNamed(AppRoutes.hydration),
                      ),
                      _QuickLink(
                        icon: IconlyLight.chart,
                        label: 'steps'.tr,
                        onTap: () => Get.toNamed(AppRoutes.steps),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No class booked yet', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Explore classes to stay on track', style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          TagPill(label: 'HIIT'),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.item, required this.subtitle});

  final String item;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 6)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          RatingStars(rating: 4.5),
          const Spacer(),
          Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70)),
          const Spacer(),
          FilledButton(
            onPressed: () => Get.toNamed(AppRoutes.classes),
            child: Text('book'.tr),
          ),
        ],
      ),
    );
  }
}
