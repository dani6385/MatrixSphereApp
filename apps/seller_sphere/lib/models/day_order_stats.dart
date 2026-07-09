class DayOrderStats {
  final int completed;
  final int awaiting;

  DayOrderStats(this.completed, this.awaiting);

  int get total => completed + awaiting;
}
