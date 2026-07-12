
class DayOrderStats {
  final int completed;
  final int awaiting;
  int get total => completed + awaiting;
  DayOrderStats(this.completed, this.awaiting);
}

class DayChartData {
  final String dayLabel;
  final String dateLabel;
  final DayOrderStats stats;
  DayChartData(
      {required this.dayLabel, required this.dateLabel, required this.stats});
}
