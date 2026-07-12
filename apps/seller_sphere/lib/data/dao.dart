
// Mock/Debug version of Data Access Objects (DAO) and the AppDatabase.
// This file provides dummy classes to allow the app to compile and run
// without a real database implementation.

// A mock DAO for Product operations.
class ProductDao {
  // In a real implementation, this would interact with a database table.
}

// A mock DAO for SaleTransaction operations.
class SaleTransactionDao {
  // In a real implementation, this would interact with a database table.
}

// A mock DAO for SaleItem operations.
class SaleItemDao {
  // In a real implementation, this would interact with a database table.
}

// A mock DAO for SalesTarget operations.
class SalesTargetDao {
  // In a real implementation, this would interact with a database table.
}

/// A mock AppDatabase class that provides instances of mock DAOs.
class AppDatabase {
  final ProductDao productDao;
  final SaleTransactionDao saleTransactionDao;
  final SaleItemDao saleItemDao;
  final SalesTargetDao salesTargetDao;

  // Private constructor
  AppDatabase._({
    required this.productDao,
    required this.saleTransactionDao,
    required this.saleItemDao,
    required this.salesTargetDao,
  });

  /// A static factory method to "create" the database.
  /// In this debug version, it just instantiates the mock DAOs.
  static Future<AppDatabase> create() async {
    // Simulate some async initialization if needed.
    await Future.delayed(Duration.zero);
    return AppDatabase._(
      productDao: ProductDao(),
      saleTransactionDao: SaleTransactionDao(),
      saleItemDao: SaleItemDao(),
      salesTargetDao: SalesTargetDao(),
    );
  }
}
