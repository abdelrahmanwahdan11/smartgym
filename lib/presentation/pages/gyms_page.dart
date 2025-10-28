import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../core/constants.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/gym_model.dart';
import '../controllers/gyms_controller.dart';
import '../widgets/m3_search_bar.dart';
import '../widgets/paginator_list.dart';
import '../widgets/rating_stars.dart';
import '../widgets/states.dart';

class GymsPage extends GetView<GymsController> {
  const GymsPage({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      bottom: !embed,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => M3SearchBar(
                    hintText: 'search_placeholder'.tr,
                    suggestions: controller.searchSuggestions,
                    onQueryChanged: controller.updateQuery,
                    onSubmitted: controller.updateQuery,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Obx(
                  () => _ViewModeSelector(
                    mode: controller.viewMode.value,
                    onChanged: controller.setViewMode,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Obx(
                  () => controller.viewMode.value == 'map'
                      ? const SizedBox.shrink()
                      : _DensitySelector(
                          density: controller.gridDensity.value,
                          onChanged: controller.setGridDensity,
                        ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Obx(
                  () => _AmenityChips(
                    options: controller.amenityOptions,
                    isSelected: controller.isAmenityActive,
                    onToggle: controller.toggleAmenity,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => _GymsContent(controller: controller)),
          ),
        ],
      ),
    );

    if (embed) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: Text('gyms'.tr)),
      body: body,
    );
  }
}

class _GymsContent extends StatelessWidget {
  const _GymsContent({required this.controller});

  final GymsController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    final mode = controller.viewMode.value;
    if (mode == 'map') {
      final gyms = controller.filteredGyms;
      if (gyms.isEmpty) {
        return Center(child: ListEmptyState(message: 'no_results'.tr));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
        child: _GymMapView(gyms: gyms, controller: controller),
      );
    }

    final items = controller.displayed.toList(growable: false);
    if (items.isEmpty) {
      return Center(child: ListEmptyState(message: 'no_results'.tr));
    }

    if (mode == 'grid') {
      return _GymGrid(
        controller: controller,
        items: items,
      );
    }

    return RefreshIndicator(
      displacement: 72,
      onRefresh: controller.refresh,
      child: PaginatorListView(
        itemCount: items.length,
        hasMore: controller.hasMore.value,
        onEndReached: controller.loadMore,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemBuilder: (context, index) {
          final gym = items[index];
          return _GymListTile(gym: gym);
        },
      ),
    );
  }
}

class _ViewModeSelector extends StatelessWidget {
  const _ViewModeSelector({required this.mode, required this.onChanged});

  final String mode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: [
        ButtonSegment<String>(
          value: 'list',
          icon: const Icon(Icons.view_list),
          label: Text('list'.tr),
        ),
        ButtonSegment<String>(
          value: 'grid',
          icon: const Icon(Icons.grid_view),
          label: Text('grid'.tr),
        ),
        ButtonSegment<String>(
          value: 'map',
          icon: const Icon(Icons.map),
          label: Text('map'.tr),
        ),
      ],
      selected: {mode},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

class _DensitySelector extends StatelessWidget {
  const _DensitySelector({required this.density, required this.onChanged});

  final String density;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('density'.tr, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(width: AppConstants.spacingSm),
        SegmentedButton<String>(
          segments: [
            ButtonSegment<String>(value: 'compact', label: Text('compact'.tr)),
            ButtonSegment<String>(value: 'comfortable', label: Text('comfortable'.tr)),
          ],
          selected: {density},
          onSelectionChanged: (selection) => onChanged(selection.first),
        ),
      ],
    );
  }
}

class _AmenityChips extends StatelessWidget {
  const _AmenityChips({
    required this.options,
    required this.isSelected,
    required this.onToggle,
  });

