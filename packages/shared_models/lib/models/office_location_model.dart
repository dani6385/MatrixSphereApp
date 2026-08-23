class OfficeLocationModel {
  final double latitude;
  final double longitude;
  final double allowedRadiusInMeters;

  OfficeLocationModel({
    required this.latitude,
    required this.longitude,
    required this.allowedRadiusInMeters,
  });

  // Contoh jika nanti data diambil dari API JSON
  factory OfficeLocationModel.fromJson(Map<String, dynamic> json) {
    return OfficeLocationModel(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      allowedRadiusInMeters: (json['allowed_radius'] as num).toDouble(),
    );
  }
}