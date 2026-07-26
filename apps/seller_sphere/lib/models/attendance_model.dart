/// Data model for an attendance record.
///
/// This class holds all the information related to a single
/// attendance entry, such as date, clock-in/out times, and status.
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

  /// Converts the object to a JSON map, suitable for Firebase.
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'clockInTime': clockInTime,
      'clockOutTime': clockOutTime,
      'status': status,
    };
  }

  /// Creates an instance from a JSON map.
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: DateTime.parse(json['date'] as String),
      clockInTime: json['clockInTime'] as String?,
      clockOutTime: json['clockOutTime'] as String?,
      status: json['status'] as String,
    );
  }
}

/// Represents a one-time event for showing a location error dialog.
class LocationErrorEvent {
  final String title;
  final String message;
  final bool needsSettings;

  LocationErrorEvent(this.title, this.message, this.needsSettings);
}

/// Represents a one-time event for showing a scan success dialog.
class ScanSuccessEvent {
  final bool isClockIn;
  final String message;

  ScanSuccessEvent({required this.isClockIn, required this.message});
}