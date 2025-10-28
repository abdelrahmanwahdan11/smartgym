import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../core/validation/app_validators.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../widgets/buttons.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  AuthController get _auth => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('signup'.tr)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'name'.tr),
                  validator: AppValidators.requiredField,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'email'.tr),
                  validator: AppValidators.email,
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
                  validator: (value) => AppValidators.minLength(value, 6),
                ),
                const SizedBox(height: 24),
                PrimaryButton(label: 'signup'.tr, onPressed: _signup),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      avatar: '',
    );
    await _auth.signup(user);
    Get.offAllNamed(AppRoutes.home);
  }
}
