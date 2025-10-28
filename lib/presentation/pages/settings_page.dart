import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../core/routes/app_routes.dart';
import '../../data/local_data/seed_loader.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/locale_controller.dart';
import '../controllers/reminders_controller.dart';
import '../controllers/schedule_controller.dart';
import '../controllers/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final locale = Get.find<LocaleController>();
    final cart = Get.find<CartController>();
    final schedule = Get.find<ScheduleController>();
    final reminders = Get.find<RemindersController>();
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(
            () => SwitchListTile(
              title: Text('dark_mode'.tr),
              value: theme.isDarkMode.value,
              onChanged: theme.toggleDarkMode,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: Text('reset_theme'.tr),
            subtitle: Text('reset_theme_subtitle'.tr),
            onTap: () => theme.reset(),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('language'.tr),
            subtitle: Text(locale.locale.value.languageCode == 'ar' ? 'arabic'.tr : 'english'.tr),
            onTap: () => _showLanguageSheet(locale),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: Text('export_data'.tr),
            subtitle: Text('export_data_desc'.tr),
            onTap: () => _exportData(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text('delete_data'.tr),
            subtitle: Text('delete_data_desc'.tr),
            onTap: () => _confirmClear(context, theme, locale, cart, schedule, reminders, auth),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(LocaleController locale) {
    Get.bottomSheet(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              title: Text('english'.tr),
              onTap: () {
                locale.updateLocale(const Locale('en', 'US'));
                Get.back();
              },
            ),
            ListTile(
              title: Text('arabic'.tr),
              onTap: () {
                locale.updateLocale(const Locale('ar', 'AR'));
                Get.back();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Get.theme.colorScheme.surface,
    );
  }

  Future<void> _exportData(BuildContext context) async {
    Map<String, dynamic>? _decodeMap(String? source) {
      if (source == null || source.isEmpty) return null;
      return jsonDecode(source) as Map<String, dynamic>;
    }

    List<dynamic> _decodeList(String? source) {
      if (source == null || source.isEmpty) return [];
      return jsonDecode(source) as List<dynamic>;
    }

    final prefs = AppInitializer.prefs;
    final payload = {
      'theme.primary_color': prefs.getInt('theme.primary_color'),
      'theme.dark_mode': prefs.getBool('theme.dark_mode'),
      'locale.current': prefs.getString('locale.current'),
      'auth.user': _decodeMap(prefs.getString('auth.user')),
      'auth.remember': prefs.getBool('auth.remember'),
      'auth.email': prefs.getString('auth.email'),
      'cart.items': _decodeList(prefs.getString('cart.items')),
      'cart.orders': _decodeList(prefs.getString('cart.orders')),
      'schedule.bookings': _decodeList(prefs.getString('schedule.bookings')),
      'reminders.config': _decodeList(prefs.getString('reminders.config')),
    };
    final json = const JsonEncoder.withIndent('  ').convert(payload);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('export_data'.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(json, style: const TextStyle(fontFamily: 'monospace')),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: json));
              Get.back();
              Get.snackbar('export_data'.tr, 'copied'.tr);
            },
            child: Text('copy'.tr),
          ),
          TextButton(onPressed: () => Get.back(), child: Text('close'.tr)),
        ],
      ),
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    ThemeController theme,
    LocaleController locale,
    CartController cart,
    ScheduleController schedule,
    RemindersController reminders,
    AuthController auth,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_data'.tr),
        content: Text('delete_data_confirm'.tr),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('cancel'.tr)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text('delete'.tr)),
        ],
      ),
    );
    if (confirm != true) return;

    await cart.clear();
    await cart.clearOrders();
    await schedule.clearAll();
    reminders.clearAll();
    await auth.logout();

    final prefs = AppInitializer.prefs;
    const keys = [
      'theme.primary_color',
      'theme.dark_mode',
      'locale.current',
      'auth.user',
      'auth.remember',
      'auth.email',
      'cart.items',
      'cart.orders',
      'schedule.bookings',
      'reminders.config',
      'seed.accepted',
    ];
    for (final key in keys) {
      await prefs.remove(key);
    }

    theme.primaryColor.value = const Color(0xFF00B3A4);
    theme.isDarkMode.value = false;
    locale.locale.value = const Locale('en', 'US');
    Get.updateLocale(locale.locale.value);

    await SeedLoader.ensureSeedLoaded();
    Get.offAllNamed(AppRoutes.splash);
    Get.snackbar('settings'.tr, 'data_cleared'.tr);
  }
}
