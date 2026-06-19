import 'dart:async';
import '../services/mikrotik_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- SERVICE & STATE MANAGEMENT ---
  final _mikrotikService = MikroTikService();
  bool _isLoading = true;
  String? _errorMessage;

  // --- STATE VARIABLES FOR DYNAMIC STATS ---
  String _timeRemaining = 'N/A';
  String _downloadUsage = 'N/A';
  String _uploadUsage = 'N/A';
  final String _speedLimit = 'N/A';

  @override
  void initState() {
    super.initState();
    _connectAndFetchData();
  }

  @override
  void dispose() {
    _mikrotikService.disconnect();
    super.dispose();
  }

  Future<void> _connectAndFetchData() async {
    if (_mikrotikService.isConnected) {
      await _refreshData();
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await _mikrotikService.connect();
      await _refreshData();
    } catch (e) {
      setState(() {
        _errorMessage = "Connection Failed: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      const String currentUsername = 'testuser';
      final HotspotActiveUser? userStats = await _mikrotikService
          .getActiveUserStats(username: currentUsername);
      if (userStats != null) {
        setState(() {
          _timeRemaining = userStats.uptime;
          _downloadUsage = HotspotActiveUser.formatBytes(userStats.bytesOut);
          _uploadUsage = HotspotActiveUser.formatBytes(userStats.bytesIn);
        });
      } else {
        setState(() {
          _errorMessage =
              "User '$currentUsername' not found in active sessions.";
          _timeRemaining = 'N/A';
          _downloadUsage = 'N/A';
          _uploadUsage = 'N/A';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Data Fetch Failed: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withAlpha(51),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Dashboard',
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your connection overview',
              style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard(
                  context,
                  icon: Icons.timer,
                  label: 'Time Remaining',
                  value: _timeRemaining,
                  color: Colors.green,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.download,
                  label: 'Download',
                  value: _downloadUsage,
                  color: Colors.blueAccent,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.upload,
                  label: 'Upload',
                  value: _uploadUsage,
                  color: Colors.orangeAccent,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.speed,
                  label: 'Speed Limit',
                  value: _speedLimit,
                  color: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildChartCard(textTheme),
            const SizedBox(height: 24),
            _buildSessionControl(colorScheme),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _connectAndFetchData,
        tooltip: 'Refresh',
        backgroundColor: _isLoading
            ? Colors.grey
            : Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 30, color: color),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Card _buildChartCard(TextTheme textTheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Data Usage (MB)',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1500,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _bottomTitles,
                        reservedSize: 32,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: [
                    _makeGroupData(0, 500),
                    _makeGroupData(1, 850),
                    _makeGroupData(2, 720),
                    _makeGroupData(3, 1200, isToday: true),
                    _makeGroupData(4, 450),
                    _makeGroupData(5, 950),
                    _makeGroupData(6, 600),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionControl(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Control',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Disconnect Session'),
          subtitle: const Text('Ends your current internet session'),
          tileColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () {},
        ),
      ],
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, {bool isToday = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isToday ? Colors.redAccent : Colors.blueAccent,
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    final style = TextStyle(color: Colors.grey[600], fontSize: 14);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }
}
