
import 'package:flutter/material.dart';
//import 'package:seller_sphere/consts/const_color.dart';
//import 'package:seller_sphere/screens/home/components/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      //body: const HomeBody(),
    );
  }
}