import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../../providers/usage_chart_provider.dart';

class UsageChartWidget extends ConsumerWidget {
  final bool isTablet;

  const UsageChartWidget({required this.isTablet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartHeight = isTablet ? 280.0 : 200.0;
    final chartState = ref.watch(usageChartProvider);
    final chartDataAsync = chartState.data;

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
                children: List.generate(ChartPeriod.values.length, (i) {
                  final period = ChartPeriod.values[i];
                  final isActive = chartState.selectedPeriod == period;
                  return GestureDetector(
                    onTap: () => ref.read(usageChartProvider.notifier).setPeriod(period),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        period.displayName,
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
            child: chartDataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (_) {
                final currentData = ref.watch(currentChartDataProvider);
                final maxY = ref.watch(currentChartMaxYProvider);
                final touchedIndex = chartState.touchedIndex;

                if (currentData == null) {
                  return const Center(child: Text('Data tidak tersedia.'));
                }

                return LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (currentData.spots.length - 1).toDouble(),
                    minY: 0,
                    maxY: maxY,
                    clipData: const FlClipData.all(),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 4,
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
                          interval: maxY / 4,
                          getTitlesWidget: (value, meta) {
                            if (value == 0 || value == maxY) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              value >= 1000
                                  ? '${(value / 1000).toStringAsFixed(1)}G'
                                  : value.toStringAsFixed(
                                      currentData.unit == 'GB' ? 1 : 0),
                              style: GoogleFonts.dmSans(
                                fontSize: 10,
                                color: const Color(0xFF9E9E9E),
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
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
                            if (idx < 0 || idx >= currentData.xLabels.length) {
                              return const SizedBox.shrink();
                            }
                            // Show every other label to avoid crowding
                            if (currentData.spots.length > 8 && idx % 2 != 0) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                currentData.xLabels[idx],
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
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineTouchData: LineTouchData(
                      touchCallback:
                          (FlTouchEvent event, LineTouchResponse? response) {
                        int newIndex = -1;
                        if (response != null &&
                            response.lineBarSpots != null &&
                            response.lineBarSpots!.isNotEmpty) {
                          newIndex = response.lineBarSpots!.first.spotIndex;
                        }
                        ref
                            .read(usageChartProvider.notifier)
                            .setTouchedIndex(newIndex);
                      },
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) =>
                            const Color(0xFF1A1A1A),
                        getTooltipItems: (spots) {
                          return spots.map((spot) {
                            return LineTooltipItem(
                              '${spot.y.toStringAsFixed(currentData.unit == 'GB' ? 2 : 0)} ${currentData.unit}',
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
                        spots: currentData.spots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: AppColors.primary,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) {
                            final isActive = index == touchedIndex;
                            return FlDotCirclePainter(
                              radius: isActive ? 6 : 3,
                              color:
                                  isActive ? Colors.white : AppColors.primary,
                              strokeWidth: isActive ? 2.5 : 1.5,
                              strokeColor: AppColors.primary,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withAlpha(51),
                              AppColors.primary.withAlpha(0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                  color: AppColors.secondary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.secondary, size: 14),
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