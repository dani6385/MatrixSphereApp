import 'package:seller_sphere/data/database/app_database.dart';

class Product {
  final int? id;
  final String name;
  final String sku;
  final int stock;
  final double purchasePrice;
  final double sellingPrice;
  final String category;
  final int minStockThreshold;

  Product({
    this.id,
    required this.name,
    this.sku = "",
    this.stock = 0,
    this.purchasePrice = 0.0,
    this.sellingPrice = 0.0,
    this.category = "Umum",
    this.minStockThreshold = 5,
  });

  bool get isLowStock => stock <= minStockThreshold;
  double get profitPerUnit => sellingPrice - purchasePrice;

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map[AppDatabase.columnProductId],
      name: map[AppDatabase.columnProductName],
      sku: map[AppDatabase.columnProductSku],
      stock: map[AppDatabase.columnProductStock],
      purchasePrice: map[AppDatabase.columnProductPurchasePrice],
      sellingPrice: map[AppDatabase.columnProductSellingPrice],
      category: map[AppDatabase.columnProductCategory],
      minStockThreshold: map[AppDatabase.columnProductMinStock],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppDatabase.columnProductId: id,
      AppDatabase.columnProductName: name,
      AppDatabase.columnProductSku: sku,
      AppDatabase.columnProductStock: stock,
      AppDatabase.columnProductPurchasePrice: purchasePrice,
      AppDatabase.columnProductSellingPrice: sellingPrice,
      AppDatabase.columnProductCategory: category,
      AppDatabase.columnProductMinStock: minStockThreshold,
    };
  }
}
