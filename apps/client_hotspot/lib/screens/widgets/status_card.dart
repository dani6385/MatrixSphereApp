import 'package:flutter/material.dart';
import 'home/detailed_quota.dart';
import 'home/season.dart';
import 'home/total_usage.dart';
import 'home/current_speed.dart';

class StatusCard extends StatelessWidget {
  final String sisaKuota;
  final double persenKuota;
  final String masaAktif;
  final String uptime;
  final String totalUsage;
  final String currentSpeed;
  final Color primaryColor;
  final Color accentColor;
  final Color cardColor;

  const StatusCard({
    super.key,
    required this.sisaKuota,
    required this.persenKuota,
    required this.masaAktif,
    required this.uptime,
    required this.totalUsage,
    required this.currentSpeed,
    required this.primaryColor,
    required this.accentColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailedQuota()),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SISA KUOTA',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sisaKuota,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      value: persenKuota,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                      strokeWidth: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 12.0,
                runSpacing: 12.0,
                children: [
                  _buildStatusInfo(
                    'Masa Aktif',
                    masaAktif,
                    Icons.timer_outlined,
                    accentColor,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SeasonScreen()),
                      );
                    },
                    child: _buildStatusInfo(
                      'Uptime',
                      uptime,
                      Icons.timer,
                      accentColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TotalUsageScreen()),
                      );
                    },
                    child: _buildStatusInfo(
                      'Total Usage',
                      totalUsage,
                      Icons.data_usage,
                      accentColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CurrentSpeedScreen()),
                      );
                    },
                    child: _buildStatusInfo(
                      'Current Speed',
                      currentSpeed,
                      Icons.speed,
                      accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusInfo(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF0D1E40),
          ),
        ),
      ],
    );
  }
}
