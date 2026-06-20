import 'package:flutter/material.dart';

class DetailedQuota extends StatelessWidget {
  const DetailedQuota({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text(
          'Detailed Quota Usage',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Network Quality & Remaining Time
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Network Quality',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: 0.98,
                                strokeWidth: 8,
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(Colors.purple),
                                backgroundColor: Colors.grey.shade200,
                              ),
                              const Center(
                                  child: Text('9.8',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Optimal'),
                      ],
                    ),
                    Column(
                      children: const [
                        Text('Remaining Time',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('5d 12h',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Network Uptime'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Current Link Details
            _buildCard(
              title: 'Current Link Details',
              child: Column(
                children: [
                  const LinearProgressIndicator(
                    value: 0.36,
                    minHeight: 10,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Used 3.60 GB'),
                      Text('Max 10.00 GB'),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Data Breakdown
            _buildCard(
              title: 'Data Breakdown',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('• Main Quota: used 3.60 GB, max 10.00 GB (36% used)'),
                  SizedBox(height: 4),
                  Text('• Bonus Data: used 0.50 GB / max 2.00 GB (25% used)'),
                  SizedBox(height: 4),
                  Text(
                      '• Specific Apps: used 2.10 GB / max 5.00 GB (42% used)'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: 'Usage History',
              child: AspectRatio(
                aspectRatio: 1.7,
                child: Container(
                    color: Colors.grey.shade300,
                    child: const Center(child: Text("Chart Placeholder"))),
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
                title: 'Detailed Application Usage',
                child: Column(
                  children: [
                    _buildAppUsageRow(
                        'YouTube', '2.10 GB', 0.42, Colors.blue),
                    _buildAppUsageRow(
                        'Netflix', '0.50 GB', 0.25, Colors.red),
                    _buildAppUsageRow(
                        'Netflix', '2.10 GB', 0.10, Colors.purple),
                    _buildAppUsageRow(
                        'Netflix', '0.50 GB', 0.08, Colors.green),
                  ],
                )),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () {}, child: const Text("Purchase/Upgrade Plan")),
            const SizedBox(height: 8),
            OutlinedButton(
                onPressed: () {}, child: const Text("Set Usage Alerts")),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildAppUsageRow(
      String appName, String usage, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(appName),
          const Spacer(),
          Text(usage),
          const SizedBox(width: 10),
          Text('${(percent * 100).toInt()}%'),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
