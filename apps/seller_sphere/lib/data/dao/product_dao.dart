import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/models.dart';

abstract class ProductDao {
  Stream<List<Product>> getAllProducts();
  Stream<List<Product>> getLowStockProducts();
  Future<void> insertProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(Product product);
  Future<Product?> getProductById(int id);
  Future<Product?> getProductBySku(String sku);
}

class ProductDaoImpl implements ProductDao {
  final AppDatabase _appDatabase;

  ProductDaoImpl(this._appDatabase);

  @override
  Stream<List<Product>> getAllProducts() async* {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(AppDatabase.tableProducts);
    yield List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  @override
  Stream<List<Product>> getLowStockProducts() async* {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppDatabase.tableProducts,
      where: '${AppDatabase.columnProductStock} <= ${AppDatabase.columnProductMinStock}',
    );
    yield List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  @override
  Future<int> insertProduct(Product product) async {
    final db = await _appDatabase.database;
    return await db.insert(
      AppDatabase.tableProducts,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateProduct(Product product) async {
    final db = await _appDatabase.database;
    await db.update(
      AppDatabase.tableProducts,
      product.toMap(),
      where: '${AppDatabase.columnProductId} = ?',
      whereArgs: [product.id],
    );
  }

  @override
  Future<void> deleteProduct(Product product) async {
    final db = await _appDatabase.database;
    await db.delete(
      AppDatabase.tableProducts,
      where: '${AppDatabase.columnProductId} = ?',
      whereArgs: [product.id],
    );
  }

  @override
  Future<Product?> getProductById(int id) async {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppDatabase.tableProducts,
      where: '${AppDatabase.columnProductId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<Product?> getProductBySku(String sku) async {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppDatabase.tableProducts,
      where: '${AppDatabase.columnProductSku} = ?',
      whereArgs: [sku],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      return null;
    }
  }
}


