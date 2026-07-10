
import '../database/app_database.dart';
import '../models/models.dart';

abstract class TransactionDao {
  Future<int> insertTransaction(SaleTransaction transaction, List<SaleItem> items);

  Stream<List<SaleTransaction>> getAllTransactions();

  Stream<List<SaleItem>> getSaleItemsForTransaction(int transactionId);

  Stream<List<SaleItem>> getAllSaleItems();

  Stream<List<SaleTransaction>> getTransactionsBetween(DateTime startTime, DateTime endTime);
}

class TransactionDaoImpl implements TransactionDao {
  final AppDatabase _appDatabase;

  TransactionDaoImpl(this._appDatabase);

  @override
  Future<int> insertTransaction(SaleTransaction transaction, List<SaleItem> items) async {
    final db = await _appDatabase.database;
    return await db.transaction((txn) async {

      double totalAmount = items.fold(0.0, (sum, item) => sum + item.totalAmount);
      double totalProfit = items.fold(0.0, (sum, item) => sum + item.totalProfit);

      final transactionId = await txn.insert(
        AppDatabase.tableSaleTransactions,
        {
          AppDatabase.columnTransactionTimestamp: transaction.timestamp,
          AppDatabase.columnTransactionTotalAmount: totalAmount,
          AppDatabase.columnTransactionTotalProfit: totalProfit,
          AppDatabase.columnTransactionPaymentMethod: transaction.paymentMethod,
        },
      );

      for (final item in items) {
        await txn.insert(AppDatabase.tableSaleItems, {
          AppDatabase.columnSaleItemTransactionId: transactionId,
          AppDatabase.columnSaleItemProductId: item.productId,
          AppDatabase.columnSaleItemProductName: item.productName,
          AppDatabase.columnSaleItemQuantity: item.quantity,
          AppDatabase.columnSaleItemPurchasePrice: item.purchasePrice,
          AppDatabase.columnSaleItemSellingPrice: item.sellingPrice,
        });
      }
      return transactionId;
    });
  }

  @override
  Stream<List<SaleTransaction>> getAllTransactions() async* {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(AppDatabase.tableSaleTransactions, orderBy: '${AppDatabase.columnTransactionTimestamp} DESC');
    yield List.generate(maps.length, (i) {
      return SaleTransaction(
        id: maps[i][AppDatabase.columnTransactionId],
        timestamp: maps[i][AppDatabase.columnTransactionTimestamp],
        totalAmount: maps[i][AppDatabase.columnTransactionTotalAmount],
        totalProfit: maps[i][AppDatabase.columnTransactionTotalProfit],
        paymentMethod: maps[i][AppDatabase.columnTransactionPaymentMethod],
      );
    });
  }

  @override
  Stream<List<SaleItem>> getSaleItemsForTransaction(int transactionId) async* {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(AppDatabase.tableSaleItems, where: '${AppDatabase.columnSaleItemTransactionId} = ?', whereArgs: [transactionId]);
    yield List.generate(maps.length, (i) {
      return SaleItem(
        id: maps[i][AppDatabase.columnSaleItemId],
        transactionId: maps[i][AppDatabase.columnSaleItemTransactionId],
        productId: maps[i][AppDatabase.columnSaleItemProductId],
        productName: maps[i][AppDatabase.columnSaleItemProductName],
        quantity: maps[i][AppDatabase.columnSaleItemQuantity],
        purchasePrice: maps[i][AppDatabase.columnSaleItemPurchasePrice],
        sellingPrice: maps[i][AppDatabase.columnSaleItemSellingPrice],
      );
    });
  }

  @override
  Stream<List<SaleItem>> getAllSaleItems() async* {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(AppDatabase.tableSaleItems);
    yield List.generate(maps.length, (i) {
      return SaleItem(
        id: maps[i][AppDatabase.columnSaleItemId],
        transactionId: maps[i][AppDatabase.columnSaleItemTransactionId],
        productId: maps[i][AppDatabase.columnSaleItemProductId],
        productName: maps[i][AppDatabase.columnSaleItemProductName],
        quantity: maps[i][AppDatabase.columnSaleItemQuantity],
        purchasePrice: maps[i][AppDatabase.columnSaleItemPurchasePrice],
        sellingPrice: maps[i][AppDatabase.columnSaleItemSellingPrice],
      );
    });
  }

  @override
  Stream<List<SaleTransaction>> getTransactionsBetween(DateTime startTime, DateTime endTime) async* {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppDatabase.tableSaleTransactions,
      where: '${AppDatabase.columnTransactionTimestamp} >= ? AND ${AppDatabase.columnTransactionTimestamp} <= ?',
      whereArgs: [startTime.millisecondsSinceEpoch, endTime.millisecondsSinceEpoch],
      orderBy: '${AppDatabase.columnTransactionTimestamp} DESC',
    );
    yield List.generate(maps.length, (i) {
      return SaleTransaction(
        id: maps[i][AppDatabase.columnTransactionId],
        timestamp: maps[i][AppDatabase.columnTransactionTimestamp],
        totalAmount: maps[i][AppDatabase.columnTransactionTotalAmount],
        totalProfit: maps[i][AppDatabase.columnTransactionTotalProfit],
        paymentMethod: maps[i][AppDatabase.columnTransactionPaymentMethod],
      );
    });
  }
}
