
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _currentTime = '';
  bool _isClockedIn = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
    Future.delayed(const Duration(seconds: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _currentTime,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => setState(() => _isClockedIn = !_isClockedIn),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isClockedIn ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(_isClockedIn ? 'CLOCK OUT' : 'CLOCK IN'),
            ),
          ],
        ),
      ),
    );
  }
}
