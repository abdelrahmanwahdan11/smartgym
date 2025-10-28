import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../application/services/action_log.dart';
import '../../../application/services/i18n_audit_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../controllers/classes_controller.dart';
import '../../controllers/gyms_controller.dart';
import '../../controllers/store_controller.dart';

class QaToolsPage extends StatelessWidget {
  const QaToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final actionLog = Get.find<ActionLogService>();
    final i18nAudit = Get.find<I18nAuditService>();
    return Scaffold(
      appBar: AppBar(title: Text('qa_tools'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Obx(
            () => Card(
              child: ListTile(
                title: Text('i18n_audit'.tr),
                subtitle: Text('${'missing_keys'.tr}: ${i18nAudit.missingKeys.value}'),
                trailing: FilledButton(
                  onPressed: i18nAudit.runAudit,
                  child: Text('retry'.tr),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: Text('search_index'.tr),
              trailing: FilledButton(
                onPressed: () {
                  Get.find<ClassesController>().loadClasses();
                  if (Get.isRegistered<GymsController>()) {
                    Get.find<GymsController>().loadGyms();
                  }
                  if (Get.isRegistered<StoreController>()) {
                    Get.find<StoreController>().loadProducts();
                  }
                  Get.snackbar('success'.tr, 'done'.tr, snackPosition: SnackPosition.BOTTOM);
                },
                child: Text('rebuild'.tr),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: Text('${'action_log'.tr} (${actionLog.entries.length})'),
              subtitle: Text('copy'.tr),
              trailing: FilledButton(
                onPressed: () async {
                  final encoded = const JsonEncoder.withIndent('  ').convert(actionLog.entries);
                  await Clipboard.setData(ClipboardData(text: encoded));
                  Get.snackbar('copy_success'.tr, 'done'.tr);
                },
                child: Text('copy'.tr),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: Text('open_deep_link'.tr),
              subtitle: Text('deep_link_hint'.tr),
              onTap: () async {
                final controller = TextEditingController();
                final route = await showDialog<String?>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('deep_link'.tr),
                    content: TextField(
                        controller: controller,
                        decoration: InputDecoration(hintText: 'deep_link_placeholder'.tr)),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('cancel'.tr)),
                      FilledButton(onPressed: () => Navigator.of(context).pop(controller.text.trim()), child: Text('open'.tr)),
                    ],
                  ),
                );
                if (route != null && route.isNotEmpty) {
                  Get.toNamed(route);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: Text('security'.tr),
              trailing: FilledButton(
                onPressed: () => Get.toNamed(AppRoutes.settingsSecurity),
                child: Text('go'.tr),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
