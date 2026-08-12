<<<<<<< HEAD
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

import 'cashier_body.dart';
import 'order_list_view.dart';

class ManagementBody extends StatefulWidget {
  const ManagementBody({super.key});

  @override
  State<ManagementBody> createState() => _ManagementBodyState();
}

class _ManagementBodyState extends State<ManagementBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _shopId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchShopId();
  }

  Future<void> _fetchShopId() async {
    final authService = AuthService();
    final id = await authService.getCurrentShopId();
    if (mounted) {
      setState(() {
        _shopId = id;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Orderan'),
            Tab(icon: Icon(Icons.point_of_sale_outlined), text: 'Kasir'),
          ],
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _shopId == null
                  ? const Center(child: Text('Toko tidak ditemukan.'))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Gunakan _shopId yang sudah didapat secara dinamis
                        OrderListView(shopId: _shopId!),
                        const CashierBody(),
                      ],
                    ),
        ),
      ],
    );
  }
}
=======

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';


import 'cashier_body.dart';
import 'order_list_view.dart';

class ManagementBody extends StatefulWidget {
  const ManagementBody({super.key});

  @override
  State<ManagementBody> createState() => _ManagementBodyState();
}

class _ManagementBodyState extends State<ManagementBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Orderan'),
            Tab(icon: Icon(Icons.point_of_sale_outlined), text: 'Kasir'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(),
              const CashierBody(),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildOrderList() {
  // Asumsi FirebaseRtdbService memiliki getter 'ordersRef'
  final DatabaseReference ordersRef = FirebaseRtdbService().ordersRef;

  return StreamBuilder<DatabaseEvent>(
    stream: ordersRef.onValue,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      final data = snapshot.data?.snapshot.value;
      if (data == null || (data is Map && data.isEmpty)) {
        return const Center(child: Text('Belum ada orderan masuk.'));
      }

      final ordersMap = Map<String, dynamic>.from(data as Map);
      final List<Order> orders = ordersMap.entries.map((entry) {
        return Order.fromMap(Map<String, dynamic>.from(entry.value), entry.key);
      }).toList();

      return OrderListView(orders: orders);
    },
  );
}
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

import 'cashier_body.dart';
import 'order_list_view.dart';

class ManagementBody extends StatefulWidget {
  const ManagementBody({super.key});

  @override
  State<ManagementBody> createState() => _ManagementBodyState();
}

class _ManagementBodyState extends State<ManagementBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _shopId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchShopId();
  }

  Future<void> _fetchShopId() async {
    final authService = AuthService();
    final id = await authService.getCurrentShopId();
    if (mounted) {
      setState(() {
        _shopId = id;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Orderan'),
            Tab(icon: Icon(Icons.point_of_sale_outlined), text: 'Kasir'),
          ],
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _shopId == null
                  ? const Center(child: Text('Toko tidak ditemukan.'))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Gunakan _shopId yang sudah didapat secara dinamis
                        OrderListView(shopId: _shopId!, orders: const [],),
                        const CashierBody(),
                      ],
                    ),
        ),
      ],
    );
  }
}
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
