// lib/screens/Seller_screen.dart

import 'package:flutter/material.dart';
import 'components/seller_appbar.dart';
import 'components/seller_body.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANG GLOBALKEY KE SCAFFOLD
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const SellerAppBar(),
      body: const SellerBody(),
    );
  }
}