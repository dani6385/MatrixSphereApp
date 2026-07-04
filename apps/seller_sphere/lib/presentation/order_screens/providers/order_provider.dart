import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum untuk status pesanan.
/// Dibuat konsisten dengan order_detail_screen
enum PickupStatus {
  newOrder,
  preparing,
  readyForPickup,
  completed,
  cancelled,
}

/// Model untuk satu item dalam sebuah pesanan.
class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });
}

/// Model untuk satu pesanan.
class Order {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  PickupStatus status;
  final String customerName;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.paymentMethod,
    required this.status,
    required this.customerName,
  });
}

/// Repository untuk mengelola data pesanan.
class OrderRepository {
  static final List<Order> _dummyOrders = [
    Order(
      id: 'order1',
      customerName: 'Budi Santoso',
      items: [
        OrderItem(id: '1', name: 'Wireless Headphone Alpha', quantity: 1, price: 1500000),
        OrderItem(id: '3', name: 'Gaming Mouse X10', quantity: 1, price: 550000),
      ],
      totalAmount: 2050000,
      orderDate: DateTime.now().subtract(const Duration(hours: 1)),
      paymentMethod: 'E-Wallet (GoPay, OVO)',
      status: PickupStatus.preparing,
    ),
    Order(
      id: 'order2',
      customerName: 'Citra Lestari',
      items: [
        OrderItem(id: '4', name: 'Mechanical Keyboard Z', quantity: 1, price: 1800000),
      ],
      totalAmount: 1800000,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      paymentMethod: 'Transfer Bank',
      status: PickupStatus.readyForPickup,
    ),
    Order(
      id: 'order3',
      customerName: 'Agus Wijaya',
      items: [
        OrderItem(id: 'p4', name: 'Topi Baseball', quantity: 2, price: 85000),
      ],
      totalAmount: 170000,
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      paymentMethod: 'COD',
      status: PickupStatus.completed,
    ),
  ];

  Future<List<Order>> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List<Order>.from(_dummyOrders);
  }

  /// Mensimulasikan pengambilan data satu pesanan berdasarkan ID.
  Future<Order> fetchOrderById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      // Di aplikasi nyata, ini akan menjadi panggilan API ke /api/orders/{orderId}
      return _dummyOrders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      throw Exception('Pesanan dengan ID $orderId tidak ditemukan.');
    }
  }
}

// 1. Provider untuk instance OrderRepository.
final orderRepositoryProvider = Provider<OrderRepository>((ref) => OrderRepository());

// 2. Provider untuk menyimpan status filter yang dipilih. null berarti "Tampilkan Semua".
final orderFilterProvider = StateProvider<PickupStatus?>((ref) => null);

// 3. FutureProvider yang mengambil dan memfilter pesanan.
final filteredOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  final filter = ref.watch(orderFilterProvider);
  final allOrders = await repository.fetchOrders();

  if (filter == null) return allOrders;
  return allOrders.where((order) => order.status == filter).toList();
});