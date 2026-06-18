import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:shared_services/shared_services.dart';
//import 'login_screen.dart';
//import '../models/user_model.dart'; // Import model yang kita buat tadi

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Dashboard')),
    );
  }
}
