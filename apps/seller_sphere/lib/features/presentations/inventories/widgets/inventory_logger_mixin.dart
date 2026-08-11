<<<<<<< HEAD
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

mixin InventoryLoggerMixin {
  DatabaseReference get dbRef;
  Logger get logger;

  /// Menulis log perubahan stok ke Realtime Database.
  Future<void> writeStockLog({
    required String productId,
    required int previousStock,
    required int newStock,
    required String reason,
  }) async {
    try {
      final logRef = dbRef.child('stock_logs').child(productId).push();
      await logRef.set({
        'previousStock': previousStock,
        'newStock': newStock,
        'change': newStock - previousStock,
        'reason': reason,
        'timestamp': ServerValue.timestamp,
      });
    } catch (e) {
      logger.e('Gagal menulis log stok untuk produk $productId: $e');
    }
  }
=======
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

mixin InventoryLoggerMixin {
  DatabaseReference get dbRef;
  Logger get logger;

  /// Menulis log perubahan stok ke Realtime Database.
  Future<void> writeStockLog({
    required String productId,
    required int previousStock,
    required int newStock,
    required String reason,
  }) async {
    try {
      final logRef = dbRef.child('stock_logs').child(productId).push();
      await logRef.set({
        'previousStock': previousStock,
        'newStock': newStock,
        'change': newStock - previousStock,
        'reason': reason,
        'timestamp': ServerValue.timestamp,
      });
    } catch (e) {
      logger.e('Gagal menulis log stok untuk produk $productId: $e');
    }
  }
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
}