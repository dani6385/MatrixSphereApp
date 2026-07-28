import 'package:flutter/material.dart';
import 'streaming_service.dart';
import 'chat_service.dart';
import '../models/chat_model.dart';
import 'package:shared_services/shared_services.dart';

class StreamingController extends ChangeNotifier {
  final StreamingService _streamingService = StreamingService();
  final ChatService _chatService = ChatService();
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();

  bool isInitialized = false;
  bool isStreaming = false;
  bool isFrontCamera = true;
  bool isMicMuted = false;
  bool isCameraBusy = false; // State untuk menandakan kamera sedang sibuk (inisialisasi/beralih)
  String? errorMessage;

  final String streamId;
  final String rtmpUrl = "rtmp://your-rtmp-server.com/live";
  final String currentUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';
  final String currentUserName = 'Seller Pro';

  List<Product> products = [];

  StreamingService get service => _streamingService;

  StreamingController({required this.streamId});

  Future<void> init() async {
    // Ambil data produk dari Firebase
    await _fetchProducts();

    _streamingService.initController(
      // Perhatikan parameter di Service harus sesuai (onDisconnection)
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
      await _streamingService.initializeCamera(isFrontCamera);
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

  Future<void> toggleStreaming() async {
    try {
      if (!isStreaming) {
        await _streamingService.startStream(rtmpUrl, streamId);
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
    if (isCameraBusy) return; // Mencegah panggilan ganda saat kamera sedang beralih

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
