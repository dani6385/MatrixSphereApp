
import '../local/app_database.dart';

// Kelas AppRepository menyediakan API yang bersih untuk akses data ke seluruh aplikasi.
// Ini mengabstraksikan sumber data dari bagian lain dari aplikasi Anda.
class AppRepository {
  final ProductDao _productDao;
  final TransactionDao _transactionDao;
  final TargetDao _targetDao;

  // Konstruktor untuk menginisialisasi DAO yang diperlukan.
  AppRepository({
    required ProductDao productDao,
    required TransactionDao transactionDao,
    required TargetDao targetDao,
  })  : _productDao = productDao,
        _transactionDao = transactionDao,
        _targetDao = targetDao;

  // --- Operasi Produk ---
  Stream<List<Product>> get allProducts => _productDao.getAllProducts();
  Stream<List<Product>> get lowStockProducts => _productDao.getLowStockProducts();

  Future<int> insertProduct(Product product) => _productDao.insertProduct(product);
  Future<void> updateProduct(Product product) => _productDao.updateProduct(product);
  Future<void> deleteProduct(Product product) => _productDao.deleteProduct(product);
  Future<Product?> getProductById(int id) => _productDao.getProductById(id);
  Future<Product?> getProductBySku(String sku) => _productDao.getProductBySku(sku);

  // --- Operasi Transaksi ---
  Stream<List<SaleTransaction>> get allTransactions => _transactionDao.getAllTransactions();
  Stream<List<SaleItem>> get allSaleItems => _transactionDao.getAllSaleItems();

  Future<int> insertTransaction(SaleTransaction transaction) => _transactionDao.insertTransaction(transaction);
  Future<void> insertSaleItem(SaleItem item) => _transactionDao.insertSaleItem(item);

  Stream<List<SaleItem>> getSaleItemsForTransaction(int transactionId) =>
      _transactionDao.getSaleItemsForTransaction(transactionId);

  Stream<List<SaleTransaction>> getTransactionsBetween(int startTime, int endTime) =>
      _transactionDao.getTransactionsBetween(startTime, endTime);

  // --- Operasi Target ---
  Stream<SalesTarget?> getTargetForDate(String dateString) =>
      _targetDao.getTargetForDate(dateString);

  Future<void> insertTarget(SalesTarget target) => _targetDao.insertTarget(target);

  Stream<List<SalesTarget>> get allTargets => _targetDao.getAllTargets();
}
