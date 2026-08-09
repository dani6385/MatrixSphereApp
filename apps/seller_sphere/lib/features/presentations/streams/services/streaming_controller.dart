import 'package:flutter/material.dart';
import 'streaming_service.dart';
import 'chat_service.dart';
import '../models/chat_model.dart';
import 'package:shared_services/shared_services.dart';
import 'package:permission_handler/permission_handler.dart';

class StreamingController extends ChangeNotifier {
  final StreamingService _streamingService = StreamingService();
  final ChatService _chatService = ChatService();
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();

  bool isInitialized = false;
  bool isStreaming = false;
  bool isFrontCamera = true; // Sudah diatur default kamera depan
  bool isMicMuted = false;
  bool isCameraBusy =
      false; // State untuk menandakan kamera sedang sibuk (inisialisasi/beralih)
  String? errorMessage;
  String? _dynamicStreamKey;

  final String streamId;

  // Jika menggunakan api.video, ini adalah URL defaultnya.
  // Untuk platform lain, ganti dengan URL yang didapat dari dashboard mereka.
  final String rtmpUrl = "rtmp://broadcast.api.video/s/";

  // API key default (Stream Key) untuk layanan api.video
  static const String _defaultStreamKey =
      "ic1LygT4aJtyD9SZazquGMtR9BNGA9t6mzIYHdTEwGY";

  final String currentUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';
  final String currentUserName = 'Seller Pro';

  List<Product> products = [];

  StreamingService get service => _streamingService;

  StreamingController({required this.streamId});

  Future<void> init() async {
    // Ambil data produk dan konfigurasi stream dari Firebase
    await Future.wait([_fetchProducts(), _fetchStreamConfig()]);

    // Pastikan izin kamera dan mic sudah diberikan sebelum init controller
    // Ini memastikan library bisa mendeteksi posisi kamera dengan benar
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera] != PermissionStatus.granted) {
      errorMessage = "Izin kamera ditolak";
      notifyListeners();
      return;
    }

    _streamingService.initController(
      // Mengatur kamera depan sebagai kamera awal ('front')
      initialCamera: isFrontCamera ? 'front' : 'back',
      onConnectionSuccess: () {
        isStreaming = true;
        notifyListeners();
      },
      onConnectionFailed: (error) {
        isStreaming = false;
        errorMessage = error;
        notifyListeners();
      },
      onDisconnected: () {
        isStreaming = false;
        notifyListeners();
      },
    );

    try {
      isCameraBusy = true;
      notifyListeners();
      await _streamingService.initializeCamera();
      isInitialized = true;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isCameraBusy = false;
      notifyListeners();
    }
  }

  // Mengambil data produk dari Firebase RTDB
  Future<void> _fetchProducts() async {
    try {
      // Path ke produk berdasarkan shopUid (streamId diasumsikan sebagai shopUid)
      final snapshot =
          await _rtdbService.readData('seller_sphere/$streamId/produk');
      if (snapshot != null && snapshot.exists && snapshot.value != null) {
        final productsMap = Map<String, dynamic>.from(snapshot.value as Map);
        products = productsMap.entries.map((entry) {
          return Product.fromMap(
              Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();
      } else {
        products = []; // Kosongkan jika tidak ada produk
      }
    } catch (e) {
      errorMessage = "Gagal memuat produk: $e";
      products = [];
    }
    // Beri tahu listener bahwa data produk telah diperbarui
    notifyListeners();
  }

  // Mengambil konfigurasi stream (seperti streamKey spesifik toko)
  Future<void> _fetchStreamConfig() async {
    try {
      // Mengambil streamKey dari path: seller_sphere/$streamId/config/streamKey
      final snapshot = await _rtdbService
          .readData('seller_sphere/$streamId/config/streamKey');

      if (snapshot != null && snapshot.exists && snapshot.value != null) {
        _dynamicStreamKey = snapshot.value.toString();
        debugPrint("Stream Key khusus ditemukan untuk $streamId");
      }
    } catch (e) {
      debugPrint("Gagal mengambil config stream (menggunakan default): $e");
    }
  }

  Future<void> toggleStreaming() async {
    try {
      if (!isStreaming) {
        // Kita tetap menggunakan streamId untuk identifikasi data di Firebase,
        // namun untuk proses penyiaran ke api.video, kita gunakan Stream Key yang Anda berikan.
        // Di masa mendatang, Anda bisa menyimpan streamKey unik per toko di database.
        final String activeStreamKey = _dynamicStreamKey ?? _defaultStreamKey;
        await _streamingService.startStream(rtmpUrl, activeStreamKey);
      } else {
        await _streamingService.stopStream();
        isStreaming = false;
      }
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> switchCamera() async {
    if (isCameraBusy) {
      return; // Mencegah panggilan ganda saat kamera sedang beralih
    }

    try {
      isCameraBusy = true;
      notifyListeners();
      await _streamingService.switchCamera();
      isFrontCamera = !isFrontCamera;
    } finally {
      isCameraBusy = false;
      notifyListeners();
    }
  }

  void toggleMute() {
    _streamingService.toggleMute();
    isMicMuted = !isMicMuted;
    notifyListeners();
  }

  Future<void> sendChatMessage(String text) async {
    if (text.trim().isEmpty) return;

    final message = ChatMessage(
      senderId: currentUserId,
      senderName: currentUserName,
      message: text.trim(),
      timestamp: DateTime.now(),
    );

    await _chatService.sendMessage(streamId, message);
  }

  @override
  void dispose() {
    _streamingService.dispose();
    super.dispose();
  }
}
