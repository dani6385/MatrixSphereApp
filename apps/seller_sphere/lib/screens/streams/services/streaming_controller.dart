import 'package:flutter/material.dart';
import 'streaming_service.dart';
import 'chat_service.dart';
import '../models/chat_model.dart';
import 'package:shared_services/shared_services.dart';

class StreamingController extends ChangeNotifier {
  final StreamingService _streamingService = StreamingService();
  final ChatService _chatService = ChatService();

  bool isInitialized = false;
  bool isStreaming = false;
  bool isFrontCamera = true;
  bool isMicMuted = false;
  String? errorMessage;

  final String streamId = 'myLiveStream123';
  final String rtmpUrl = "rtmp://your-rtmp-server.com/live";
  final String currentUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';
  final String currentUserName = 'Seller Pro';

  StreamingService get service => _streamingService;

  Future<void> init() async {
    _streamingService.initController(
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
    ); // Perhatikan parameter di Service harus sesuai (onDisconnection)

    try {
      await _streamingService.initializeCamera(isFrontCamera);
      isInitialized = true;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
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
    await _streamingService.switchCamera();
    isFrontCamera = !isFrontCamera;
    notifyListeners();
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

  // Mock Data Produk (Bisa dipindah ke ProductService nantinya)
  final List<Product> products = [
    Product(
      id: 'p1',
      name: 'T-Shirt Keren',
      imageUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?text=T-Shirt',
      price: 125000,
      stock: 10,
      purchasePrice: 0,
      sellingPrice: 125000,
      minStockThreshold: 1,
      ageRating: 0,
      imageUrls: [],
    ),
    // ... produk lainnya
  ];

  @override
  void dispose() {
    _streamingService.dispose();
    super.dispose();
  }
}