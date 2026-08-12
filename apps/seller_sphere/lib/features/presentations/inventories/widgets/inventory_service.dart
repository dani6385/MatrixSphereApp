import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'inventory_logger_mixin.dart';

class InventoryService with InventoryLoggerMixin {
  @override
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  
  @override
  final Logger logger = Logger();

  Future<void> decreaseStock(String productId, int quantityToSubtract) async {
    final productRef = dbRef.child('products').child(productId).child('stock');
    int? originalStock;

    final transactionResult = await productRef.runTransaction((Object? currentStockValue) {
      final int currentStock = currentStockValue is int ? currentStockValue : 0;
      originalStock = currentStock;

      if (currentStock < quantityToSubtract) {
        return Transaction.abort();
      }

      return Transaction.success(currentStock - quantityToSubtract);
    });

    if (transactionResult.committed && originalStock != null) {
      final newStock = transactionResult.snapshot.value as int;
      await writeStockLog(
        productId: productId,
        previousStock: originalStock!,
        newStock: newStock,
        reason: 'pengurangan_manual',
      );
    } else {
      throw Exception('Stok tidak mencukupi atau transaksi dibatalkan.');
    }
  }

  Future<void> increaseStock(String productId, int quantityToAdd) async {
    final productRef = dbRef.child('products').child(productId).child('stock');
    int? originalStock;

    final transactionResult = await productRef.runTransaction((Object? currentStockValue) {
      final int currentStock = currentStockValue is int ? currentStockValue : 0;
      originalStock = currentStock;

      return Transaction.success(currentStock + quantityToAdd);
    });

    if (transactionResult.committed && originalStock != null) {
      final newStock = transactionResult.snapshot.value as int;
      await writeStockLog(
        productId: productId,
        previousStock: originalStock!,
        newStock: newStock,
        reason: 'penambahan_manual',
      );
    } else {
      throw Exception('Transaksi penambahan stok dibatalkan.');
    }
  }

  Future<int> getStock(String productId) async {
    final productRef = dbRef.child('products').child(productId).child('stock');
    final snapshot = await productRef.get();

    if (snapshot.exists && snapshot.value is int) {
      return snapshot.value as int;
    }
    return 0;
  }

  Future<void> updateStock(String productId, int newStock) async {
    final int previousStock = await getStock(productId);
    final productRef = dbRef.child('products').child(productId).child('stock');
    
    await productRef.set(newStock);
    await writeStockLog(
      productId: productId,
      previousStock: previousStock,
      newStock: newStock,
      reason: 'stok_opname',
    );
  }

  Future<bool> hasSufficientStock(String productId, int quantityNeeded) async {
    final currentStock = await getStock(productId);
    return currentStock >= quantityNeeded;
  }
}