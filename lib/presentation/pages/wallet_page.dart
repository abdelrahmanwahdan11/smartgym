import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/subscription_plan_model.dart';
import '../../data/repositories/subscriptions_repository.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _repo = SubscriptionsRepository();
  List<SubscriptionPlanModel> _plans = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _repo.fetchPlans();
    setState(() => _plans = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Plans', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._plans.map((plan) => Card(
                child: ListTile(
                  title: Text(plan.name),
                  subtitle: Text(plan.perks.join(', ')),
                  trailing: Text('${plan.price.toStringAsFixed(0)} USD'),
                  onTap: () => Get.snackbar('Subscribed', plan.name),
                ),
              )),
          const SizedBox(height: 24),
          const Text('Loyalty points: 1200'),
        ],
      ),
    );
  }
}
