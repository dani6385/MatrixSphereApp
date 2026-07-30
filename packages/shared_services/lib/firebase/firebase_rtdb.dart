import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_services/data/shop_realtime_screen.dart';
import 'package:shared_services/models/order_model.dart';
import 'package:shared_services/models/cart_item_model.dart';

import 'package:shared_services/src/models/product_model.dart';

/// Sebuah service class untuk berinteraksi dengan Firebase Realtime Database.
///
/// Class ini menyediakan metode-metode dasar untuk operasi CRUD (Create, Read, Update, Delete)
/// pada database Anda.
class FirebaseRtdbService {
  /// Instance dari FirebaseDatabase untuk berinteraksi dengan RTDB.
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  /// Mendapatkan referensi ke node 'seller-orders'.
  /// Path ini bisa disesuaikan jika struktur database Anda berbeda.
  DatabaseReference get ordersRef => _database.ref('seller-orders');

  /// Mendapatkan referensi ke node 'products'.
  /// Path ini bisa disesuaikan jika struktur database Anda berbeda.
  DatabaseReference get productsRef => _database.ref('products');

  /// Melakukan operasi update multi-path atomik.
  ///
  /// [updates]: Map yang berisi path relatif dan nilai yang akan diupdate.
  Future<bool> performMultiPathUpdate(Map<String, dynamic> updates) async {
    try {
      await _database.ref().update(updates);
      debugPrint('Multi-path update berhasil.');
      return true;
    } catch (e) {
      debugPrint('Error saat melakukan multi-path update: $e');
      return false;
    }
  }
  /// Membaca data dari path tertentu di Realtime Database.
  ///
  /// [path]: Path ke data yang ingin dibaca (contoh: 'seller_sphere/toko_agan').
  /// Mengembalikan `DataSnapshot` jika data ada, jika tidak mengembalikan `null`.
  Future<DataSnapshot?> readData(String path) async {
    try {
      final ref = _database.ref(path);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        debugPrint('Data berhasil dibaca dari path: $path');
        return snapshot;
      } else {
        debugPrint('Tidak ada data pada path: $path');
        return null;
      }
    } catch (e) {
      debugPrint('Terjadi error saat membaca data dari $path: $e');
      return null;
    }
  }

  /// Menulis atau menimpa data pada path tertentu.
  ///
  /// Jika data pada path tersebut sudah ada, data akan ditimpa sepenuhnya.
  /// Jika belum ada, data baru akan dibuat.
  ///
  /// [path]: Path tujuan data (contoh: 'approval/toko_baru').
  /// [data]: Map yang berisi data untuk ditulis.
  Future<bool> writeData(String path, Map<String, dynamic> data) async {
    try {
      final ref = _database.ref(path);
      await ref.set(data);
      debugPrint('Data berhasil ditulis ke path: $path');
      return true;
    } catch (e) {
      debugPrint('Terjadi error saat menulis data ke $path: $e');
      return false;
    }
  }

  /// Menulis atau menimpa data toko menggunakan objek [Shop].
  ///
  /// Method ini secara otomatis mengonversi objek Shop menjadi JSON
  /// dan menuliskannya ke path yang sesuai.
  ///
  /// [shop]: Objek Shop yang akan ditulis ke database.
  /// [uid]: UID dari pemilik toko.
  Future<bool> writeShop(Shop shop, String uid) async {
    try {
      // Menggunakan UID pemilik untuk path dan shop.toJson() untuk data.
      // ID toko (shop.id) sekarang menjadi properti di dalam data.
      return await writeData('seller_sphere/$uid', shop.toJson());
    } catch (e) {
      debugPrint('Terjadi error saat menulis objek Shop: $e');
      return false;
    }
  }

  /// Memperbarui data pada path tertentu tanpa menimpa seluruh node.
  ///
  /// Hanya field yang ada di dalam [data] yang akan diperbarui atau ditambahkan.
  ///
  /// [path]: Path ke node yang ingin diperbarui (contoh: 'seller_sphere/toko_agan/produk').
  /// [data]: Map yang berisi field dan nilai baru.
  Future<bool> updateData(String path, Map<String, dynamic> data) async {
    try {
      final ref = _database.ref(path);
      await ref.update(data);
      debugPrint('Data berhasil diperbarui pada path: $path');
      return true;
    } catch (e) {
      debugPrint('Terjadi error saat memperbarui data di $path: $e');
      return false;
    }
  }

  /// Menghapus data pada path tertentu.
  ///
  /// [path]: Path ke data yang ingin dihapus (contoh: 'system/pelanggaran/toko_abang').
  Future<bool> deleteData(String path) async {
    try {
      final ref = _database.ref(path);
      await ref.remove();
      debugPrint('Data berhasil dihapus dari path: $path');
      return true;
    } catch (e) {
      debugPrint('Terjadi error saat menghapus data dari $path: $e');
      return false;
    }
  }

  /// Memeriksa apakah toko untuk UID tertentu sudah ada di 'seller_sphere' atau masih dalam 'approval'.
  ///
  /// [uid]: UID pengguna yang ingin diperiksa.
  /// Mengembalikan `true` jika data ditemukan di salah satu path, jika tidak `false`.
  Future<bool> doesShopExistForUser(String uid) async {
    try {
      // 1. Cek di path utama 'seller_sphere'
      final sellerRef = _database.ref('seller_sphere/$uid');
      final sellerSnapshot = await sellerRef.get();
      if (sellerSnapshot.exists) {
        return true;
      }

      // 2. Jika tidak ada, cek di path 'approval'
      final approvalRef = _database.ref('approval/$uid');
      final approvalSnapshot = await approvalRef.get();
      return approvalSnapshot.exists;
    } catch (e) {
      debugPrint('Error saat memeriksa keberadaan toko untuk UID $uid: $e');
      return false; // Anggap tidak ada jika terjadi error
    }
  }

  /// Mendengarkan perubahan data pada path toko secara real-time.
  ///
  /// Method ini mengembalikan sebuah Stream yang akan memancarkan objek [Shop]
  /// setiap kali data di path tersebut berubah.
  ///
  /// [shopId]: ID dari toko yang ingin didengarkan (contoh: 'toko_agan').
  /// [uid]: UID dari pemilik toko yang datanya ingin didengarkan.
  /// Mengembalikan `Stream<Shop?>`. Stream akan memancarkan `null` jika
  /// data tidak ada atau dihapus.
  Stream<Shop?> getShopStreamByUid(String uid) {
    final path = 'seller_sphere/$uid';
    try {
      final ref = _database.ref(path);
      // .onValue adalah Stream yang akan aktif setiap kali data berubah
      return ref.onValue.map((event) {
        final snapshot = event.snapshot;
        if (snapshot.exists && snapshot.value != null) {
          // Pastikan konversi ke Map<String, dynamic> untuk kompatibilitas JSON
          final shopData = Map<String, dynamic>.from(
              (snapshot.value as Map).map((key, value) => MapEntry(key.toString(), value)));
          // snapshot.key akan berisi ID toko, misal 'toko_agan'
          return Shop.fromJson(snapshot.key!, shopData);
        } else {
          return null; // Data tidak ada atau telah dihapus
        }
      });
    } catch (e) {
      debugPrint('Terjadi error saat membuat stream untuk $path: $e');
      return Stream.value(
          null); // Kembalikan stream dengan nilai null jika error
    }
  }

  /// Mencari semua toko yang menjual produk tertentu.
  ///
  /// Ini adalah contoh **client-side filtering**: mengambil semua data toko
  /// lalu menyaringnya di aplikasi.
  ///
  /// [productName]: Nama produk yang dicari (contoh: 'sepatu').
  /// Mengembalikan `List<Shop>` yang berisi toko-toko yang cocok.
  Future<List<Shop>> findShopsByProduct(String productName) async {
    final List<Shop> matchingShops = [];
    const path = 'seller_sphere';

    try {
      // 1. Ambil seluruh data di bawah 'seller_sphere'
      final snapshot = await readData(path);

      if (snapshot != null && snapshot.exists && snapshot.value is Map) {
        final allShopsData = Map<String, dynamic>.from(snapshot.value as Map);

        // 2. Lakukan iterasi dan filter di sisi klien (aplikasi)
        allShopsData.forEach((shopId, shopData) {
          final shop = Shop.fromJson(shopId, shopData as Map<String, dynamic>);
          // 3. Cek apakah toko memiliki produk yang dicari
          if (shop?.products.containsKey(productName) ?? false) {
            matchingShops.add(shop!);
          }
        });
      }
    } catch (e) {
      debugPrint('Error saat mencari toko berdasarkan produk: $e');
    }
    return matchingShops;
  }

  /// Mengambil satu "halaman" data produk dari sebuah toko dengan paginasi.
  ///
  /// [shopUid]: UID dari toko yang produknya ingin diambil.
  /// [pageSize]: Jumlah produk yang ingin diambil per halaman.
  /// [startAfterKey]: Key (nama produk) terakhir dari halaman sebelumnya untuk
  ///                  menentukan titik awal query berikutnya. Null untuk halaman pertama.
  /// Mengembalikan `List<Product>`.
  Future<List<Product>> fetchProductsPage({
    required String shopUid,
    required int pageSize,
    String? startAfterKey,
  }) async {
    final List<Product> products = [];
    final path = 'seller_sphere/$shopUid/produk';

    // Membuat query dasar: urutkan berdasarkan key (nama produk)
    Query query = _database.ref(path).orderByKey();

    // Jika ini bukan halaman pertama, mulai query SETELAH key terakhir
    if (startAfterKey != null) {
      query = query.startAfter(startAfterKey);
    }

    // Batasi jumlah data yang diambil sesuai ukuran halaman
    query = query.limitToFirst(pageSize);

    try {
      final snapshot = await query.get();
      if (snapshot.exists && snapshot.value is Map) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach((productName, productData) {
          if (productData is Map) {
            // Use Product.fromMap to correctly parse all fields, including the new soldCount
            products.add(Product.fromMap(Map<String, dynamic>.from(productData), productName));
          }
        });
      }
    } catch (e) {
      debugPrint('Error saat fetch product page: $e');
    }

    // List produk akan diurutkan secara otomatis karena kita menggunakan orderByKey()
    return products;
  }

  /// Membuat pesanan baru dan mengurangi stok produk secara atomik menggunakan transaksi.
  ///
  /// [shopUid]: UID dari toko tempat pesanan dibuat.
  /// [buyerUid]: UID dari pembeli.
  /// [orderItems]: Map dari item yang dipesan dan jumlahnya. Contoh: {'baju': 1, 'sepatu': 2}
  ///
  /// Mengembalikan `true` jika transaksi berhasil, `false` jika gagal (misal, stok tidak cukup).
  Future<bool> createOrderWithStockUpdate({
    required String shopUid,
    required String buyerUid,
    required Map<String, int> orderItems,
  }) async {
    final shopRef = _database.ref('seller_sphere/$shopUid');

    try {
      final transactionResult =
          await shopRef.runTransaction((Object? currentData) {
        // Jika node toko tidak ada, batalkan transaksi.
        if (currentData == null) {
          return Transaction.abort();
        }

        final shopData = Map<String, dynamic>.from(currentData as Map);
        final products = shopData['produk'] as Map<String, dynamic>? ?? {};
        int totalOrderPrice = 0;

        // 1. Validasi stok untuk semua item dalam pesanan
        for (var item in orderItems.entries) {
          final productName = item.key;
          final quantity = item.value;
          final productData = products[productName] as Map<String, dynamic>?;

          if (productData == null || (productData['stock'] as int) < quantity) {
            // Jika produk tidak ada atau stok tidak cukup, batalkan seluruh transaksi.
            debugPrint('Transaksi dibatalkan: Stok $productName tidak cukup.');
            return Transaction.abort();
          }
        }

        // 2. Jika semua stok valid, kurangi stok dan hitung total harga
        orderItems.forEach((productName, quantity) {
          final productData = products[productName] as Map<String, dynamic>;
          productData['stock'] = (productData['stock'] as int) - quantity;
          totalOrderPrice += (productData['price'] as num).toInt() * quantity;
        });

        // 3. Tambahkan pesanan baru
        final pesanan = shopData['pesanan'] as Map<String, dynamic>? ?? {};
        pesanan[buyerUid] = {...orderItems, 'total': totalOrderPrice};
        shopData['pesanan'] = pesanan;

        // Kembalikan data yang sudah dimodifikasi untuk ditulis ke database.
        return Transaction.success(shopData);
      });

      return transactionResult.committed;
    } catch (e) {
      debugPrint('Error saat menjalankan transaksi pesanan: $e');
      return false;
    }
  }

  /// Membuat pesanan Point-of-Sale (POS) dan mengurangi stok produk secara atomik.
  ///
  /// [order]: Objek Order yang akan dibuat.
  /// [cartItems]: Daftar item di keranjang untuk pembaruan stok.
  ///
  /// Mengembalikan `true` jika berhasil, `false` jika gagal.
  Future<bool> createPosOrderAndUpdateStock({
    required Order order,
    required List<CartItem> cartItems,
  }) async {
    try {
      // Dapatkan referensi baru untuk order dengan ID unik
      final newOrderRef = ordersRef.push();
      final orderId = newOrderRef.key!;

      // Siapkan data update untuk stok
      final Map<String, dynamic> productUpdates = {};
      for (var item in cartItems) {
        // Path ke field stok produk dan nilai stok baru
        productUpdates['/products/${item.product.id}/stock'] =
            ServerValue.increment(-item.quantity);
        // Path ke field soldCount produk dan nilai soldCount baru
        productUpdates['/products/${item.product.id}/soldCount'] =
            ServerValue.increment(-item.quantity);
      }

      // Siapkan data untuk order baru
      final Map<String, dynamic> orderUpdate = {
        '/seller-orders/$orderId': order.toMap(),
      };

      // Gabungkan semua update menjadi satu operasi atomik
      final Map<String, dynamic> updates = {} // Renamed from stockUpdates to productUpdates
        ..addAll(productUpdates)
        ..addAll(orderUpdate);

      // Jalankan multi-path update
      await _database.ref().update(updates);

      debugPrint('Transaksi POS berhasil untuk order ID: $orderId');
      return true;
    } catch (e) {
      debugPrint('Error saat menjalankan transaksi POS: $e');
      // Di dunia nyata, Anda mungkin ingin mencoba membatalkan
      // sebagian transaksi jika memungkinkan, tapi multi-path update
      // seharusnya berhasil atau gagal sepenuhnya.
      return false;
    }
  }
}


