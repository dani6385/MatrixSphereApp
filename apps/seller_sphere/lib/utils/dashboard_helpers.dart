
class DayOrderStats {
  final int completed;
  final int awaiting;
  DayOrderStats(this.completed, this.awaiting);
  int get total => completed + awaiting;
}

class Triple<A, B, C> {
  final A first;
  final B second;
  final C third;
  Triple(this.first, this.second, this.third);
}
