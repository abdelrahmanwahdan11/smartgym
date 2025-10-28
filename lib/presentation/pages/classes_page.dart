import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/class_model.dart';
import '../../data/models/injury_adapt_model.dart';
import '../controllers/classes_controller.dart';
import '../controllers/injury_controller.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/states.dart';
import '../widgets/tag_pill.dart';

class ClassesPage extends GetView<ClassesController> {
  const ClassesPage({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final injury = Get.find<InjuryController>();

    Widget body = RefreshIndicator(
      onRefresh: controller.refresh,
      displacement: 72,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GradientAppBar(
            title: Text('classes'.tr),
            subtitle: Text('refine_results'.tr),
            actions: [
              Obx(() {
                final isActive = controller.favoritesOnly.value;
                return IconButton(
                  tooltip: 'favorites'.tr,
                  onPressed: () => controller.setFavoritesOnly(!isActive),
                  isSelected: isActive,
                  icon: const Icon(Icons.favorite_outline),
                  selectedIcon: const Icon(Icons.favorite_rounded),
                );
              }),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
                vertical: AppConstants.spacingMd,
              ),
              child: Column(
                children: [
                  DebouncedSearchBar(
                    hintText: 'search_placeholder'.tr,
                    onChanged: controller.updateQuery,
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  _ViewModeToggle(
                    controller: controller,
                    onFiltersTap: () => _openFiltersSheet(context, controller),
                  ),
                ],
              ),
            ),
          ),
          _QuickFilterHeader(controller: controller),
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppConstants.spacingXl),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            final items = controller.displayed.toList();
            final hasMore = controller.hasMore.value;
            final adaptation = injury.adaptation.value;
            final density = controller.gridDensity.value;

            if (items.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingLg,
                    vertical: AppConstants.spacingXl,
                  ),
                  child: ListEmptyState(message: 'no_results'.tr),
                ),
              );
            }

            final width = MediaQuery.of(context).size.width;
            if (controller.isGrid) {
              return _ClassGrid(
                items: items,
                hasMore: hasMore,
                controller: controller,
                adaptation: adaptation,
                width: width,
                density: density,
              );
            }
            return _ClassList(
              items: items,
              hasMore: hasMore,
              controller: controller,
              adaptation: adaptation,
            );
          }),
        ],
      ),
    );

    if (embed) {
      return body;
    }

    body = Directionality(
      textDirection: Directionality.of(context),
      child: body,
    );

    return Scaffold(body: body);
  }

  void _openFiltersSheet(BuildContext context, ClassesController controller) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterSheet(controller: controller),
    );
  }
}

class _ViewModeToggle extends StatelessWidget {
  const _ViewModeToggle({
    required this.controller,
    required this.onFiltersTap,
  });

  final ClassesController controller;
  final VoidCallback onFiltersTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Obx(() {
      final isGrid = controller.isGrid;
      final density = controller.gridDensity.value;
      return Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: Text('favorites'.tr),
                selected: controller.favoritesOnly.value,
                onSelected: controller.setFavoritesOnly,
              ),
            ),
          ),
          IconButton(
            tooltip: 'list'.tr,
            onPressed: () => controller.setViewMode('list'),
            isSelected: !isGrid,
            icon: const Icon(Icons.view_list_rounded),
            selectedIcon: Icon(
              Icons.view_list_rounded,
              color: colorScheme.primary,
            ),
          ),
          IconButton(
            tooltip: 'grid'.tr,
            onPressed: () => controller.setViewMode('grid'),
            isSelected: isGrid,
            icon: const Icon(Icons.grid_view_rounded),
            selectedIcon: Icon(
              Icons.grid_view_rounded,
              color: colorScheme.primary,
            ),
          ),
          if (isGrid)
            PopupMenuButton<String>(
              tooltip: 'grid_density'.tr,
              icon: const Icon(Icons.density_medium_rounded),
              onSelected: controller.setGridDensity,
              initialValue: density,
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'compact',
                  child: Text('compact'.tr),
                ),
                PopupMenuItem<String>(
                  value: 'comfortable',
                  child: Text('comfortable'.tr),
                ),
              ],
            ),
          IconButton(
            tooltip: 'filters'.tr,
            onPressed: onFiltersTap,
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      );
    });
  }
}

class _QuickFilterHeader extends StatelessWidget {
  const _QuickFilterHeader({required this.controller});

  final ClassesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final quickFilters = controller.quickFilters;
      if (quickFilters.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }
      final colorScheme = Theme.of(context).colorScheme;
      return SliverPersistentHeader(
        pinned: true,
        delegate: _QuickFilterDelegate(
          controller: controller,
          color: colorScheme.surface,
          filters: quickFilters,
        ),
      );
    });
  }
}

class _QuickFilterDelegate extends SliverPersistentHeaderDelegate {
  _QuickFilterDelegate({
    required this.controller,
    required this.color,
    required this.filters,
  });

  final ClassesController controller;
  final Color color;
  final List<String> filters;

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final background = color.withOpacity(overlapsContent ? 0.96 : 0.9);
    return Container(
      color: background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingSm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (final filter in filters)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  end: AppConstants.spacingSm,
                ),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: controller.isFilterActive('type', filter),
                  onSelected: (_) => controller.toggleFilter('type', filter),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _QuickFilterDelegate oldDelegate) {
    return oldDelegate.filters != filters || oldDelegate.color != color;
  }
}

class _ClassList extends StatelessWidget {
  const _ClassList({
    required this.items,
    required this.hasMore,
    required this.controller,
    required this.adaptation,
  });

