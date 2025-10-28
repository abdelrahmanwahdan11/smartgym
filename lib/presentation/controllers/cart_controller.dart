import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> items = <CartItemModel>[].obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _restoreCart();
    _restoreOrders();
  }

  Future<void> _restoreCart() async {
    final raw = AppInitializer.prefs.getString('cart.items');
    if (raw == null || raw.isEmpty) return;
    final list = (jsonDecode(raw) as List<dynamic>)
        .map((e) => CartItemModel.fromMap(e as Map<String, dynamic>))
        .toList();
    items.assignAll(list);
  }

  Future<void> _restoreOrders() async {
    final raw = AppInitializer.prefs.getString('cart.orders');
    if (raw == null || raw.isEmpty) return;
    final list = (jsonDecode(raw) as List<dynamic>)
        .map((e) => OrderModel.fromMap(e as Map<String, dynamic>))
        .toList();
    orders.assignAll(list);
  }

  Future<void> addProduct(ProductModel product) async {
    final index = items.indexWhere((element) => element.productId == product.id);
    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      items.add(CartItemModel(
        productId: product.id,
        name: product.name,
        price: product.price,
        quantity: 1,
        tags: product.tags,
      ));
    }
    await _persistCart();
  }

  Future<void> removeProduct(String productId) async {
    items.removeWhere((element) => element.productId == productId);
    await _persistCart();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final index = items.indexWhere((element) => element.productId == productId);
    if (index == -1) return;
    if (quantity <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: quantity);
    }
    await _persistCart();
  }

  Future<void> clearCart() async {
    items.clear();
    await _persistCart();
  }

  Future<void> clearOrders() async {
    orders.clear();
    await _persistOrders();
  }

  Future<bool> checkout({String note = ''}) async {
    if (items.isEmpty) return false;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final success = Random().nextBool();
    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      total: total,
      status: success ? 'success' : 'failed',
      createdAt: DateTime.now(),
      note: note,
    );
    orders.insert(0, order);
    await _persistOrders();
    if (success) {
      await clearCart();
    }
    return success;
  }

  double get total => items.fold(0, (previousValue, element) => previousValue + element.subtotal);

  int get itemCount => items.fold(0, (previousValue, element) => previousValue + element.quantity);

  Future<void> _persistCart() async {
    final encoded = jsonEncode(items.map((e) => e.toMap()).toList());
    await AppInitializer.prefs.setString('cart.items', encoded);
  }

  Future<void> _persistOrders() async {
    final encoded = jsonEncode(orders.map((e) => e.toMap()).toList());
    await AppInitializer.prefs.setString('cart.orders', encoded);
  }
}