//--- CONTOH PENGGUNAAN ---
//Untuk menggunakan service ini, Anda perlu membuat instance-nya terlebih dahulu.

final rtdbService = FirebaseRtdbService();
// 1. Membaca data produk dari 'toko_agan'
void contohBacaData() async {
  final snapshot = await rtdbService.readData('seller_sphere/toko_agan/produk');
  if (snapshot != null && snapshot.value != null) {
    // snapshot.value akan berupa Map<Object?, Object?>
    final data = snapshot.value as Map; 
    print('Produk Toko Agan: $data'); // Output: {baju: 25000, sepatu: 25000}
    print('Harga baju: ${data['baju']}'); // Output: Harga baju: 25000
  }
}

// 2. Menambahkan toko baru ke dalam 'approval'
void contohTulisData() async {
  await rtdbService.writeData('approval/toko_baru', {
    'nama': 'Toko Baru',
    'status': 'waiting',
  });
}

// 3. Memperbarui harga baju di 'toko_agan'
void contohUpdateData() async {
  await rtdbService.updateData('seller_sphere/toko_agan/produk', {
    'baju': 26500, // Harga baru
  });
}

// 4. Menghapus data komplain 'toko_agan'
void contohHapusData() async {
  await rtdbService.deleteData('system/pelanggaran/toko_agan');
}
