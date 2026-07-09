
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart'; // File ini akan digenerasi oleh build_runner

// ---------------- DATABASE DEFINITION ----------------

@Database(version: 1, entities: [Product, SaleTransaction, SaleItem, SalesTarget])
abstract class AppDatabase extends FloorDatabase {
  ProductDao get productDao;
  TransactionDao get transactionDao;
  TargetDao get targetDao;
}

// Helper function untuk membuat instance database
Future<AppDatabase> getAppDatabase() async {
  return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
}

// ---------------- ENTITIES (MODEL DATA) ----------------

@Entity(tableName: 'products')
class Product {
  @PrimaryKey(autoGenerate: true)
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
    this.sku = '',
    this.stock = 0,
    this.purchasePrice = 0.0,
    this.sellingPrice = 0.0,
    this.category = 'Umum',
    this.minStockThreshold = 5,
  });

  Product copyWith({
    int? id,
    String? name,
    String? sku,
    int? stock,
    double? purchasePrice,
    double? sellingPrice,
    String? category,
    int? minStockThreshold,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      stock: stock ?? this.stock,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      category: category ?? this.category,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
    );
  }

  @ignore
  bool get isLowStock => stock <= minStockThreshold;

  @ignore
  double get profitPerUnit => sellingPrice - purchasePrice;
}

@Entity(tableName: 'sale_transactions')
class SaleTransaction {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int timestamp;
  final double totalAmount;
  final double totalProfit;
  final String paymentMethod;

  SaleTransaction({
    this.id,
    required this.timestamp,
    this.totalAmount = 0.0,
    this.totalProfit = 0.0,
    this.paymentMethod = 'Tunai',
  });
}

@Entity(
  tableName: 'sale_items',
  foreignKeys: [
    ForeignKey(
      childColumns: ['transactionId'],
      parentColumns: ['id'],
      entity: SaleTransaction,
    ),
    ForeignKey(
      childColumns: ['productId'],
      parentColumns: ['id'],
      entity: Product,
    )
  ],
)
class SaleItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int transactionId;
  final int productId;
  final String productName;
  final int quantity;
  final double purchasePrice;
  final double sellingPrice;

  SaleItem({
    this.id,
    required this.transactionId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.purchasePrice,
    required this.sellingPrice,
  });

  @ignore
  double get totalAmount => sellingPrice * quantity;

  @ignore
  double get totalProfit => (sellingPrice - purchasePrice) * quantity;
}

@Entity(tableName: 'sales_targets')
class SalesTarget {
  @PrimaryKey()
  final String dateString; // Format: YYYY-MM-DD
  final double targetAmount;

  SalesTarget({required this.dateString, this.targetAmount = 0.0});
}

// ---------------- DAOs (DATA ACCESS OBJECTS) ----------------

@Dao()
abstract class ProductDao {
  @Query('SELECT * FROM products ORDER BY name ASC')
  Stream<List<Product>> getAllProducts();

  @Query('SELECT * FROM products WHERE id = :id')
  Future<Product?> getProductById(int id);

  @Query('SELECT * FROM products WHERE sku = :sku LIMIT 1')
  Future<Product?> getProductBySku(String sku);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertProduct(Product product);

  @Update() // SUDAH DIPERBAIKI: huruf 'U' kapital
  Future<void> updateProduct(Product product);

  @Delete() // SUDAH DIPERBAIKI: huruf 'D' kapital
  Future<void> deleteProduct(Product product);

  @Query('SELECT * FROM products WHERE stock <= minStockThreshold ORDER BY stock ASC')
  Stream<List<Product>> getLowStockProducts();
}

@Dao()
abstract class TransactionDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertTransaction(SaleTransaction transaction);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSaleItem(SaleItem item);

  @Query('SELECT * FROM sale_transactions ORDER BY timestamp DESC')
  Stream<List<SaleTransaction>> getAllTransactions();

  @Query('SELECT * FROM sale_items WHERE transactionId = :transactionId')
  Stream<List<SaleItem>> getSaleItemsForTransaction(int transactionId);

  @Query('SELECT * FROM sale_items')
  Stream<List<SaleItem>> getAllSaleItems();

  @Query('SELECT * FROM sale_transactions WHERE timestamp >= :startTime AND timestamp <= :endTime ORDER BY timestamp DESC')
  Stream<List<SaleTransaction>> getTransactionsBetween(int startTime, int endTime);
}

@Dao()
abstract class TargetDao {
  @Query('SELECT * FROM sales_targets WHERE dateString = :dateString LIMIT 1')
  Stream<SalesTarget?> getTargetForDate(String dateString);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTarget(SalesTarget target);

  @Query('SELECT * FROM sales_targets')
  Stream<List<SalesTarget>> getAllTargets();
}
