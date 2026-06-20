import 'package:flutter/material.dart';
import 'dart:math';

// Data models for demonstration
class MonthlyUsageDetails {
  final String totalUsage;
  final String month;
  final List<DailyUsage> dailyBreakdown;

  MonthlyUsageDetails({
    this.totalUsage = '25.3 GB',
    this.month = 'Oktober 2023',
    required this.dailyBreakdown,
  });

  // Factory to generate dummy data
  factory MonthlyUsageDetails.dummy() {
    return MonthlyUsageDetails(
      dailyBreakdown: [
        DailyUsage(day: 'Sen', usageGB: 1.2),
        DailyUsage(day: 'Sel', usageGB: 2.5),
        DailyUsage(day: 'Rab', usageGB: 1.8),
        DailyUsage(day: 'Kam', usageGB: 3.1),
        DailyUsage(day: 'Jum', usageGB: 2.2),
        DailyUsage(day: 'Sab', usageGB: 4.5),
        DailyUsage(day: 'Min', usageGB: 3.8),
      ],
    );
  }
}

class DailyUsage {
  final String day;
  final double usageGB;
  DailyUsage({required this.day, required this.usageGB});
}

class TotalUsageScreen extends StatelessWidget {
  const TotalUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MonthlyUsageDetails data = MonthlyUsageDetails.dummy();
    final Color primaryColor = const Color(0xFF0D1E40);
    final Color accentColor = const Color(0xFF2196F3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Usage', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF4F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(data.totalUsage, data.month, primaryColor),
            const SizedBox(height: 24),
            _buildChart(data.dailyBreakdown, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String totalUsage, String month, Color textColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL USAGE THIS MONTH',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  totalUsage,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              month,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<DailyUsage> dailyData, Color barColor) {
    final double maxUsage = dailyData.map((d) => d.usageGB).reduce(max);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Daily Breakdown',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180, // Giving the chart a fixed height
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: dailyData.map((data) {
                  final double barHeight =
                      (data.usageGB / maxUsage) * 120; // Max height for a bar
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${data.usageGB.toStringAsFixed(1)}G'),
                      const SizedBox(height: 4),
                      Container(
                        height: barHeight,
                        width: 25,
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: barColor.withAlpha(8),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.day,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
