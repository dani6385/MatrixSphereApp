import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';

class UsageChartWidget extends StatefulWidget {
  final bool isTablet;

  const UsageChartWidget({required this.isTablet, super.key});

  @override
  State<UsageChartWidget> createState() => _UsageChartWidgetState();
}

class _UsageChartWidgetState extends State<UsageChartWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production state management
  int _selectedPeriodIndex = 0;
  int _touchedIndex = -1;

  final List<String> _periods = ['7 Hari', '30 Hari', '3 Bulan'];

  // Mock usage data per period — MB per day
  final List<List<FlSpot>> _periodData = [
    // 7 Hari
    [
      const FlSpot(0, 42),
      const FlSpot(1, 78),
      const FlSpot(2, 55),
      const FlSpot(3, 91),
      const FlSpot(4, 67),
      const FlSpot(5, 110),
      const FlSpot(6, 85),
    ],
    // 30 Hari
    [
      const FlSpot(0, 30),
      const FlSpot(1, 55),
      const FlSpot(2, 48),
      const FlSpot(3, 72),
      const FlSpot(4, 61),
      const FlSpot(5, 88),
      const FlSpot(6, 45),
      const FlSpot(7, 93),
      const FlSpot(8, 77),
      const FlSpot(9, 105),
      const FlSpot(10, 82),
      const FlSpot(11, 68),
      const FlSpot(12, 114),
      const FlSpot(13, 90),
    ],
    // 3 Bulan
    [
      const FlSpot(0, 620),
      const FlSpot(1, 850),
      const FlSpot(2, 740),
      const FlSpot(3, 920),
      const FlSpot(4, 680),
      const FlSpot(5, 1050),
      const FlSpot(6, 780),
      const FlSpot(7, 930),
      const FlSpot(8, 860),
      const FlSpot(9, 1120),
      const FlSpot(10, 990),
      const FlSpot(11, 1240),
    ],
  ];

  final List<List<String>> _xLabels = [
    ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
    [
      '1',
      '3',
      '5',
      '7',
      '9',
      '11',
      '13',
      '15',
      '17',
      '19',
      '21',
      '23',
      '25',
      '27',
    ],
    [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ],
  ];

  final List<String> _units = ['MB', 'MB', 'MB'];

  List<FlSpot> get _currentData => _periodData[_selectedPeriodIndex];
  List<String> get _currentLabels => _xLabels[_selectedPeriodIndex];
  String get _currentUnit => _units[_selectedPeriodIndex];

  double get _maxY {
    final max = _currentData.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    return (max * 1.25).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final chartHeight = widget.isTablet ? 280.0 : 200.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period tab selector — anatomy locked from image extraction
          Row(
            children: [
              Expanded(
                child: Text(
                  'Riwayat Penggunaan',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              // Period tabs — pill style, active = underline/bold per image
              Row(
                children: List.generate(_periods.length, (i) {
                  final isActive = _selectedPeriodIndex == i;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPeriodIndex = i;
                        _touchedIndex = -1;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppTheme.primary
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _periods[i],
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF9E9E9E),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Line chart with gradient fill — anatomy locked from image
          SizedBox(
            height: chartHeight,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (_currentData.length - 1).toDouble(),
                minY: 0,
                maxY: _maxY,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _maxY / 4,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: const Color(0xFFF0F0F0),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: _maxY / 4,
                      getTitlesWidget: (value, meta) {
                        if (value == 0 || value == _maxY) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          value >= 1000
                              ? '${(value / 1000).toStringAsFixed(1)}G'
                              : value.toInt().toString(),
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            color: const Color(0xFF9E9E9E),
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _currentLabels.length) {
                          return const SizedBox.shrink();
                        }
                        // Show every other label to avoid crowding
                        if (_currentData.length > 8 && idx % 2 != 0) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _currentLabels[idx],
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              color: const Color(0xFF9E9E9E),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? response) {
                        setState(() {
                          if (response != null &&
                              response.lineBarSpots != null &&
                              response.lineBarSpots!.isNotEmpty) {
                            _touchedIndex =
                                response.lineBarSpots!.first.spotIndex;
                          } else {
                            _touchedIndex = -1;
                          }
                        });
                      },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => const Color(0xFF1A1A1A),
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(0)} $_currentUnit',
                          GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _currentData,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppTheme.primary,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        final isActive = index == _touchedIndex;
                        return FlDotCirclePainter(
                          radius: isActive ? 6 : 3,
                          color: isActive ? Colors.white : AppTheme.primary,
                          strokeWidth: isActive ? 2.5 : 1.5,
                          strokeColor: AppTheme.primary,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary.withAlpha(51),
                          AppTheme.primary.withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Summary section — anatomy locked from image: label + period dropdown + horizontal card scroll
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ringkasan',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Bulanan',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF5C5C5C),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: Color(0xFF5C5C5C),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Horizontal summary cards — anatomy locked from image
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _SummaryCard(
                  value: '248 MB',
                  label: 'Jun 2026',
                  dateRange: '1 Jun - 27 Jun',
                  icon: Icons.flash_on_rounded,
                ),
                SizedBox(width: 10),
                _SummaryCard(
                  value: '892 MB',
                  label: 'Mei 2026',
                  dateRange: '1 Mei - 31 Mei',
                  icon: Icons.flash_on_rounded,
                ),
                SizedBox(width: 10),
                _SummaryCard(
                  value: '1.2 GB',
                  label: 'Apr 2026',
                  dateRange: '1 Apr - 30 Apr',
                  icon: Icons.flash_on_rounded,
                ),
                SizedBox(width: 10),
                _SummaryCard(
                  value: '765 MB',
                  label: 'Mar 2026',
                  dateRange: '1 Mar - 31 Mar',
                  icon: Icons.flash_on_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Summary card — anatomy locked from image: value top-left + icon top-right + period label bold bottom + date range small below
class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final String dateRange;
  final IconData icon;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.dateRange,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.secondary, size: 14),
              ),
            ],
          ),
          const Spacer(),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dateRange,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}