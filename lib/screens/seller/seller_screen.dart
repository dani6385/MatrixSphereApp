import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'widgets/seller_app_bar.dart';
import 'widgets/seller_content.dart';
import 'widgets/menu_modal.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: const SellerAppBar(),
      drawer: const MenuModel(),
      body: const SellerContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kDarkTextPrimary,
        foregroundColor: kDarkBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
