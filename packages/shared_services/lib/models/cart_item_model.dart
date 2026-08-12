<<<<<<< HEAD
import 'package:shared_services/src/models/product_model.dart';

/// Model untuk item dalam keranjang belanja.
///
/// Menyimpan referensi ke produk dan jumlah yang dibeli.
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
    required String productId, required String productName, required double sellingPrice,
  });
}
=======
import 'package:shared_services/src/models/product_model.dart';

/// Model untuk item dalam keranjang belanja.
///
/// Menyimpan referensi ke produk dan jumlah yang dibeli.
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
    required String productId,
    required String productName,
    required double sellingPrice,
  });
}
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
