import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../core/routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../widgets/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _remember = false;

  AuthController get _auth => Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    final storedEmail = AppInitializer.prefs.getString('auth.remembered_email');
    if (storedEmail != null && storedEmail.isNotEmpty) {
      _remember = true;
      _emailController.text = storedEmail;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('login'.tr)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('app_name'.tr, style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'email'.tr),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.tr;
                    }
                    if (!value.contains('@')) {
                      return 'invalid_email'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'password'.tr,
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required_field'.tr;
                    }
                    if (value.length < 6) {
                      return 'min_password'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _remember,
                      onChanged: (value) {
                        setState(() => _remember = value ?? false);
                        if (!(value ?? false)) {
                          AppInitializer.prefs.remove('auth.remembered_email');
                        }
                      },
                    ),
                    Text('remember_me'.tr),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(
                  () => PrimaryButton(
                    label: _auth.isLoading.value ? 'loading'.tr : 'login'.tr,
                    onPressed: _auth.isLoading.value ? null : _login,
                  ),
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: 'signup'.tr,
                  onPressed: () => Get.toNamed(AppRoutes.signup),
                ),
                const SizedBox(height: 12),
                GhostButton(
                  label: 'guest'.tr,
                  onPressed: () async {
                    await _auth.continueAsGuest();
                    Get.offAllNamed(AppRoutes.home);
                  },
                ),
                const SizedBox(height: 12),
                Obx(() => Text(_auth.error.value, style: const TextStyle(color: Colors.red))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await _auth.login(_emailController.text.trim(), _passwordController.text.trim());
    if (success) {
      if (_remember) {
        await AppInitializer.prefs.setString('auth.remembered_email', _emailController.text.trim());
      } else {
        await AppInitializer.prefs.remove('auth.remembered_email');
      }
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
