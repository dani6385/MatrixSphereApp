
import 'package:flutter/material.dart';
//import 'package:seller_sphere/consts/const_color.dart';
//import 'package:seller_sphere/screens/inventory/components/inventory_body.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: primaryColor,
        title: const Text(
          'Inventory',
          style: TextStyle(color: Colors.white),
        ),
      ),
      //body: const InventoryBody(),
    );
  }
}