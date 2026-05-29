import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrafficMonitor extends StatelessWidget {
  const TrafficMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(0, 5),
      ChartData(1, 10),
      ChartData(2, 7),
    ];

    return SfCartesianChart(
      primaryXAxis: NumericAxis(),
      primaryYAxis: NumericAxis(),
      series: <CartesianSeries>[
        LineSeries<ChartData, int>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          color: Colors.pinkAccent,
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
