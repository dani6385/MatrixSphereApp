import 'firestore_service.dart';

class ServicesProvider {
  // Membuat instance singleton dari ServicesProvider.
  // Ini memastikan bahwa hanya ada satu objek ServicesProvider di seluruh aplikasi.
  ServicesProvider._privateConstructor();
  static final ServicesProvider _instance = ServicesProvider._privateConstructor();
  static ServicesProvider get instance => _instance;

  // Menyediakan instance dari FirestoreService.
  // Kelas lain akan mengakses service ini melalui `ServicesProvider.instance.firestoreService`.
  final FirestoreService firestoreService = FirestoreService();
}
