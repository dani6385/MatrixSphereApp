// lib/screens/Attendance/widgets/Attendance_body.dart
import 'package:flutter/material.dart';
import '../crads/date_card.dart';


class AttendanceBody extends StatelessWidget {
  const AttendanceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          // 1. BANNER BIRU UNGGULAN
          //const FeaturedCard(), 
          
          SizedBox(height: 16),

          // 2. KARTU INFORMASI PUTIH (Asli Anda, Tanpa Menggunakan Kelas Tidak Dikenal)
          DateCard(),
        ],
      ),
    );
  }
}