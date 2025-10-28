import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../core/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    final completed = AppInitializer.prefs.getBool('onboarding.completed') ?? false;
    if (completed) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FlutterLogo(size: 120),
            const SizedBox(height: 24),
            Text('Gym Passport', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
