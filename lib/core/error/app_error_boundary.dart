import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AppErrorBoundary {
  const AppErrorBoundary._();

  static void install() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };
    ErrorWidget.builder = (details) => AppCrashScreen(message: details.exceptionAsString());
  }
}

class AppCrashScreen extends StatelessWidget {
  const AppCrashScreen({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.error_outline, size: 56, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text('unexpected_error'.tr, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              if (kDebugMode && message != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(message!, style: theme.textTheme.bodySmall),
                  ),
                )
              else
                Text('errors'.tr, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Get.offAllNamed(AppRoutes.splash),
                child: Text('retry'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
