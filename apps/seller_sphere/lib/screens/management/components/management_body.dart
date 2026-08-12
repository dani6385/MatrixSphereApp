
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
    final ShopService shopService = ShopService();
    final id = await shopService.getCurrentShopId(authService.currentUser);
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