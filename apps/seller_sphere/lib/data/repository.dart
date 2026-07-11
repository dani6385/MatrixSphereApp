import 'package:seller_sphere/data/dao.dart';

class AppRepository {
  final ProductDao productDao;
  final TransactionDao transactionDao;
  final TargetDao targetDao;

  AppRepository(this.productDao, this.transactionDao, this.targetDao);

  // Product operations
  Stream<List<Product>> getAllProducts() => productDao.getAllProducts();
  Stream<List<Product>> getLowStockProducts() => productDao.getLowStockProducts();

  Future<int> insertProduct(Product product) => productDao.insertProduct(product);
  Future<void> updateProduct(Product product) => productDao.updateProduct(product);
  Future<void> deleteProduct(Product product) => productDao.deleteProduct(product);
  Future<Product?> getProductById(int id) => productDao.getProductById(id);
  Future<Product?> getProductBySku(String sku) => productDao.getProductBySku(sku);

  // Transaction operations
  Stream<List<SaleTransaction>> getAllTransactions() => transactionDao.getAllTransactions();
  Stream<List<SaleItem>> getAllSaleItems() => transactionDao.getAllSaleItems();

  Future<int> insertTransaction(SaleTransaction transaction) =>
      transactionDao.insertTransaction(transaction);

  Future<void> insertSaleItem(SaleItem item) =>
      transactionDao.insertSaleItem(item);

  Stream<List<SaleItem>> getSaleItemsForTransaction(int transactionId) =>
      transactionDao.getSaleItemsForTransaction(transactionId);

  Stream<List<SaleTransaction>> getTransactionsBetween(int startTime, int endTime) =>
      transactionDao.getTransactionsBetween(startTime, endTime);

  // Target operations
  Stream<SalesTarget?> getTargetForDate(String dateString) =>
      targetDao.getTargetForDate(dateString);

  Future<void> insertTarget(SalesTarget target) =>
      targetDao.insertTarget(target);

  Stream<List<SalesTarget>> getAllTargets() => targetDao.getAllTargets();
}
