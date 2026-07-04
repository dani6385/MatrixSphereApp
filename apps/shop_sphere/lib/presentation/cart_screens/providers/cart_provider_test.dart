import 'package:flutter_test/flutter_test.dart';
import 'package:shop_sphere/presentation/cart_screens/providers/cart_provider.dart';

void main() {
  // Grup untuk semua tes yang berhubungan dengan CartProvider
  group('CartProvider', () {
    late CartProvider cartProvider;

    // Fungsi setUp dijalankan sebelum setiap tes dalam grup ini.
    // Ini memastikan setiap tes dimulai dengan instance CartProvider yang baru dan bersih.
    setUp(() {
      cartProvider = CartProvider();
      // Mengosongkan keranjang dari data dummy awal untuk memastikan lingkungan tes yang bersih.
      cartProvider.clearCart();
    });

    test('initial state should be empty after clearing', () {
      expect(cartProvider.totalItems, 0);
      expect(cartProvider.totalPrice, 0.0);
    });

    group('addItem', () {
      test('should add a new item to the cart', () {
        // Aksi: Menambahkan item baru
        cartProvider.addItem(
          productId: 'prod1',
          name: 'Test Product 1',
          price: 100.0,
          imageUrl: 'test_url',
        );

        // Verifikasi: Jumlah item bertambah dan item tersebut ada di keranjang
        expect(cartProvider.totalItems, 1);
        expect(cartProvider.items.first.productId, 'prod1');
        expect(cartProvider.items.first.quantity, 1);
      });

      test('should increase quantity if the same item is added again', () {
        // Persiapan: Menambahkan item awal
        cartProvider.addItem(
          productId: 'prod1',
          name: 'Test Product 1',
          price: 100.0,
          imageUrl: 'test_url',
        );

        // Aksi: Menambahkan item yang sama lagi
        cartProvider.addItem(
          productId: 'prod1',
          name: 'Test Product 1',
          price: 100.0,
          imageUrl: 'test_url',
        );

        // Verifikasi: Jumlah item tidak berubah, tetapi kuantitas item tersebut bertambah
        expect(cartProvider.totalItems, 1);
        expect(cartProvider.items.first.quantity, 2);
      });
    });

    group('totalPrice', () {
      test('should calculate the total price correctly for multiple items', () {
        // Aksi: Menambahkan beberapa item dengan kuantitas berbeda
        cartProvider.addItem(
          productId: 'prod1', name: 'Product A', price: 100.0, imageUrl: 'url1'); // 1 x 100 = 100
        cartProvider.addItem( // Item 2, kuantitas 1
          productId: 'prod2', name: 'Product B', price: 50.0, imageUrl: 'url2');
        cartProvider.increaseQuantity('prod2'); // Kuantitas jadi 2
        cartProvider.increaseQuantity('prod2'); // Kuantitas jadi 3

        // Verifikasi: Total harga harus sesuai dengan (1 * 100) + (3 * 50) = 250.0
        expect(cartProvider.totalPrice, 250.0);
      });

      test('should update total price when an item quantity is increased', () {
        // Persiapan: Menambahkan item
        cartProvider.addItem(
          productId: 'prod1', name: 'Product A', price: 100.0, imageUrl: 'url1');
        // Aksi: Menambahkan item yang sama lagi untuk meningkatkan kuantitas
        cartProvider.addItem(
          productId: 'prod1', name: 'Product A', price: 100.0, imageUrl: 'url1');
        // Verifikasi: Total harga harus menjadi 2 * 100 = 200
        expect(cartProvider.totalPrice, 200.0);
      });
    });

    group('increaseQuantity', () {
      test('should increase the quantity of an existing item', () {
        // Persiapan: Menambahkan item
        cartProvider.addItem(productId: 'prod1', name: 'Product A', price: 100.0, imageUrl: 'url1');
        expect(cartProvider.items.first.quantity, 1);
        expect(cartProvider.totalPrice, 100.0);

        // Aksi: Menaikkan kuantitas
        cartProvider.increaseQuantity('prod1');

        // Verifikasi: Kuantitas bertambah dan total harga diperbarui
        expect(cartProvider.items.first.quantity, 2);
        expect(cartProvider.totalPrice, 200.0);
      });

      test('should do nothing if product ID does not exist', () {
        // Persiapan: Keranjang kosong
        expect(cartProvider.totalItems, 0);

        // Aksi: Mencoba menaikkan kuantitas item yang tidak ada
        cartProvider.increaseQuantity('non_existent_id');

        // Verifikasi: Tidak ada yang berubah
        expect(cartProvider.totalItems, 0);
        expect(cartProvider.totalPrice, 0.0);
      });
    });

    group('decreaseQuantity', () {
      test('should decrease the quantity of an existing item if quantity > 1', () {
        // Persiapan: Menambahkan item dengan kuantitas 2
        cartProvider.addItem(productId: 'prod1', name: 'Product A', price: 100.0, imageUrl: 'url1');
        cartProvider.increaseQuantity('prod1'); // Kuantitas jadi 2
        expect(cartProvider.items.first.quantity, 2);
        expect(cartProvider.totalPrice, 200.0);

        // Aksi: Menurunkan kuantitas
        cartProvider.decreaseQuantity('prod1');

        // Verifikasi: Kuantitas berkurang dan total harga diperbarui
        expect(cartProvider.items.first.quantity, 1);
        expect(cartProvider.totalPrice, 100.0);
      });

      test('should remove the item if quantity is 1', () {
        // Persiapan: Menambahkan item dengan kuantitas 1
        cartProvider.addItem(productId: 'prod1', name: 'Product A', price: 100.0, imageUrl: 'url1');
        expect(cartProvider.totalItems, 1);

        // Aksi: Menurunkan kuantitas
        cartProvider.decreaseQuantity('prod1');

        // Verifikasi: Item dihapus dari keranjang
        expect(cartProvider.totalItems, 0);
        expect(cartProvider.totalPrice, 0.0);
      });
    });

    group('removeItem', () {
      test('should remove the specified item from the cart', () {
        // Persiapan: Menambahkan dua item
        cartProvider.addItem(productId: 'prod1', name: 'Product A', price: 100.0, imageUrl: 'url1');
        cartProvider.addItem(productId: 'prod2', name: 'Product B', price: 50.0, imageUrl: 'url2');
        expect(cartProvider.totalItems, 2);
        expect(cartProvider.totalPrice, 150.0);

        // Aksi: Menghapus item pertama
        cartProvider.removeItem('prod1');

        // Verifikasi: Item berkurang, total harga diperbarui, dan item yang tersisa benar
        expect(cartProvider.totalItems, 1);
        expect(cartProvider.totalPrice, 50.0);
        expect(cartProvider.items.first.productId, 'prod2');
      });

      test('should do nothing if product ID does not exist', () {
        // Persiapan: Menambahkan satu item
        cartProvider.addItem(productId: 'prod1', name: 'Product A', price: 100.0, imageUrl: 'url1');
        expect(cartProvider.totalItems, 1);

        // Aksi: Mencoba menghapus item yang tidak ada
        cartProvider.removeItem('non_existent_id');

        // Verifikasi: Tidak ada yang berubah
        expect(cartProvider.totalItems, 1);
        expect(cartProvider.totalPrice, 100.0);
      });
    });

    group('clearCart', () {
      test('should remove all items from the cart', () {
        // Persiapan: Menambahkan beberapa item
        cartProvider.addItem(productId: 'prod1', name: 'Product A', price: 100.0, imageUrl: 'url1');
        cartProvider.addItem(productId: 'prod2', name: 'Product B', price: 50.0, imageUrl: 'url2');
        expect(cartProvider.totalItems, 2);

        // Aksi: Membersihkan keranjang
        cartProvider.clearCart();

        // Verifikasi: Keranjang menjadi kosong
        expect(cartProvider.totalItems, 0);
        expect(cartProvider.totalPrice, 0.0);
      });
    });
  });
}