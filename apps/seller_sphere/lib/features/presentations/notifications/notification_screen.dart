import 'package:flutter/material.dart';

/// Halaman untuk menampilkan pengaturan notifikasi.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Pengaturan Notifikasi akan ditampilkan di sini.'),
      ),
    );
  }
}