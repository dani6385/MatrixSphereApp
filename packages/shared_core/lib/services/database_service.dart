import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _rtdb = FirebaseDatabase.instance;

  /// Fungsi utama untuk memproses voucher
  /// Mengembalikan pesan sukses atau error agar bisa ditampilkan ke UI
  Future<String> prosesVoucher(String inputKode, String macAddress) async {
    try {
      // 1. Cek di Firestore: Apakah kode voucher ada dan statusnya 'available'?
      DocumentReference voucherRef = _firestore.collection('vouchers').doc(inputKode);
      DocumentSnapshot voucherDoc = await voucherRef.get();

      if (!voucherDoc.exists) {
        return "Kode voucher tidak ditemukan!";
      }

      Map<String, dynamic> data = voucherDoc.data() as Map<String, dynamic>;

      if (data['status'] != 'available') {
        return "Voucher sudah digunakan atau tidak valid!";
      }

      // 2. Jika valid, masukkan ke Realtime Database untuk dijemput oleh Mikrotik
      DatabaseReference queueRef = _rtdb.ref('queue').push();
      await queueRef.set({
        "voucher": inputKode,
        "mac_address": macAddress,
        "timestamp": ServerValue.timestamp
      });

      // 3. Update status di Firestore menjadi 'used' agar tidak bisa dipakai lagi
      await voucherRef.update({"status": "used"});

      return "Voucher berhasil diaktifkan!";
    } catch (e) {
      return "Terjadi kesalahan: ${e.toString()}";
    }
  }
}