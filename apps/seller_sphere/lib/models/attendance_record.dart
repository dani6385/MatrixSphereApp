class AttendanceRecord {
  final DateTime date;
  final String? clockInTime;
  final String? clockOutTime;
  final String status;

  AttendanceRecord({
    required this.date,
    this.clockInTime,
    this.clockOutTime,
    required this.status,
  });
}