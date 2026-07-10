
import 'package:firebase_database/firebase_database.dart';

class RtdbService {
  final FirebaseDatabase _database;

  RtdbService(this._database);

  // Method to get a database reference
  DatabaseReference ref(String path) {
    return _database.ref(path);
  }

  // Method to set data to a specific path
  Future<void> setData(String path, Map<String, dynamic> data) async {
    await _database.ref(path).set(data);
  }

  // Method to get data from a specific path
  Future<DataSnapshot> getData(String path) async {
    return await _database.ref(path).get();
  }

  // Method to update data at a specific path
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    await _database.ref(path).update(data);
  }

  // Method to delete data from a specific path
  Future<void> deleteData(String path) async {
    await _database.ref(path).remove();
  }

  // Method to listen for data changes at a specific path
  Stream<DatabaseEvent> onValue(String path) {
    return _database.ref(path).onValue;
  }
}
