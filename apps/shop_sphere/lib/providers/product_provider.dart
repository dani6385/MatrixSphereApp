import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Provider untuk instance FirebaseFirestore.
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

/// StreamProvider yang menyediakan daftar produk secara real-time dari Firestore.
///
/// Setiap kali ada perubahan di koleksi 'products', provider ini akan secara otomatis
/// memperbarui UI yang mendengarkannya.
// Menyediakan stream daftar produk sebagai Map<String, dynamic> per dokumen.
// Menghindari pemanggilan konstruktor/utility yang mungkin tidak tersedia di model Product.
final productsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final stream = firestore.collection('products').orderBy('createdAt', descending: true).snapshots();
  return stream.map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});