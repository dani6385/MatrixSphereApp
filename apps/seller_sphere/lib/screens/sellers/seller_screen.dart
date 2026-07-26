
import 'package:flutter/material.dart';
//import 'package:seller_sphere/consts/const_color.dart';
//import 'package:seller_sphere/screens/seller/components/seller_body.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: primaryColor,
        title: const Text(
          'Seller Sphere',
          style: TextStyle(color: Colors.white),
        ),
      ),
      //body: const SellerBody(),
    );
  }
}