
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();


// Model Data Keranjang
class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  CartItem(
      {required this.id,
      required this.name,
      required this.price,
      this.quantity = 1});
}

// State Notifier untuk Keranjang
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {/* ... logika tambah item ... */}
  void clearCart() => state = [];
  double calculateTotal() {
    return state.fold(0, (total, item) => total + (item.price * item.quantity));
  }
}

// Layanan Transaksi Backend
class TransactionService {
  Future<({String id})> createTransaction({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _logger.i('Mencatat transaksi ke backend...');
    return (id: 'TRX-${DateTime.now().millisecondsSinceEpoch}');
  }
}

// Deklarasi Provider Riverpod
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
    (ref) => CartNotifier());
final transactionServiceProvider = Provider((ref) => TransactionService());
