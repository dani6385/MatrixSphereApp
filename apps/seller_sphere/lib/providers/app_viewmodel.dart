import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:seller_sphere/models/attendance_model.dart';

class AppViewModel with ChangeNotifier {
  // BehaviorSubject untuk menampung daftar produk
  final _products = BehaviorSubject<List<Product>>.seeded([]);
  final List<AttendanceRecord> _attendanceList = [];
  final String _ownerName = "Karyawan";
  // Stream getter untuk produk
  Stream<List<Product>> get products => _products.stream;

  AppViewModel() {
    // Inisialisasi data produk mock
    _loadMockProducts();
  }

  void _loadMockProducts() {
    _products.add([
      Product(
        id: 'p1',
        name: 'Kemeja Pria Lengan Panjang',
        description: 'Kemeja formal dan kasual, bahan katun premium.',
        price: 120000.0, // Assuming price is a double
        imageUrl:
            'https://images.unsplash.com/photo-1618763351220-f203521655ad?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        stock: 50,
        sku: '',
        purchasePrice: 0.0,
        sellingPrice: 0.0,
        category: '',
        minStockThreshold: 0,
        imageUrls: [],
        ageRating: 0,
      ),
      Product(
        id: 'p2',
        name: 'Celana Jeans Wanita High-Waist',
        description:
            'Celana jeans modern dengan potongan high-waist, nyaman dipakai.',
        price: 180000.0,
        imageUrl:
            'https://images.unsplash.com/photo-1541099644-47ae7e96077c?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        stock: 30,
        sku: '',
        purchasePrice: 0.0,
        sellingPrice: 0.0,
        category: '',
        minStockThreshold: 0,
        imageUrls: [],
        ageRating: 0,
      ),
      Product(
        id: 'p3',
        name: 'Sepatu Sneakers Unisex// TODO Implement this library.',
        description:
            'Sepatu sneakers ringan dan stylish untuk pria dan wanita.',
        price: 250000.0,
        imageUrl:
            'https://images.unsplash.com/photo-1514989940723-ad4750b5a659?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        stock: 20,
        sku: '',
        purchasePrice: 0.0,
        sellingPrice: 0.0,
        category: '',
        minStockThreshold: 0,
        imageUrls: [],
        ageRating: 0,
      ),
      Product(
        id: 'p4',
        name: 'Tas Selempang Kulit Sintetis',
        description:
            'Tas selempang elegan dengan bahan kulit sintetis berkualitas tinggi.',
        price: 95000.0,
        imageUrl:
            'https://images.unsplash.com/photo-1566150911716-ad573010b91d?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        stock: 40,
        sku: '',
        purchasePrice: 0.0,
        sellingPrice: 0.0,
        category: '',
        minStockThreshold: 0,
        imageUrls: [],
        ageRating: 0,
      ),
      Product(
        id: 'p5',
        name: 'Jam Tangan Digital Sporty',
        description:
            'Jam tangan digital multifungsi, tahan air, cocok untuk aktivitas outdoor.',
        price: 150000.0,
        imageUrl:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1999&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        stock: 35,
        sku: '',
        purchasePrice: 0.0,
        sellingPrice: 0.0,
        category: '',
        minStockThreshold: 0,
        imageUrls: [],
        ageRating: 0,
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _products.close();
  }

  List<AttendanceRecord> get attendanceList => _attendanceList;
  String get ownerName => _ownerName;

  // Simulates recording attendance. Returns true on success, false on failure.
  Future<bool> recordAttendance({required bool clockIn}) async {
    final today = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(today);

    final existingRecordIndex = _attendanceList.indexWhere(
        (rec) => DateFormat('yyyy-MM-dd').format(rec.date) == todayString);

    if (existingRecordIndex != -1) {
      // Record for today exists
      var record = _attendanceList[existingRecordIndex];
      if (clockIn && record.clockInTime != null) {
        return false; // Already clocked in
      }
      if (!clockIn && record.clockOutTime != null) {
        return false; // Already clocked out
      }
      if (!clockIn && record.clockInTime == null) {
        return false; // Must clock in first
      }

      _attendanceList[existingRecordIndex] = AttendanceRecord(
          date: record.date,
          clockInTime: clockIn
              ? DateFormat('HH:mm:ss').format(today)
              : record.clockInTime,
          clockOutTime: !clockIn
              ? DateFormat('HH:mm:ss').format(today)
              : record.clockOutTime,
          status: record.status);
    } else {
      // No record for today, create a new one
      if (!clockIn) return false; // Must clock in first
      _attendanceList.add(AttendanceRecord(
          date: today,
          clockInTime: DateFormat('HH:mm:ss').format(today),
          status: 'Hadir'));
    }
    notifyListeners();
    return true;
  }

  void triggerNotification(String title, String body) {
    // In a real app, you would use a plugin like flutter_local_notifications
    debugPrint("NOTIFICATION: $title - $body");
  }
}
