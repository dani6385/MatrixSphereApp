import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum untuk merepresentasikan periode waktu yang dipilih.
/// Lebih aman dan deskriptif daripada menggunakan integer index.
enum ChartPeriod { sevenDays, thirtyDays, threeMonths }

/// Model untuk menampung data dan label untuk satu periode grafik.
class ChartData {
  final List<FlSpot> spots;
  final List<String> xLabels;
  final String unit;

  ChartData({required this.spots, required this.xLabels, required this.unit});
}

/// Model untuk state dari provider grafik.
class UsageChartState {
  final ChartPeriod selectedPeriod;
  final int touchedIndex;
  final AsyncValue<Map<ChartPeriod, ChartData>> data;

  const UsageChartState({
    this.selectedPeriod = ChartPeriod.sevenDays,
    this.touchedIndex = -1,
    this.data = const AsyncValue.loading(),
  });

  UsageChartState copyWith({
    ChartPeriod? selectedPeriod,
    int? touchedIndex,
    AsyncValue<Map<ChartPeriod, ChartData>>? data,
  }) {
    return UsageChartState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      touchedIndex: touchedIndex ?? this.touchedIndex,
      data: data ?? this.data,
    );
  }
}

/// Notifier untuk mengelola state UsageChartWidget.
class UsageChartNotifier extends StateNotifier<UsageChartState> {
  UsageChartNotifier() : super(const UsageChartState()) {
    fetchChartData();
  }

  /// Mengubah periode grafik yang ditampilkan.
  void setPeriod(ChartPeriod newPeriod) {
    state = state.copyWith(selectedPeriod: newPeriod, touchedIndex: -1);
  }

  /// Mengatur index titik yang disentuh pada grafik.
  void setTouchedIndex(int index) {
    state = state.copyWith(touchedIndex: index);
  }

  /// Mengambil data mock untuk semua periode.
  Future<void> fetchChartData() async {
    state = state.copyWith(data: const AsyncValue.loading());
    try {
      // Simulasi pengambilan data dari API
      await Future.delayed(const Duration(milliseconds: 800));

      final data = {
        ChartPeriod.sevenDays: ChartData(
          unit: 'MB',
          xLabels: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
          spots: List.generate(7, (i) => FlSpot(i.toDouble(), 40 + Random().nextDouble() * 80)),
        ),
        ChartPeriod.thirtyDays: ChartData(
          unit: 'MB',
          xLabels: List.generate(15, (i) => (i * 2 + 1).toString()),
          spots: List.generate(15, (i) => FlSpot(i.toDouble(), 30 + Random().nextDouble() * 90)),
        ),
        ChartPeriod.threeMonths: ChartData(
          unit: 'GB',
          xLabels: ['Jan', 'Feb', 'Mar'],
          spots: List.generate(3, (i) => FlSpot(i.toDouble(), 0.8 + Random().nextDouble() * 0.5)),
        ),
      };

      state = state.copyWith(data: AsyncValue.data(data));
    } catch (e, s) {
      state = state.copyWith(data: AsyncValue.error(e, s));
    }
  }
}

/// Provider global untuk UsageChartNotifier.
final usageChartProvider = StateNotifierProvider<UsageChartNotifier, UsageChartState>((ref) {
  return UsageChartNotifier();
});

/// Provider turunan untuk mendapatkan data grafik periode saat ini dengan mudah.
final currentChartDataProvider = Provider<ChartData?>((ref) {
  final chartState = ref.watch(usageChartProvider);
  return chartState.data.whenData((data) => data[chartState.selectedPeriod]).value;
});

/// Provider turunan untuk mendapatkan nilai Y maksimum dari data saat ini.
final currentChartMaxYProvider = Provider<double>((ref) {
  final currentData = ref.watch(currentChartDataProvider);
  if (currentData == null || currentData.spots.isEmpty) return 100;

  final max = currentData.spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
  // Beri sedikit ruang di atas titik tertinggi
  return (max * 1.25).ceilToDouble();
});

/// Provider turunan untuk mendapatkan daftar periode yang tersedia.
final chartPeriodsProvider = Provider<List<ChartPeriod>>((ref) {
  return ChartPeriod.values;
});

/// Helper untuk mengubah enum menjadi string yang bisa dibaca.
extension ChartPeriodExtension on ChartPeriod {
  String get displayName {
    switch (this) {
      case ChartPeriod.sevenDays:
        return '7 Hari';
      case ChartPeriod.thirtyDays:
        return '30 Hari';
      case ChartPeriod.threeMonths:
        return '3 Bulan';
    }
  }
}