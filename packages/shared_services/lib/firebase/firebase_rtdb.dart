import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_services/data/shop_realtime_screen.dart';
import 'package:shared_services/firebase/firebase_crashlytics_service.dart';
import 'package:shared_services/models/order_model.dart';
import 'package:shared_services/models/cart_item_model.dart';

import 'package:shared_services/models/product_model.dart';

/// A service class for interacting with the Firebase Realtime Database.
class FirebaseRtdbService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference get ordersRef => _database.ref('orders');
  DatabaseReference get productsRef => _database.ref('products');

  Future<bool> performMultiPathUpdate(Map<String, dynamic> updates) async {
    try {
      await _database.ref().update(updates);
      debugPrint('Multi-path update berhasil.');
      return true;
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal multi-path update');
      return false;
    }
  }

  Future<DataSnapshot?> readData(String path) async {
    try {
      final ref = _database.ref(path);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        return snapshot;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal membaca data dari $path');
      return null;
    }
  }

  Future<bool> writeData(String path, Map<String, dynamic> data) async {
    try {
      final ref = _database.ref(path);
      await ref.set(data);
      return true;
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal menulis data ke $path');
      return false;
    }
  }

  Future<bool> writeShop(Shop shop, String uid) async {
    try {
      return await writeData('seller_sphere/$uid', shop.toJson());
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal menulis objek Shop');
      return false;
    }
  }

  Future<bool> updateData(String path, Map<String, dynamic> data) async {
    try {
      final ref = _database.ref(path);
      await ref.update(data);
      return true;
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal memperbarui data di $path');
      return false;
    }
  }

  Future<bool> deleteData(String path) async {
    try {
      final ref = _database.ref(path);
      await ref.remove();
      return true;
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal menghapus data dari $path');
      return false;
    }
  }

  Future<bool> doesShopExistForUser(String uid) async {
    try {
      final sellerRef = _database.ref('seller_sphere/$uid');
      final sellerSnapshot = await sellerRef.get();
      if (sellerSnapshot.exists) {
        return true;
      }

      final approvalRef = _database.ref('approval/$uid');
      final approvalSnapshot = await approvalRef.get();
      return approvalSnapshot.exists;
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal memeriksa keberadaan toko untuk UID $uid');
      return false;
    }
  }

  Stream<Shop?> getShopStreamByUid(String uid) {
    final path = 'seller_sphere/$uid';
    try {
      final ref = _database.ref(path);
      return ref.onValue.map((event) {
        final snapshot = event.snapshot;
        if (snapshot.exists && snapshot.value != null) {
          final shopData = Map<String, dynamic>.from((snapshot.value as Map)
              .map((key, value) => MapEntry(key.toString(), value)));
          return Shop.fromJson(snapshot.key!, shopData);
        } else {
          return null;
        }
      });
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal membuat stream untuk $path');
      return Stream.value(null);
    }
  }

  Future<List<Shop>> findShopsByProduct(String productName) async {
    final List<Shop> matchingShops = [];
    const path = 'seller_sphere';

    try {
      final snapshot = await readData(path);

      if (snapshot != null && snapshot.exists && snapshot.value is Map) {
        final allShopsData = Map<String, dynamic>.from(snapshot.value as Map);

        allShopsData.forEach((shopId, shopData) {
          final shop = Shop.fromJson(shopId, shopData as Map<String, dynamic>);
          if (shop?.products.containsKey(productName) ?? false) {
            matchingShops.add(shop!);
          }
        });
      }
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal mencari toko berdasarkan produk');
    }
    return matchingShops;
  }

  Future<List<Product>> fetchProductsPage({
    required String shopId,
    required int pageSize,
    String? startAfterKey,
  }) async {
    final List<Product> products = [];
    Query query =
        _database.ref('products').orderByChild('shopId').equalTo(shopId);

    if (startAfterKey != null) {
      query = query.startAfter(startAfterKey);
    }

    query = query.limitToFirst(pageSize);

    try {
      final snapshot = await query.get();
      if (snapshot.exists && snapshot.value is Map) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach((productId, productData) {
          if (productData is Map) {
            products.add(Product.fromMap(
                Map<String, dynamic>.from(productData), productId));
          }
        });
      }
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal fetch product page');
    }

    return products;
  }

  Future<bool> createOrderWithStockUpdate({
    required String shopUid,
    required String buyerUid,
    required Map<String, int>
        orderItems, 
  }) async {
    final rootRef = _database.ref();

    try {
      final transactionResult =
          await rootRef.runTransaction((Object? currentData) {
        final data = currentData as Map<String, dynamic>?;
        if (data == null) {
          return Transaction.abort();
        }

        final allProducts = data['products'] as Map<String, dynamic>? ?? {};
        int totalOrderPrice = 0;
        final Map<String, dynamic> productUpdates = {};

        for (var item in orderItems.entries) {
          final productId = item.key;
          final quantity = item.value;
          final productData = allProducts[productId] as Map<String, dynamic>?;

          if (productData == null ||
              (productData['stock'] as int? ?? 0) < quantity ||
              productData['shopId'] != shopUid) {
            return Transaction.abort();
          }

          final newStock = (productData['stock'] as int) - quantity;
          productUpdates['/products/$productId/stock'] = newStock;
          totalOrderPrice +=
              (productData['sellingPrice'] as num? ?? 0).toInt() * quantity;
        }

        final newOrderRef = _database.ref('orders').push();
        final orderData = {
          'shopId': shopUid,
          'buyerId': buyerUid,
          'items': orderItems,
          'totalAmount': totalOrderPrice,
          'createdAt': ServerValue.timestamp,
          'status': 'completed',
        };

        final Map<String, dynamic> finalUpdates = {
          ...productUpdates,
          '/orders/${newOrderRef.key}': orderData
        };
        return Transaction.success(finalUpdates);
      });

      return transactionResult.committed;
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal menjalankan transaksi pesanan');
      return false;
    }
  }

  Future<bool> createPosOrderAndUpdateStock({
    required Order order,
    required List<CartItem> cartItems,
  }) async {
    try {
      final newOrderRef = ordersRef.push();
      final orderId = newOrderRef.key!;

      final Map<String, dynamic> productUpdates = {};
      for (var item in cartItems) {
        productUpdates['/products/${item.product.id}/stock'] =
            ServerValue.increment(-item.quantity);
        productUpdates['/products/${item.product.id}/soldCount'] =
            ServerValue.increment(-item.quantity);
      }

      final Map<String, dynamic> orderUpdate = {
        '/orders/$orderId': order.toMap(),
      };

      final Map<String, dynamic> updates =
          {} 
            ..addAll(productUpdates)
            ..addAll(orderUpdate);

      await _database.ref().update(updates);

      return true;
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal menjalankan transaksi POS');
      return false;
    }
  }

  Stream<List<Order>> getOrdersStreamForShop(String shopId) {
    try {
      final query = ordersRef.orderByChild('shopId').equalTo(shopId);

      return query.onValue.map((event) {
        final List<Order> orders = [];
        final snapshot = event.snapshot;

        if (snapshot.exists && snapshot.value != null) {
          final data = Map<String, dynamic>.from(snapshot.value as Map);
          data.forEach((orderId, orderData) {
            orders.add(Order.fromMap(orderData as Map<String, dynamic>, orderId));
          });
        }
        return orders;
      });
    } catch (e, stackTrace) {
      crashlyticsService.recordError(e, stackTrace, reason: 'Gagal membuat stream pesanan untuk toko $shopId');
      return Stream.value([]);
    }
  }
}

final rtdbService = FirebaseRtdbService();
