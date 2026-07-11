
// This is a Dart conversion of the provided Kotlin code.
// Note: This code assumes you are using a persistence library like 'floor'
// which uses similar annotations to Room. You will need to add the 'floor'
// dependency to your pubspec.yaml and run the code generator.

import 'package:floor/floor.dart';

// --- Data Models ---

@entity
class Product {
  @primaryKey
  final int? id;
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
}

@entity
class SaleTransaction {
  @primaryKey
  final int? id;
  final int timestamp; // Using int for timestamp as in the original code (long)

  SaleTransaction({this.id, required this.timestamp});
}

@entity
class SaleItem {
  @primaryKey
  final int? id;
  final int transactionId;
  // You might want to add a foreign key constraint here
  final int productId;
  final int quantity;


  SaleItem({
    this.id,
    required this.transactionId,
    required this.productId,
    required this.quantity,
  });
}

@entity
class SalesTarget {
  @primaryKey
  final String dateString;
  final double targetAmount;

  SalesTarget({required this.dateString, required this.targetAmount});
}


// --- DAOs ---

@dao
abstract class ProductDao {
  @Query('SELECT * FROM Product ORDER BY name ASC')
  Stream<List<Product>> getAllProducts();

  @Query('SELECT * FROM Product WHERE id = :id')
  Future<Product?> getProductById(int id);

  @Query('SELECT * FROM Product WHERE sku = :sku LIMIT 1')
  Future<Product?> getProductBySku(String sku);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertProduct(Product product);

  @update
  Future<void> updateProduct(Product product);

  @delete
  Future<void> deleteProduct(Product product);

  @Query('SELECT * FROM Product WHERE stock <= minStockThreshold ORDER BY stock ASC')
  Stream<List<Product>> getLowStockProducts();
}

@dao
abstract class TransactionDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertTransaction(SaleTransaction transaction);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSaleItem(SaleItem item);

  @Query('SELECT * FROM SaleTransaction ORDER BY timestamp DESC')
  Stream<List<SaleTransaction>> getAllTransactions();

  @Query('SELECT * FROM SaleItem WHERE transactionId = :transactionId')
  Stream<List<SaleItem>> getSaleItemsForTransaction(int transactionId);

  @Query('SELECT * FROM SaleItem')
  Stream<List<SaleItem>> getAllSaleItems();

  @Query('SELECT * FROM SaleTransaction WHERE timestamp >= :startTime AND timestamp <= :endTime ORDER BY timestamp DESC')
  Stream<List<SaleTransaction>> getTransactionsBetween(int startTime, int endTime);
}

@dao
abstract class TargetDao {
  @Query('SELECT * FROM SalesTarget WHERE dateString = :dateString LIMIT 1')
  Stream<SalesTarget?> getTargetForDate(String dateString);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTarget(SalesTarget target);

  @Query('SELECT * FROM SalesTarget')
  Stream<List<SalesTarget>> getAllTargets();
}
