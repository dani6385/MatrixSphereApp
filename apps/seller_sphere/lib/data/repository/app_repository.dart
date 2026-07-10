import 'package:seller_sphere/data/dao/product_dao.dart';
import 'package:seller_sphere/data/dao/target_dao.dart';
import 'package:seller_sphere/data/dao/transaction_dao.dart';
import 'package:seller_sphere/data/models/product.dart';
import 'package:seller_sphere/data/models/sale_item.dart';
import 'package:seller_sphere/data/models/sale_transaction.dart';
import 'package:seller_sphere/data/models/sales_target.dart';

class AppRepository {
  final ProductDao _productDao;
  final TransactionDao _transactionDao;
  final TargetDao _targetDao;

  AppRepository(this._productDao, this._transactionDao, this._targetDao);

  // Product operations
  Stream<List<Product>> get allProducts => _productDao.getAllProducts();
  Stream<List<Product>> get lowStockProducts => _productDao.getLowStockProducts();

  Future<void> insertProduct(Product product) => _productDao.insertProduct(product);
  Future<void> updateProduct(Product product) => _productDao.updateProduct(product);
  Future<void> deleteProduct(Product product) => _productDao.deleteProduct(product);
  Future<Product?> getProductById(int id) => _productDao.getProductById(id);
  Future<Product?> getProductBySku(String sku) => _productDao.getProductBySku(sku);

  // Transaction operations
  Stream<List<SaleTransaction>> get allTransactions =>
      _transactionDao.getAllTransactions();
  Stream<List<SaleItem>> get allSaleItems => _transactionDao.getAllSaleItems();

  Future<int> insertTransaction(SaleTransaction transaction, List<SaleItem> items) =>
      _transactionDao.insertTransaction(transaction, items);

  Stream<List<SaleItem>> getSaleItemsForTransaction(int transactionId) =>
      _transactionDao.getSaleItemsForTransaction(transactionId);

  Stream<List<SaleTransaction>> getTransactionsBetween(
          DateTime startTime, DateTime endTime) =>
      _transactionDao.getTransactionsBetween(startTime, endTime);

  // Target operations
  Stream<SalesTarget?> getTargetForDate(String dateString) =>
      _targetDao.getTargetForDate(dateString);

  Future<void> insertTarget(SalesTarget target) =>
      _targetDao.insertTarget(target);

  Stream<List<SalesTarget>> get allTargets => _targetDao.getAllTargets();
}
