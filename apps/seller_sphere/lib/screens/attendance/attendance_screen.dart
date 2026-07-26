
import 'package:flutter/material.dart';
//import 'package:seller_sphere/consts/const_color.dart';
//import 'package:seller_sphere/screens/attendance/components/Attendance_body.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: primaryColor,
        title: const Text(
          'Atttendance',
          style: TextStyle(color: Colors.white),
        ),
      ),
      //body: const AttendanceBody(),
    );
  }
}