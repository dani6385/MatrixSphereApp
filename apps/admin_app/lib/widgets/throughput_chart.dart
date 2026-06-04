
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Pastikan ini ada

class ThroughputChart extends StatefulWidget {
  const ThroughputChart({super.key}); // Perbaikan key constructor

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
>>>>>>> d7b204e (Initial commit: Setup monorepo flutter)

class TrafficChart extends StatelessWidget {
  @override

  State<ThroughputChart> createState() => _ThroughputChartState();
}

class _ThroughputChartState extends State<ThroughputChart> {
  final List<FlSpot> spots = [
    const FlSpot(0, 1),
    const FlSpot(1, 1.3),
    const FlSpot(2, 1.1),
    const FlSpot(3, 1.4),
    const FlSpot(4, 1.2),
  ];

  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        // Menentukan rentang sumbu X dari -60 (kiri) sampai 0 (kanan)
        minX: -60,
        maxX: 0,
        // Menyembunyikan grid agar terlihat seperti monitor trafik
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              // Data lama di kiri (x: -60) dan data terbaru di kanan (x: 0)
              FlSpot(-60, 2),
              FlSpot(-45, 5),
              FlSpot(-30, 3),
              FlSpot(-15, 8),
              FlSpot(0, 4), // Titik terbaru (detik ke-0)
            ],
            isCurved: true,
            color: Colors.greenAccent, // Warna khas monitoring
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true, 
              color: Colors.greenAccent.withOpacity(0.2)
            ),
          ),
        ],
      ),
    );
  }
}
class ThroughputChartState extends State<ThroughputChart> {
  List<FlSpot> spots = []; // List titik data grafik
  Timer? timer;
>>>>>>> d7b204e (Initial commit: Setup monorepo flutter)

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
