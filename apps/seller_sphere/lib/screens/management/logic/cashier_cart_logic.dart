
// lib/screens/management/logic/cashier_cart_logic.dart

import 'package:shared_services/shared_services.dart';
import '../models/cart_item_model.dart';

class CashierCartLogic {
  final List<CartItemModel> cartItems = [];
  double cashPaid = 0.0;

  double get totalAmount => cartItems.fold(
      0, (sum, item) => sum + (item.product.sellingPrice * item.quantity));

  double get changeAmount =>
      cashPaid > totalAmount ? cashPaid - totalAmount : 0.0;
      
  bool get isCashValid => cashPaid >= totalAmount;

  void updateCashPaid(String value) {
    cashPaid = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
  }

  String? addProductToCart(Product product) {
    if (product.stock <= 0) {
      return 'Stok ${product.name} habis!';
    }
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1 && cartItems[index].quantity < product.stock) {
      cartItems[index].quantity++;
    } else if (index == -1) {
      cartItems.add(CartItemModel(product: product, quantity: 1));
    }
    return null;
  }

  String? updateQuantity(int index, int newQuantity) {
    final product = cartItems[index].product;
    if (newQuantity > product.stock) {
      return 'Stok ${product.name} tidak mencukupi.';
    }
    cartItems[index].quantity = newQuantity;
    return null;
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  void clearCart() {
    cartItems.clear();
  }
}
