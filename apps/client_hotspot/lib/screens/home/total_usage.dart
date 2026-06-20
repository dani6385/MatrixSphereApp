
import 'package:flutter/material.dart';
import 'dart:math'; // Required for chart generation

// For demonstration, a dummy class. In a real app, this would be part of your data models.
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
    final MonthlyUsageDetails usageDetails = MonthlyUsageDetails.dummy();
    final Color primaryColor = const Color(0xFF0D1E40);
    final Color accentColor = const Color(0xFF2196F3);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('Rincian Penggunaan Total',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSummaryCard(usageDetails.totalUsage, usageDetails.month, primaryColor),
            const SizedBox(height: 24),
            _buildChartCard(usageDetails.dailyBreakdown, accentColor, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String totalUsage, String month, Color primaryColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Row(
          children: [
            Icon(Icons.data_usage_rounded, size: 48, color: primaryColor),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Penggunaan Bulan Ini',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  totalUsage,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  month,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(List<DailyUsage> dailyData, Color accentColor, Color primaryColor) {
  final double maxUsage = dailyData.map((d) => d.usageGB).reduce(max);

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Penggunaan Harian Minggu Ini',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dailyData.map((data) {
                final barHeight = (data.usageGB / maxUsage) * 180;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${data.usageGB.toStringAsFixed(1)}G',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 25,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.day,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
