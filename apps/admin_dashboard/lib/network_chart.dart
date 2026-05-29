import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NetworkChart extends StatelessWidget {
  const NetworkChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1), FlSpot(1, 3), FlSpot(2, 2), FlSpot(3, 5),
              ],
              isCurved: true,
              color: Colors.pinkAccent,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}