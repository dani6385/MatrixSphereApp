import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';

class DateCard extends StatefulWidget {
  const DateCard({super.key});

  @override
  State<DateCard> createState() => _DateCardState();
}

class _DateCardState extends State<DateCard> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Inisialisasi waktu saat ini
    _currentTime = DateTime.now();
    // Atur timer untuk memperbarui waktu setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    // Hentikan timer untuk mencegah memory leak
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: kDarkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Format tanggal ke Bahasa Indonesia (e.g., "Kamis, 25 Juli 2024")
                  DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_currentTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kDarkTextPrimary,
                  ),
                ),
              ],
            ),
            Text(
              // Format waktu (e.g., "14:30:55")
              DateFormat('HH:mm:ss').format(_currentTime),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: kBrandPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }
}