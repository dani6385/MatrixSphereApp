// lib/streaming_view_model.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/models/product.dart';


class StreamingViewModel extends ChangeNotifier {
  // --- State ---
  bool _isLive = false;
  int _viewerCount = 0;
  int _liveDurationSec = 0;
  bool _useAutoPlayVideo = true;
  String _selectedVideoUrl =
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  String _customVideoUrlText = "";
  List<LiveChatMessage> _chatMessages = [];
  int _selectedTabIdx = 0;
  int _pinnedProductIndex = -1;

  Timer? _liveTimer;
  final List<Product> _products = [
    Product(
        name: "Kemeja Lengan Panjang Pria",
        sellingPrice: 150000,
        stock: 50,
        id: '',
        sku: '',
        description: '',
        price: 0,
        imageUrl: ''),
    Product(
        name: "Celana Jeans Wanita High-Waist",
        sellingPrice: 250000,
        stock: 30,
        id: '',
        sku: '',
        description: '',
        price: 0,
        imageUrl: ''),
    Product(
        name: "Sneakers Kanvas Unisex",
        sellingPrice: 320000,
        stock: 25,
        id: '',
        sku: '',
        description: '',
        price: 0,
        imageUrl: ''),
  ];

  // --- Getters ---
  bool get isLive => _isLive;
  int get viewerCount => _viewerCount;
  int get liveDurationSec => _liveDurationSec;
  bool get useAutoPlayVideo => _useAutoPlayVideo;
  String get selectedVideoUrl => _selectedVideoUrl;
  String get customVideoUrlText => _customVideoUrlText;
  List<LiveChatMessage> get chatMessages => _chatMessages;
  int get selectedTabIdx => _selectedTabIdx;
  int get pinnedProductIndex => _pinnedProductIndex;
  List<Product> get products => _products;
  Product? get pinnedProduct =>
      (_pinnedProductIndex >= 0 && _pinnedProductIndex < _products.length)
          ? _products[_pinnedProductIndex]
          : null;

  // --- Mock Data ---
  final _mockChatUsers = [
    "Randi",
    "Siska",
    "Budi",
    "Dewi",
    "Amir",
    "Vina",
    "Andi",
    "Lia"
  ];
  final _mockChatTexts = [
    "Kualitasnya bagus banget kak!",
    "Masih ada diskon promonya?",
    "Spill keranjang kuning nomor 1 dong",
    "Sisa warna apa aja ya?",
    "Bisa bayar COD ga?",
    "Ukuran XL ready kak?",
    "Udah aku checkout ya, tolong segera kirim",
    "Recommended seller mantap!",
  ];

  // --- Methods ---

  void toggleLiveStatus() {
    _isLive = !_isLive;
    if (_isLive) {
      _startLiveSimulation();
    } else {
      _stopLiveSimulation();
    }
    notifyListeners();
  }

  void _startLiveSimulation() {
    _viewerCount = 42;
    _liveDurationSec = 0;
    _chatMessages = [
      LiveChatMessage(
          sender: "Sistem Live",
          message: "Mulai menyiarkan secara langsung! ✨",
          isSystem: true)
    ];

    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _liveDurationSec++;
      // Random viewer fluctuating
      _viewerCount += (Random().nextInt(11) - 4);
      _viewerCount = _viewerCount.clamp(10, 350);

      // Simulated comments
      if (Random().nextInt(10) > 6) {
        final user = _mockChatUsers[Random().nextInt(_mockChatUsers.length)];
        final msg = _mockChatTexts[Random().nextInt(_mockChatTexts.length)];
        _chatMessages.add(LiveChatMessage(sender: user, message: msg));
        if (_chatMessages.length > 100) {
          _chatMessages.removeAt(0);
        }
      }
      notifyListeners();
    });
  }

  void _stopLiveSimulation() {
    _liveTimer?.cancel();
    _viewerCount = 0;
    _liveDurationSec = 0;
  }

  void addSellerMessage(String message) {
    if (message.trim().isNotEmpty) {
      _chatMessages.add(LiveChatMessage(
          sender: "Penjual", message: message.trim(), isSeller: true));
      notifyListeners();
    }
  }

  void setUseAutoPlayVideo(bool value) {
    _useAutoPlayVideo = value;
    notifyListeners();
  }

  void setSelectedVideoUrl(String url, {bool isPreset = false}) {
    _selectedVideoUrl = url;
    if (isPreset) {
      _customVideoUrlText = "";
    }
    notifyListeners();
  }

  void setCustomVideoUrl(String text) {
    _customVideoUrlText = text;
    if (text.trim().isNotEmpty) {
      _selectedVideoUrl = text.trim();
    }
    notifyListeners();
  }

  void setTab(int index) {
    _selectedTabIdx = index;
    notifyListeners();
  }

  void setPinnedProduct(int index) {
    _pinnedProductIndex = (_pinnedProductIndex == index) ? -1 : index;
    notifyListeners();
  }

  String formatRupiah(int price) {
    final format =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(price);
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }
}
