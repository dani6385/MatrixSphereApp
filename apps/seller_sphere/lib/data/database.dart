import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // required part for the generator

// --- Entity Definitions ---

@Entity()
class Product {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String sku;
  final double stock;
  final double minStockThreshold;

  Product({this.id, required this.name, required this.sku, required this.stock, required this.minStockThreshold});
}

@Entity()
class SaleTransaction {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int timestamp;

  SaleTransaction({this.id, required this.timestamp});
}

@Entity()
class SaleItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int transactionId;
  final int productId;
  final int quantity;

  SaleItem({this.id, required this.transactionId, required this.productId, required this.quantity});
}

@Entity()
class SalesTarget {
  @PrimaryKey()
  final String dateString; // YYYY-MM-DD
  final double targetAmount;

  SalesTarget({required this.dateString, required this.targetAmount});
}


// --- DAO Definitions ---

@dao
abstract class ProductDao {
  @Query('SELECT * FROM Product')
  Future<List<Product>> findAllProducts();

  @Insert()
  Future<void> insertProduct(Product product);
}

@dao
abstract class TransactionDao {
  @Insert()
  Future<int> insertTransaction(SaleTransaction transaction); // Returns the id of the inserted row

  @Query('SELECT * FROM SaleItem WHERE transactionId = :transactionId')
  Future<List<SaleItem>> findItemsForTransaction(int transactionId);
  
  @Insert()
  Future<void> insertSaleItem(SaleItem item);
}

@dao
abstract class TargetDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTarget(SalesTarget target);

  @Query('SELECT * FROM SalesTarget WHERE dateString = :dateString')
  Future<SalesTarget?> findTargetByDate(String dateString);
}


// --- Database Class ---

@Database(version: 3, entities: [Product, SaleTransaction, SaleItem, SalesTarget])
abstract class AppDatabase extends FloorDatabase {
  ProductDao get productDao;
  TransactionDao get transactionDao;
  TargetDao get targetDao;
}

// --- Singleton Database Provider ---

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  static AppDatabase? _database;

  Future<AppDatabase> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await _initDB();
    return _database!;
  }

  // ignore: strict_top_level_inference
  _initDB() async {
    return await $FloorAppDatabase
        .databaseBuilder('sellersphere_database.db')
        .build();
  }
}
