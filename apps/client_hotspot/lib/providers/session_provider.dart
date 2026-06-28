import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_services/shared_services.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

/// Model untuk menampung data sesi pengguna yang aktif.
class SessionInfo {
  final String username;
  final String packageName;
  final double quotaUsedPercent;
  final int quotaUsedMB;
  final int quotaTotalMB;
  final String expiresAt;

  SessionInfo({
    required this.username,
    required this.packageName,
    required this.quotaUsedPercent,
    required this.quotaUsedMB,
    required this.quotaTotalMB,
    required this.expiresAt,
  });
}

class SessionProvider with ChangeNotifier {
  SessionInfo? _sessionInfo;
  bool _isLoading = false;
  String? _errorMessage;
  final RtdbService _rtdbService;

  SessionInfo? get sessionInfo => _sessionInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SessionProvider(this._rtdbService) {
    fetchSessionInfo();
  }

  /// Mengambil data sesi pengguna dari RTDB.
  Future<void> fetchSessionInfo() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Panggil service untuk mendapatkan data dari RTDB
      // ID Mikrotik dan User masih statis untuk contoh ini
      const mikrotikId = 'mikrotik_A_id';
      const userId = 'user_123';
      final data = await _rtdbService.getUserSession(mikrotikId, userId);

      if (data != null && data['quota'] != null) {
        final quotaData = Map<String, dynamic>.from(data['quota'] as Map);
        // Prioritaskan 'main_quota'
        final mainQuota = Map<String, dynamic>.from(quotaData['main_quota'] as Map);

        final double total = (mainQuota['total'] as num).toDouble();
        final double sisa = (mainQuota['sisa'] as num).toDouble();
        final double used = total - sisa;

        // Petakan respons dari service ke model SessionInfo
        _sessionInfo = SessionInfo(
          username: userId, // Menggunakan userId sebagai username
          packageName: mainQuota['nama'] as String,
          quotaUsedPercent: total > 0 ? (used / total) * 100 : 0,
          quotaUsedMB: (used * 1024).toInt(), // Asumsi sisa/total dalam GB
          quotaTotalMB: (total * 1024).toInt(),
          expiresAt: mainQuota['valid_until'] as String,
        );
        _errorMessage = null; // Hapus error sebelumnya jika berhasil
      } else {
        throw Exception('Data kuota tidak ditemukan.');
      }
    } catch (e, stackTrace) {
      _errorMessage = "Gagal memuat data sesi dari RTDB.";
      // Menggunakan logger untuk output yang lebih baik
      logger.e(
        'Error in fetchSessionInfo',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  /// Membersihkan data sesi saat pengguna logout.
  void logout() {
    _sessionInfo = null;
    // Tidak perlu memanggil notifyListeners() jika navigasi terjadi segera,
    // tetapi ini adalah praktik yang baik jika ada UI yang bergantung pada
    // state null sebelum navigasi.
  }

  /// Menggunakan voucher dan memperbarui data sesi jika berhasil.
  Future<void> redeemVoucher(String voucherCode) async {
    // Set isLoading agar UI bisa menampilkan indicator
    _isLoading = true;
    notifyListeners();

    try {
      // Logika redeem voucher via RTDB belum diimplementasikan
      // Untuk sekarang, kita panggil ulang fetchSessionInfo untuk refresh
      // final newSessionData = await _apiService.redeemVoucher(voucherCode);
      await Future.delayed(const Duration(seconds: 1)); // simulasi
      if (voucherCode.toUpperCase().contains('INVALID')) {
        throw Exception('Kode voucher tidak valid atau sudah digunakan.');
      }

      // Jika berhasil, panggil fetchSessionInfo() untuk mendapatkan data terbaru
      // Ini akan mensimulasikan penambahan kuota jika data di RTDB berubah
      await fetchSessionInfo();

      _errorMessage = null;
    } catch (e) {
      // Jika gagal, lemparkan kembali error agar dialog bisa menampilkannya
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}