import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
// --- Data Models (simplified for RTDB) ---
final logger = Logger(); 

class Product {
  final String? id;
  final String name;
  final String sku;
  final double stock;
  final double minStockThreshold;

  Product({
    this.id,
    required this.name,
    required this.sku,
    required this.stock,
    required this.minStockThreshold,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sku': sku,
        'stock': stock,
        'minStockThreshold': minStockThreshold,
      };
}

class SaleTransaction {
  final String? id;
  final int timestamp;
  final List<SaleItem> items;

  SaleTransaction({this.id, required this.timestamp, required this.items});

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'items': items.map((item) => item.toJson()).toList(),
      };
}

class SaleItem {
  final String productId;
  final int quantity;

  SaleItem({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
      };
}

class SalesTarget {
  final String dateString;
  final double targetAmount;

  SalesTarget({required this.dateString, required this.targetAmount});

  Map<String, dynamic> toJson() => {
        'targetAmount': targetAmount,
      };
}

// --- RTDB Service ---

class RTDBService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Private constructor
  RTDBService._();

  // Singleton instance
  static final RTDBService _instance = RTDBService._();

  // Getter for the instance
  static RTDBService get instance => _instance;

  Future<void> uploadProduct(Product product) async {
    try {
      DatabaseReference newProductRef = _dbRef.child('seller_sphere/products').push();
      await newProductRef.set(product.toJson());
      logger.e ('Product uploaded successfully with key: ${newProductRef.key}');
    } catch (e) {
      logger.e ('Error uploading product: $e');
      rethrow; // Re-throw the error to be handled by the caller
    }
  }

  Future<void> uploadSale(SaleTransaction sale) async {
    try {
      DatabaseReference newSaleRef = _dbRef.child('seller_sphere/sales').push();
      await newSaleRef.set(sale.toJson());
      logger.e ('Sale uploaded successfully with key: ${newSaleRef.key}');
    } catch (e) {
      logger.e ('Error uploading sale: $e');
      rethrow;
    }
  }

  Future<void> uploadSalesTarget(SalesTarget target) async {
    try {
      // Use dateString as the key for sales targets for easy lookup
      await _dbRef.child('seller_sphere/sales_targets/${target.dateString}').set(target.toJson());
      logger.e ('Sales target for ${target.dateString} uploaded successfully.');
    } catch (e) {
      logger.e('Error uploading sales target: $e');
      rethrow;
    }
  }
}
