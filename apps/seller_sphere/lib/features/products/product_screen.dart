// lib/screens/product_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

import 'components/product_app_bar.dart';
import 'components/product_body.dart';
import 'mixins/product_screen_logic_mixin.dart';

class ProductScreen extends StatefulWidget {
  final String shopUid;

  const ProductScreen({super.key, required this.shopUid, required Product product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with TickerProviderStateMixin, ProductScreenLogicMixin {

  @override
  void initState() {
    super.initState();
    initLogic(widget.shopUid, this);
  }

  @override
  void dispose() {
    disposeLogic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: ProductAppBar(
          tabController: tabController,
          onScanBarcode: scanBarcode,
          onAddProduct: showProductFormDialog,
          currentTabIndex: tabController.index,
        ),
        body: ProductBody(
          shopUid: widget.shopUid,
          tabController: tabController,
          productsRef: productsRef,
          lastScannedBarcode: lastScannedBarcode,
        ),
      ),
    );
  }
}