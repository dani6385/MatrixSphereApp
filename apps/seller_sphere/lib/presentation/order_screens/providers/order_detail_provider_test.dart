import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seller_sphere/presentation/order_screens/providers/order_detail_screen.dart';
import 'package:seller_sphere/presentation/order_screens/providers/order_provider.dart' as order_provider;

/// Repositori palsu untuk mengontrol data pesanan selama pengujian.
class FakeOrderRepository implements order_provider.OrderRepository {
  @override
  Future<order_provider.Order> fetchOrderById(String orderId) async {
    // Mensimulasikan pengambilan data yang berhasil
    return order_provider.Order(
      id: orderId,
      customerName: 'Test Customer',
      items: [
        order_provider.OrderItem(id: 'item1', name: 'Test Item', quantity: 1, price: 100)
      ],
      totalAmount: 100,
      orderDate: DateTime.now(),
      paymentMethod: 'Test',
      status: order_provider.PickupStatus.readyForPickup, // Status awal untuk pengujian
    );
  }

  @override
  Future<List<order_provider.Order>> fetchOrders() async {
    // Tidak digunakan dalam tes ini, tetapi harus diimplementasikan
    return [];
  }
}

void main() {
  group('OrderDetailNotifier', () {
    const orderId = 'order2'; // Menggunakan ID yang ada di data dummy
    late ProviderContainer container;
    late OrderDetailNotifier notifier;

    // setUp dijalankan sebelum setiap tes
    setUp(() {
      // Buat ProviderContainer dan override orderRepositoryProvider dengan implementasi palsu
      container = ProviderContainer(
        overrides: [
          order_provider.orderRepositoryProvider.overrideWithValue(FakeOrderRepository()),
        ],
      );
      // Dapatkan notifier dari container
      notifier = container.read(orderDetailProvider(orderId).notifier);
    });

    // tearDown dijalankan setelah setiap tes untuk membersihkan
    tearDown(() {
      container.dispose();
    });

    test(
        'initial state is loading, then fetches and holds order data',
        () async {
      // 2. Verifikasi Awal
      // State awal harus AsyncValue.loading()
      expect(notifier.state, const AsyncValue<OrderDetail>.loading());

      // Tunggu hingga proses fetch (yang disimulasikan) selesai
      final completer = Completer<void>();
      container.listen<AsyncValue<OrderDetail>>(orderDetailProvider(orderId),
          (previous, next) {
        if (!completer.isCompleted && (next.hasValue || next.hasError)) {
          completer.complete();
        }
      });
      await completer.future;

      // 3. Verifikasi Akhir
      // State harus berisi data setelah fetch
      expect(notifier.state.hasValue, isTrue);
      expect(notifier.state.value, isA<OrderDetail>());
      // Pastikan status awal adalah 'readyForPickup' sesuai data dummy
      expect(notifier.state.value?.status, PickupStatus.readyForPickup);
      expect(notifier.state.value?.orderId, orderId);
    });

    test(
        'markAsCompleted method updates the order status to completed',
        () async {
      // Tunggu data awal dimuat
      final initCompleter = Completer<void>();
      container.listen<AsyncValue<OrderDetail>>(orderDetailProvider(orderId),
          (previous, next) {
        if (!initCompleter.isCompleted && (next.hasValue || next.hasError)) {
          initCompleter.complete();
        }
      });
      await initCompleter.future;

      // Pastikan state awal sudah benar
      expect(notifier.state.value?.status, PickupStatus.readyForPickup);

      // 2. Aksi
      // Panggil metode untuk mengubah status
      await notifier.markAsCompleted();

      // 3. Verifikasi
      // State harus diperbarui dengan status 'completed'
      expect(notifier.state.value?.status, PickupStatus.completed);
    });
  });
}