  final List<String> options;
  final bool Function(String value) isSelected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: AppConstants.spacingSm,
      runSpacing: AppConstants.spacingSm,
      children: options
          .map(
            (option) => FilterChip(
              label: Text(option),
              selected: isSelected(option),
              onSelected: (_) => onToggle(option),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _GymListTile extends StatelessWidget {
  const _GymListTile({required this.gym});

  final GymModel gym;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppConstants.spacingSm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: const Icon(IconlyLight.work),
        ),
        title: Text(gym.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(gym.locationText),
            const SizedBox(height: 4),
            RatingStars(rating: gym.rating),
            if (gym.amenities.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  gym.amenities.take(3).join(', '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
        trailing: gym.discount > 0
            ? Chip(
                avatar: const Icon(Icons.local_offer, size: 16),
                label: Text('-${gym.discount}%'),
              )
            : null,
        onTap: () => Get.toNamed('${AppRoutes.gymDetails}/${gym.id}'),
      ),
    );
  }
}

class _GymGrid extends StatelessWidget {
  const _GymGrid({required this.controller, required this.items});

  final GymsController controller;
  final List<GymModel> items;

  @override
  Widget build(BuildContext context) {
    final density = controller.gridDensity.value;
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= AppConstants.breakpointDesktopMin
        ? 3
        : width >= AppConstants.breakpointTabletMin
            ? 2
            : 1;
    final aspectRatio = density == 'compact' ? 1.05 : 0.9;

    return RefreshIndicator(
      displacement: 72,
      onRefresh: controller.refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (!controller.hasMore.value) {
            return false;
          }
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent * AppConstants.animationThreshold) {
            controller.loadMore();
          }
          return false;
        },
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppConstants.spacingMd,
            mainAxisSpacing: AppConstants.spacingMd,
            childAspectRatio: aspectRatio,
          ),
          itemCount: controller.hasMore.value ? items.length + 1 : items.length,
          itemBuilder: (context, index) {
            if (index >= items.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final gym = items[index];
            return _GymCard(gym: gym);
          },
        ),
      ),
    );
  }
}

class _GymCard extends StatelessWidget {
  const _GymCard({required this.gym});

  final GymModel gym;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLg)),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        onTap: () => Get.toNamed('${AppRoutes.gymDetails}/${gym.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      gym.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (gym.discount > 0)
                    Chip(
                      label: Text('-${gym.discount}%'),
                      avatar: const Icon(Icons.local_offer, size: 16),
                    ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(gym.locationText, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppConstants.spacingSm),
              RatingStars(rating: gym.rating),
              const Spacer(),
              Wrap(
                spacing: AppConstants.spacingSm,
                runSpacing: AppConstants.spacingXs,
                children: gym.amenities.take(4).map((amenity) {
                  return Chip(
                    label: Text(amenity),
                    backgroundColor: color.withOpacity(0.08),
                  );
                }).toList(growable: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GymMapView extends StatelessWidget {
  const _GymMapView({required this.gyms, required this.controller});

  final List<GymModel> gyms;
  final GymsController controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        child: InteractiveViewer(
          minScale: 0.85,
          maxScale: 2.5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                return Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.surface,
                              Theme.of(context).colorScheme.surfaceVariant,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _MapBackdropPainter(
                          lineColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.06),
                        ),
                      ),
                    ),
                    for (final gym in gyms)
                      Builder(
                        builder: (context) {
                          const markerSize = 32.0;
                          final normalized = controller.normalizedPositionFor(gym);
                          final rawLeft = normalized.dx * width;
                          final rawTop = normalized.dy * height;
                          final clampedLeft = rawLeft
                              .clamp(markerSize / 2, math.max(markerSize / 2, width - markerSize / 2))
                              .toDouble();
                          final clampedTop = rawTop
                              .clamp(markerSize / 2, math.max(markerSize / 2, height - markerSize / 2))
                              .toDouble();
                          return _GymMarker(
                            gym: gym,
                            left: clampedLeft - (markerSize / 2),
                            top: clampedTop - (markerSize / 2),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _GymMarker extends StatelessWidget {
  const _GymMarker({required this.gym, required this.left, required this.top});

  final GymModel gym;
  final double left;
  final double top;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Positioned(
      left: left,
      top: top,
      child: Tooltip(
        message: gym.name,
        child: GestureDetector(
          onTap: () => Get.toNamed('${AppRoutes.gymDetails}/${gym.id}'),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const SizedBox(
              width: 32,
              height: 32,
              child: Icon(Icons.location_on, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapBackdropPainter extends CustomPainter {
  _MapBackdropPainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.2;
    final secondaryPaint = Paint()
      ..color = lineColor.withOpacity(0.6)
      ..strokeWidth = 1.0;
    const step = 48.0;
    for (double offset = -size.height; offset < size.width; offset += step) {
      canvas.drawLine(Offset(offset, 0), Offset(offset + size.height, size.height), paint);
    }
    for (double offset = 0; offset < size.width + size.height; offset += step) {
      canvas.drawLine(Offset(offset, 0), Offset(0, offset), secondaryPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
