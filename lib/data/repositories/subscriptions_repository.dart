import '../local_data/seed_loader.dart';
import '../models/subscription_plan_model.dart';

class SubscriptionsRepository {
  Future<List<SubscriptionPlanModel>> fetchPlans() async {
    final seed = SeedLoader.tryGet('assets/data/subscriptions.json');
    final items = seed?['items'] as List<dynamic>? ?? [];
    return items
        .map((e) => SubscriptionPlanModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
