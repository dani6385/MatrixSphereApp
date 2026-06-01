import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_services/shared_services.dart';

class NetworkChart extends StatefulWidget {
  const NetworkChart({super.key});

  @override
  State<NetworkChart> createState() => _NetworkChartState();
}

class _NetworkChartState extends State<NetworkChart> {
  final MikrotikService _mikrotikService = MikrotikService();
  final List<FlSpot> _downloadSpots = [];
  final List<FlSpot> _uploadSpots = [];
  Timer? _timer;
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _connectToMikrotik();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchTrafficData();
    });
  }

  Future<void> _connectToMikrotik() async {
    // Replace with your actual credentials
    await _mikrotikService.connect('192.168.88.1', 'admin', '');
  }

  Future<void> _fetchTrafficData() async {
    try {
      final traffic = await _mikrotikService.getInterfaceTraffic();
      final downloadSpeed = traffic['download'] ?? 0.0;
      final uploadSpeed = traffic['upload'] ?? 0.0;

      setState(() {
        _downloadSpots.add(FlSpot(_time, downloadSpeed));
        _uploadSpots.add(FlSpot(_time, uploadSpeed));

        if (_downloadSpots.length > 20) {
          _downloadSpots.removeAt(0);
          _uploadSpots.removeAt(0);
        }

        _time += 2;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mikrotikService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _downloadSpots,
              isCurved: true,
              color: Colors.blue,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: _uploadSpots,
              isCurved: true,
              color: Colors.red,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
