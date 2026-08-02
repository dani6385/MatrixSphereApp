
import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/sellers/components/Seller_drawer.dart';
import 'package:seller_sphere/screens/sellers/components/seller_appbar.dart';
import 'package:seller_sphere/screens/sellers/components/seller_end_drawer.dart';


class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SellerAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: SellerDrawer(),
      endDrawer: SellerEndDrawer(),
      body: Center(
        child: Text('Welcome to the Seller Screen!'),
      ),
    );
  }
}
