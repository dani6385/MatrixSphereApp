import 'package:flutter/material.dart';
import 'package:shop_sphere/screens/shops/widgets/shop_app_bar.dart';
import 'package:shop_sphere/screens/shops/widgets/shop_body.dart';
import 'package:shop_sphere/screens/shops/widgets/shop_drawer.dart';
import 'package:shop_sphere/screens/shops/widgets/shop_end_drawer.dart';

class ShopScreen extends StatelessWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: const ShopAppBar(),
      drawer: const ShopDrawer(),
      endDrawer: const ShopEndDrawer(),
      body: const ShopBody(),
    );
  }
}