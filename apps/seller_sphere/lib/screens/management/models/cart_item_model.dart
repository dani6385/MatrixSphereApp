// lib/screens/management/models/cart_item_model.dart

import 'package:shared_services/shared_services.dart';

class CartItemModel {
  final Product product;
  int quantity;

  CartItemModel({
    required this.product,
    required this.quantity,
  });
}