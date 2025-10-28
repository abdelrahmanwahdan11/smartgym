import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';

import '../controllers/auth_controller.dart';
import '../controllers/locale_controller.dart';
import '../controllers/theme_controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final locale = Get.find<LocaleController>();
    final auth = Get.find<AuthController>();
    final swatches = [
      const Color(0xFF00B3A4),
      const Color(0xFF0066FF),
      const Color(0xFFFF6B6B),
      const Color(0xFF7C4DFF),
      const Color(0xFFFFC107),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('account'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(() {
            final user = auth.currentUser.value;
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(user?.name ?? 'Guest'),
              subtitle: Text(user?.email ?? 'guest@example.com'),
            );
          }),
          const SizedBox(height: 16),
          Text('language'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<Locale>(
            segments: const [
              ButtonSegment(value: Locale('en', 'US'), label: Text('English')),
              ButtonSegment(value: Locale('ar', 'AR'), label: Text('العربية')),
            ],
            selected: {locale.locale.value},
            onSelectionChanged: (value) => locale.updateLocale(value.first),
          ),
          const SizedBox(height: 24),
          Text('color_picker'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 12,
                children: swatches
                    .map((c) => GestureDetector(
                          onTap: () => theme.updatePrimaryColor(c),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: c,
                            child: theme.primaryColor.value == c
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        ))
                    .toList(),
              )),
          const SizedBox(height: 16),
          Obx(() {
            final hsv = HSVColor.fromColor(theme.primaryColor.value);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider(
                  value: hsv.hue,
                  min: 0,
                  max: 360,
                  onChanged: (value) {
                    final updated = HSVColor.fromAHSV(hsv.alpha, value, hsv.saturation, hsv.value).toColor();
                    theme.updatePrimaryColor(updated);
                  },
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          Obx(
            () => SwitchListTile(
              title: Text('dark_mode'.tr),
              value: theme.isDarkMode.value,
              onChanged: theme.toggleDarkMode,
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            title: Text('settings'.tr),
            subtitle: const Text('Privacy, export data, developer mode'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.toNamed(AppRoutes.settings),
          ),
          ListTile(
            title: Text('qr_pass'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.toNamed(AppRoutes.qrPass),
          ),
          ListTile(
            title: Text('share_card'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.toNamed(AppRoutes.shareCard),
          ),
          ListTile(
            title: Text('cart'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.toNamed(AppRoutes.cart),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              await auth.logout();
              Get.offAllNamed(AppRoutes.login);
            },
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}
