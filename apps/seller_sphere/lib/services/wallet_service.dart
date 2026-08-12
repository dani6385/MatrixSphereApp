import 'package:firebase_database/firebase_database.dart';

class WalletService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  /// Memproses permintaan top up, memperbarui saldo pengguna, dan mencatat transaksi.
  ///
  /// [userId] adalah ID unik pengguna yang melakukan top up.
  /// [amount] adalah jumlah yang di-top up.
  Future<void> processTopUp({
    required String userId,
    required int amount,
  }) async {
    // Path ke saldo pengguna dan riwayat transaksi
    final userBalanceRef = _database.ref('users/$userId/balance');
    final transactionRef = _database.ref('transactions').push();

    try {
      // Gunakan transaksi untuk memastikan operasi atomik pada saldo
      final transactionResult = await userBalanceRef.runTransaction((Object? currentBalance) {
        final num current = currentBalance is num ? currentBalance : 0;
        return Transaction.success(current + amount);
      });

      // Jika transaksi saldo berhasil, lanjutkan untuk mencatat riwayat
      if (transactionResult.committed) {
        final newTransaction = {
          'id': transactionRef.key,
          'userId': userId,
          'type': 'TOP_UP',
          'amount': amount,
          'status': 'SUCCESS',
          'timestamp': ServerValue.timestamp,
        };
        await transactionRef.set(newTransaction);
      } else {
        // Jika transaksi gagal (misalnya, karena konflik data), lempar error
        throw Exception('Gagal memperbarui saldo. Silakan coba lagi.');
      }
    } catch (e) {
      // Tangkap error dari Firebase atau dari validasi kita sendiri
      // dan teruskan ke pemanggil (UI) untuk ditampilkan ke pengguna.
      throw Exception('Terjadi kesalahan saat memproses top up: $e');
    }
  }
}