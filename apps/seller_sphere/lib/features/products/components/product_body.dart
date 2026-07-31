// lib/screens/widgets/product_screen_body.dart

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:shared_services/shared_services.dart';

import '../widgets/order_management.dart';
import '../widgets/sales_body.dart';
import 'product_drawers.dart';

class ProductBody extends StatelessWidget {
  final String shopUid;
  final TabController tabController;
  final DatabaseReference productsRef;
  final String? lastScannedBarcode;

  const ProductBody({
    super.key,
    required this.shopUid,
    required this.tabController,
    required this.productsRef,
    required this.lastScannedBarcode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ProductLeftDrawer(),
      endDrawer: const ProductRightDrawer(),
      body: TabBarView(
        controller: tabController,
        children: [
          OrderManagement(
            ordersRef: FirebaseDatabase.instance.ref('seller_sphere/$shopUid/orders'),
            onScanQrMatch: (String orderId) {},
          ),
          SalesBody(
            productsRef: productsRef,
            scannedBarcode: lastScannedBarcode,
          ),
        ],
      ),
    );
  }
}