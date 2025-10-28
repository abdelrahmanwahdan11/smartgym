import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  final _noteController = TextEditingController();
  bool _processing = false;

  CartController get _cart => Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('checkout'.tr)),
      body: Stepper(
        currentStep: _currentStep,
        controlsBuilder: (context, details) {
          return Row(
            children: [
              FilledButton(
                onPressed: _processing ? null : details.onStepContinue,
                child: Text(_currentStep == 2 ? 'confirm'.tr : 'next'.tr),
              ),
              const SizedBox(width: 12),
              if (_currentStep > 0)
                TextButton(
                  onPressed: _processing ? null : details.onStepCancel,
                  child: Text('back'.tr),
                ),
            ],
          );
        },
        onStepContinue: () async {
          if (_currentStep < 2) {
            setState(() => _currentStep += 1);
            return;
          }
          await _submitOrder();
        },
        onStepCancel: () {
          if (_currentStep == 0) {
            Get.back();
          } else {
            setState(() => _currentStep -= 1);
          }
        },
        steps: [
          Step(
            title: Text('checkout_review'.tr),
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 0,
            content: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _cart.items
                      .map((item) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('${item.qty} × ${item.name}'),
                            trailing: Text('${item.subtotal.toStringAsFixed(2)} USD'),
                          ))
                      .toList(),
                )),
          ),
          Step(
            title: Text('address_note'.tr),
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 1,
            content: TextField(
              controller: _noteController,
              minLines: 3,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'address_note_hint'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Step(
            title: Text('confirm_order'.tr),
            isActive: _currentStep >= 2,
            content: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('total'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('${_cart.itemCount} ${'items'.tr}',
                        style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    Text('${_cart.total.toStringAsFixed(2)} USD',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    if (_processing) const LinearProgressIndicator(),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (_processing) return;
    if (_cart.items.isEmpty) {
      Get.snackbar('cart'.tr, 'cart_empty'.tr);
      return;
    }
    setState(() => _processing = true);
    final success = await _cart.checkout(note: _noteController.text.trim());
    setState(() => _processing = false);
    if (!mounted) return;
    if (success) {
      Get.snackbar('success'.tr, 'checkout'.tr);
      Get.back();
      Get.back();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
