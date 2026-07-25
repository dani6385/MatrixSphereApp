// lib/screens/Seller/Seller_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_ui/shared_ui.dart';
 
import 'widgets/menu_model.dart'; // Mengganti SideMenu dengan MenuModel yang lebih sesuai
import 'widgets/seller_app_bar.dart';
import 'widgets/seller_body.dart';


class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _fetchSellerData();
  }

  Future<void> _fetchSellerData() async {
    if (_user != null) {
      // Menggunakan UID pengguna sebagai ID seller di RTDB
      final snapshot = await _dbRef.child('sellers/${_user!.uid}').get();
      if (snapshot.exists && snapshot.value is Map) {
        setState(() {
        });
      } else {
        // Handle jika data seller belum ada di database
        if (kDebugMode) {
          print('Data seller untuk UID: ${_user!.uid} tidak ditemukan.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: SellerScreen.scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      appBar: const SellerAppBar(),
      // Menggunakan MenuModel yang sudah ada dan bisa kita kembangkan
      // Nantinya Anda bisa meneruskan _sellerData ke MenuModel jika diperlukan
      drawer: const MenuModel(), 
      //endDrawer: const SettingScreen(), 
      body: const SellerBody(),
    );
  }
}