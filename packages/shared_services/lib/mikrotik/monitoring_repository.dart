class MonitoringDashboard extends StatelessWidget {
  final Stream<DocumentSnapshot> statsStream;
  final List<Map<String, dynamic>> interfaces;
  final bool isLoading;

  const MonitoringDashboard({
    required this.statsStream,
    required this.interfaces,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // Pindahkan semua logic UI dari AdminWidgets ke sini
    // Gunakan StreamBuilder di sini untuk memantau statsStream
  }
}