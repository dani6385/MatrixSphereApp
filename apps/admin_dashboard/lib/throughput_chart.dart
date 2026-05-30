import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_services/shared_services.dart';

class ThroughputChart extends StatefulWidget {
  const ThroughputChart({super.key});

  @override
  _ThroughputChartState createState() => _ThroughputChartState();
}

class _ThroughputChartState extends State<ThroughputChart> {
  List<FlSpot> spots = []; // List titik data grafik
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Ambil data setiap 2 detik
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      updateGraphData();
    });
  }

  void updateGraphData() async {
    // Panggil service Mikrotik Anda
    double newData = await MikrotikService().getCurrentThroughput(); 
    
    setState(() {
      // Tambahkan titik baru, hapus yang lama jika sudah terlalu banyak (misal maksimal 20 titik)
      if (spots.length > 20) spots.removeAt(0);
      spots.add(FlSpot(spots.length.toDouble(), newData));
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Penting: hentikan timer saat widget ditutup
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
              spots: spots,
              isCurved: true,
              color: Colors.cyan,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
