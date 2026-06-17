class UserModel {
  final String nama;
  final String macAddress;

  UserModel({required this.nama, required this.macAddress});

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      nama: map['nama'] ?? 'User Tanpa Nama',
      macAddress: map['mac_address'] ?? '00:00:00:00',
    );
  }
}