  final List<ClassModel> items;
  final bool hasMore;
  final ClassesController controller;
  final InjuryAdaptModel adaptation;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= items.length) {
            controller.loadMore();
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: AppConstants.spacingLg),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final item = items[index];
          final caution = _hasCaution(adaptation, item);
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLg,
              vertical: AppConstants.spacingSm,
            ),
            child: _ClassCard(
              item: item,
              caution: caution,
              isFavorite: controller.isFavorite(item.id),
              onFavorite: () => controller.toggleFavorite(item.id),
              onTap: () => Get.toNamed(
                '${AppRoutes.classDetails}/${item.id}',
                arguments: item,
              ),
              isGrid: false,
            ),
          );
        },
        childCount: items.length + (hasMore ? 1 : 0),
      ),
    );
  }

  bool _hasCaution(InjuryAdaptModel adaptation, ClassModel item) {
    if (!adaptation.enabled) {
      return false;
    }
    final description = item.description.toLowerCase();
    return adaptation.disallowedMovements.any(
      (movement) => description.contains(movement.toLowerCase().split(' ').first),
    );
  }
}

class _ClassGrid extends StatelessWidget {
  const _ClassGrid({
    required this.items,
    required this.hasMore,
    required this.controller,
    required this.adaptation,
    required this.width,
    required this.density,
  });

  final List<ClassModel> items;
  final bool hasMore;
  final ClassesController controller;
  final InjuryAdaptModel adaptation;
  final double width;
  final String density;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = _gridCount(width, density);
    final aspectRatio = density == 'compact' ? 0.95 : 0.78;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingSm,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: AppConstants.spacingSm,
          crossAxisSpacing: AppConstants.spacingSm,
          childAspectRatio: aspectRatio,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= items.length) {
              controller.loadMore();
              return const Center(child: CircularProgressIndicator());
            }
            final item = items[index];
            final caution = _hasCaution(adaptation, item);
            return _ClassCard(
              item: item,
              caution: caution,
              isFavorite: controller.isFavorite(item.id),
              onFavorite: () => controller.toggleFavorite(item.id),
              onTap: () => Get.toNamed(
                '${AppRoutes.classDetails}/${item.id}',
                arguments: item,
              ),
              isGrid: true,
            );
          },
          childCount: items.length + (hasMore ? 1 : 0),
        ),
      ),
    );
  }

  int _gridCount(double width, String density) {
    if (width >= AppConstants.breakpointDesktopMin) {
      return density == 'compact' ? 4 : 3;
    }
    if (width >= AppConstants.breakpointTabletMin) {
      return density == 'compact' ? 3 : 2;
    }
    return density == 'compact' ? 2 : 2;
  }

  bool _hasCaution(InjuryAdaptModel adaptation, ClassModel item) {
    if (!adaptation.enabled) {
      return false;
    }
    final description = item.description.toLowerCase();
    return adaptation.disallowedMovements.any(
      (movement) => description.contains(movement.toLowerCase().split(' ').first),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.item,
    required this.caution,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
    required this.isGrid,
  });

  final ClassModel item;
  final bool caution;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tags = [
      item.type,
      item.level,
      '${item.durationMin} min',
      item.intensity,
    ];
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_outline,
                ),
                color: isFavorite ? colorScheme.primary : null,
                tooltip: isFavorite
                    ? 'remove_favorite'.tr
                    : 'add_favorite'.tr,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Wrap(
            spacing: AppConstants.spacingSm,
            runSpacing: AppConstants.spacingXs,
            children: [
              for (final tag in tags) TagPill(label: tag),
              if (caution)
                Chip(
                  label: Text('injury_mode'.tr),
                  backgroundColor: colorScheme.errorContainer,
                  labelStyle:
                      TextStyle(color: colorScheme.onErrorContainer),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: isGrid ? 3 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: AppConstants.spacingXs),
              Text(
                _formatTime(item.startTime),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Spacer(),
              Text(
                '${(item.capacity - item.booked).clamp(0, item.capacity)} / ${item.capacity}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet({required this.controller});

  final ClassesController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      maxChildSize: 0.9,
      minChildSize: 0.45,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusXl),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                    ),
                  ),
                ),
                _FilterSection(
                  title: 'type'.tr,
                  options: controller.types,
                  filterKey: 'type',
                  controller: controller,
                ),
                _FilterSection(
                  title: 'level'.tr,
                  options: controller.levels,
                  filterKey: 'level',
                  controller: controller,
                ),
                _FilterSection(
                  title: 'intensity'.tr,
                  options: controller.intensities,
                  filterKey: 'intensity',
                  controller: controller,
                ),
                _FilterSection(
                  title: 'duration'.tr,
                  options: controller.durationOptions,
                  filterKey: 'duration',
                  controller: controller,
                ),
                _FilterSection(
                  title: 'equipment'.tr,
                  options: controller.equipments,
                  filterKey: 'equipment',
                  controller: controller,
                ),
                const SizedBox(height: AppConstants.spacingLg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.clearFilters,
                        child: Text('reset'.tr),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('done'.tr),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.options,
    required this.filterKey,
    required this.controller,
  });

  final String title;
  final List<String> options;
  final String filterKey;
  final ClassesController controller;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppConstants.spacingSm),
          Wrap(
            spacing: AppConstants.spacingSm,
            runSpacing: AppConstants.spacingSm,
            children: [
              for (final option in options)
                Obx(() {
                  final selected = controller.isFilterActive(filterKey, option);
                  return FilterChip(
                    label: Text(option),
                    selected: selected,
                    onSelected: (_) => controller.toggleFilter(filterKey, option),
                  );
                }),
            ],
          ),
        ],
      ),
    );
  }
}
