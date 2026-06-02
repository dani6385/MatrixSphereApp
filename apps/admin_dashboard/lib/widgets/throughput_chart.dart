import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Pastikan ini ada

class ThroughputChart extends StatefulWidget {
  const ThroughputChart({super.key}); // Perbaikan key constructor

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
