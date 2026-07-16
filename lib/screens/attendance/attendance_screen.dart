import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // Initialize date formatting for Indonesian locale
    initializeDateFormatting('id_ID', null);
    // Update the time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        backgroundColor: kDarkBackground,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: CircleAvatar(
            backgroundImage: AssetImage('images/img_profile-avatar.jpg'),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Absensi Karyawan',
                style:
                    textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
            Text('Check-in & Rekap',
                style:
                    textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Rekonsiliasi'),
            style: TextButton.styleFrom(
              foregroundColor: kDarkTextPrimary,
              backgroundColor: kDarkSecondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cloud_outlined, color: Colors.orange),
          ),
          IconButton(
            onPressed: () {
              // TODO: Navigate to actual settings screen
            },
            icon: const Icon(Icons.settings, color: kDarkTextPrimary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActiveEmployeeCard(context),
            const SizedBox(height: AppSpacing.lg),
            _buildAttendanceActions(context),
            const SizedBox(height: AppSpacing.md),
            _buildGeneralActions(context),
            const SizedBox(height: AppSpacing.lg),
            _buildMonthlyStats(context),
            const SizedBox(height: AppSpacing.lg),
            _buildAttendanceLog(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveEmployeeCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Formatter for time (HH:mm:ss)
    final timeFormatter = DateFormat('HH:mm:ss');
    // Formatter for date (Day, DD MMMM YYYY) in Indonesian
    final dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: kDarkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Karyawan Aktif',
              style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Matrix Admin',
                      style:
                          textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
                  Text('ID: EMP-0001 - Administrator',
                      style: textTheme.bodySmall
                          ?.copyWith(color: kDarkTextSecondary)),
                ],
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: kDarkTextPrimary,
                  side: const BorderSide(color: kDarkTextSecondary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Bukan Admin?'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: kDarkBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    timeFormatter.format(_now),
                    style: textTheme.displaySmall?.copyWith(
                        color: kDarkTextPrimary, fontWeight: FontWeight.bold),
                  ),
                  Text(dateFormatter.format(_now),
                      style: textTheme.bodyMedium
                          ?.copyWith(color: kDarkTextSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _buildActionCard(context,
                icon: Icons.fingerprint,
                title: 'Absen Masuk',
                subtitle: 'Mulai Jam Kerja')),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child: _buildActionCard(context,
                icon: Icons.exit_to_app,
                title: 'Absen Pulang',
                subtitle: 'Belum Masuk')),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle}) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: kDarkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kDarkTextPrimary, size: 24),
          const SizedBox(height: AppSpacing.lg),
          Text(title,
              style: textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
          Text(subtitle,
              style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        ],
      ),
    );
  }

  Widget _buildGeneralActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _buildSmallActionCard(context,
                icon: Icons.calendar_today, text: 'Ajukan Cuti / Izin')),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child: _buildSmallActionCard(context,
                icon: Icons.gps_fixed, text: 'Verifikasi GPS')),
      ],
    );
  }

  Widget _buildSmallActionCard(BuildContext context,
      {required IconData icon, required String text}) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        foregroundColor: kDarkTextPrimary,
        backgroundColor: kDarkSecondary,
        side: const BorderSide(color: kDarkSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildMonthlyStats(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statistik Bulan Ini',
            style: textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(context,
                count: '2', label: 'Hadir', color: kSoftTeal),
            _buildStatItem(context, count: '1', label: 'Tepat Waktu'),
            _buildStatItem(context,
                count: '1', label: 'Terlambat', color: kWarmOrange),
            _buildStatItem(context, count: '1', label: 'Izin/Sakit'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context,
      {required String count, required String label, Color? color}) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: kDarkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(count,
              style: textTheme.titleLarge?.copyWith(
                  color: color ?? kDarkTextPrimary, fontWeight: FontWeight.bold)),
          Text(label,
              style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        ],
      ),
    );
  }

  Widget _buildAttendanceLog(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Log Kehadiran Karyawan',
                style: textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
            const Spacer(),
            Text('8 Catatan',
                style:
                    textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: kDarkSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: kDarkBackground,
                child: Icon(Icons.person, color: kDarkTextSecondary),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dewi Fortuna',
                      style:
                          textTheme.bodyLarge?.copyWith(color: kDarkTextPrimary)),
                  Text('Status: Full Day Off Duty',
                      style: textTheme.bodySmall
                          ?.copyWith(color: kDarkTextSecondary)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Sakit',
                        style:
                            textTheme.bodySmall?.copyWith(color: kSoftTeal)),
                  ),
                  Text('2026-07-16',
                      style: textTheme.bodySmall
                          ?.copyWith(color: kDarkTextSecondary)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
