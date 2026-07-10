
import 'package:seller_sphere/data/models/product_model.dart';
import 'package:shared_services/shared_services.dart';

class AppRepository {
  final RtdbService _rtdbService;

  AppRepository(this._rtdbService);

  // Example: Get all products
  Stream<List<Product>> getProducts() {
    return _rtdbService.onValue('products').map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return data.entries.map((e) => Product.fromMap(Map<String, dynamic>.from(e.value), e.key)).toList();
      } else {
        return [];
      }
    });
  }

  // Example: Add a new product
  Future<void> addProduct(Product product) async {
    final newProductRef = _rtdbService.ref('products').push();
    await newProductRef.set(product.toMap());
  }

  // Example: Update a product
  Future<void> updateProduct(Product product) async {
    await _rtdbService.updateData('products/${product.id}', product.toMap());
  }

  // Example: Delete a product
  Future<void> deleteProduct(String productId) async {
    await _rtdbService.deleteData('products/$productId');
  }
}
