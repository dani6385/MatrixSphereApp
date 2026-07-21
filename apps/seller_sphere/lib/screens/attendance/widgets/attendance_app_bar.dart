import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
//import 'package:shared_ui/shared_ui.dart';
//import 'package:matrix_sphere/routes/app_routes.dart';
//import 'package:provider/provider.dart';
//import '../../chat/providers/chat_provider.dart';
import '../attendance_screen.dart'; // 1. PASTIKAN IMPORT AttendanceSCREEN

class AttendanceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AttendanceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Attendance'),

      // 2. KODE LEADING MENJADI LEBIH SIMPEL & DIJAMIN AKTIF
      leading: IconButton(
        icon: const Icon(Icons.group),
        onPressed: () {
          // Membuka laci secara paksa menggunakan GlobalKey milik AttendanceScreen
          AttendanScreen.scaffoldKey.currentState?.openDrawer();
        },
      ),

      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(
                Icons.calendar_month), // Menggunakan ikon roda gigi (pengaturan)
            onPressed: () {
              // Membuka laci samping sebelah kanan (endDrawer)
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
