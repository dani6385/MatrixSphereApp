class Approval {
  final String id;
  final String nama;
  final String status;

  Approval({required this.id, required this.nama, required this.status});

  factory Approval.fromMap(String id, Map<dynamic, dynamic> data) {
    return Approval(
      id: id,
      nama: data['nama'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
