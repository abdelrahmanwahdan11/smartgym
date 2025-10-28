import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/qr_pass_controller.dart';

class QrPassPage extends GetView<QrPassController> {
  const QrPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('qr_pass'.tr)),
      body: Center(
        child: Obx(() {
          final grid = controller.buildPixelGrid();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.token.value, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: grid
                      .map((row) => Expanded(
                            child: Row(
                              children: row
                                  .map((active) => Expanded(
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          margin: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: active
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: controller.refresh, child: const Text('Refresh token')),
            ],
          );
        }),
      ),
    );
  }
}
