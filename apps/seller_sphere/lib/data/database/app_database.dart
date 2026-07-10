import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const _databaseName = "sellersphere.db";
  static const _databaseVersion = 2; // Versi database dinaikkan

  // Tabel Products
  static const tableProducts = 'products';
  static const columnProductId = 'id';
  static const columnProductName = 'name';
  static const columnProductSku = 'sku';
  static const columnProductStock = 'stock';
  static const columnProductPurchasePrice = 'purchasePrice';
  static const columnProductSellingPrice = 'sellingPrice';
  static const columnProductCategory = 'category';
  static const columnProductMinStock = 'minStockThreshold';

  // Tabel SaleTransactions
  static const tableSaleTransactions = 'sale_transactions';
  static const columnTransactionId = 'id';
  static const columnTransactionTimestamp = 'timestamp';
  static const columnTransactionTotalAmount = 'totalAmount';
  static const columnTransactionTotalProfit = 'totalProfit';
  static const columnTransactionPaymentMethod = 'paymentMethod';

  // Tabel SaleItems
  static const tableSaleItems = 'sale_items';
  static const columnSaleItemId = 'id';
  static const columnSaleItemTransactionId = 'transactionId';
  static const columnSaleItemProductId = 'productId';
  static const columnSaleItemProductName = 'productName';
  static const columnSaleItemQuantity = 'quantity';
  static const columnSaleItemPurchasePrice = 'purchasePrice';
  static const columnSaleItemSellingPrice = 'sellingPrice';

  // Tabel SalesTargets
  static const tableSalesTargets = 'sales_targets';
  static const columnTargetDate = 'dateString';
  static const columnTargetAmount = 'targetAmount';

  AppDatabase._privateConstructor();
  static final AppDatabase instance = AppDatabase._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade, // Menambahkan handler onUpgrade
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProducts (
        $columnProductId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnProductName TEXT NOT NULL,
        $columnProductSku TEXT NOT NULL,
        $columnProductStock INTEGER NOT NULL DEFAULT 0,
        $columnProductPurchasePrice REAL NOT NULL DEFAULT 0.0,
        $columnProductSellingPrice REAL NOT NULL DEFAULT 0.0,
        $columnProductCategory TEXT NOT NULL DEFAULT 'Umum',
        $columnProductMinStock INTEGER NOT NULL DEFAULT 5
      )
      ''');

    await db.execute('''
      CREATE TABLE $tableSaleTransactions (
        $columnTransactionId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTransactionTimestamp INTEGER NOT NULL,
        $columnTransactionTotalAmount REAL NOT NULL DEFAULT 0.0,
        $columnTransactionTotalProfit REAL NOT NULL DEFAULT 0.0,
        $columnTransactionPaymentMethod TEXT NOT NULL DEFAULT 'Tunai'
      )
      ''');

    await db.execute('''
      CREATE TABLE $tableSaleItems (
        $columnSaleItemId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnSaleItemTransactionId INTEGER NOT NULL,
        $columnSaleItemProductId INTEGER NOT NULL,
        $columnSaleItemProductName TEXT NOT NULL,
        $columnSaleItemQuantity INTEGER NOT NULL,
        $columnSaleItemPurchasePrice REAL NOT NULL,
        $columnSaleItemSellingPrice REAL NOT NULL,
        FOREIGN KEY ($columnSaleItemTransactionId) REFERENCES $tableSaleTransactions ($columnTransactionId) ON DELETE CASCADE
      )
      ''');

    await db.execute('''
      CREATE TABLE $tableSalesTargets (
        $columnTargetDate TEXT PRIMARY KEY,
        $columnTargetAmount REAL NOT NULL DEFAULT 0.0
      )
      ''');
  }

  // Menghapus tabel lama dan membuat yang baru saat upgrade
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
      await db.execute('DROP TABLE IF EXISTS $tableProducts');
      await db.execute('DROP TABLE IF EXISTS $tableSaleTransactions');
      await db.execute('DROP TABLE IF EXISTS $tableSaleItems');
      await db.execute('DROP TABLE IF EXISTS $tableSalesTargets');
      await _onCreate(db, newVersion);
  }
}
