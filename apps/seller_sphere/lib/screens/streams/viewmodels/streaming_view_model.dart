import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../models/streaming_models.dart';

class StreamingViewModel extends ChangeNotifier {
  StreamingViewModel(TickerProvider vsync) {
    _tabController = TabController(length: 2, vsync: vsync);
    _initializeVideoPlayer();
    _scrollController.addListener(_scrollListener);
  }

  // --- Controllers ---
  late TabController _tabController;
  VideoPlayerController? _videoController;
  final TextEditingController _sellerMessageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController(); // Untuk chat list
  final ScrollController _scrollController = ScrollController(); // Untuk main screen

  // --- State Variables ---
  bool _isLive = false;
  int _viewerCount = 0;
  int _liveDurationSec = 0;
  Timer? _liveTimer;

  bool _useAutoPlayVideo = true;
  final String _selectedVideoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  
  bool _isFloatingVideo = false;
  List<LiveChatMessage> _chatMessages = [];
  int _pinnedProductIndex = -1;

  // --- Mock Data ---
  final List<Product> _products = [
    Product(id: 'p1', name: 'Kemeja Flanel Pria Lengan Panjang', sellingPrice: 150000, stock: 50),
    Product(id: 'p2', name: 'Celana Chino Slim Fit', sellingPrice: 225000, stock: 35),
    Product(id: 'p3', name: 'Sneakers Kanvas Klasik', sellingPrice: 350000, stock: 20),
    Product(id: 'p4', name: 'Topi Baseball Bordir', sellingPrice: 75000, stock: 100),
  ];
  final List<String> _mockChatUsers = ["Randi", "Siska", "Budi", "Dewi", "Amir", "Vina", "Andi", "Lia", "Aris", "Mega"];
  final List<String> _mockChatTexts = [
    "Kualitasnya bagus banget kak!", "Masih ada diskon promonya?", "Spill keranjang kuning nomor 1 dong",
    "Sisa warna apa aja ya?", "Bisa bayar COD ga?", "Ukuran XL ready kak?",
    "Udah aku checkout ya, tolong segera kirim", "Recommended seller mantap!",
    "Bahan bajunya adem ga kak?", "Ongkir ke Surabaya berapa ya?"
  ];

  // --- Getters ---
  TabController get tabController => _tabController;
  VideoPlayerController? get videoController => _videoController;
  TextEditingController get sellerMessageController => _sellerMessageController;
  ScrollController get chatScrollController => _chatScrollController;
  ScrollController get scrollController => _scrollController;
  
  bool get isLive => _isLive;
  int get viewerCount => _viewerCount;
  int get liveDurationSec => _liveDurationSec;
  bool get useAutoPlayVideo => _useAutoPlayVideo;
  List<LiveChatMessage> get chatMessages => _chatMessages;
  int get pinnedProductIndex => _pinnedProductIndex;
  bool get isFloatingVideo => _isFloatingVideo;
  List<Product> get products => _products;
  Product? get pinnedProduct {
    return _pinnedProductIndex >= 0 && _pinnedProductIndex < _products.length
        ? _products[_pinnedProductIndex]
        : null;
  }

  // --- Methods ---

  void _scrollListener() {
    // Threshold: video menjadi float setelah scroll melebihi 30% tinggi layar dikurangi tinggi appbar
    const threshold = (300 * 0.4) - kToolbarHeight;
    if (_scrollController.offset > threshold && !_isFloatingVideo) {
      _isFloatingVideo = true;
      notifyListeners();
    } else if (_scrollController.offset <= threshold && _isFloatingVideo) {
      _isFloatingVideo = false;
      notifyListeners();
    }
  }
  
  void _initializeVideoPlayer() {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(_selectedVideoUrl))
      ..initialize().then((_) {
        _videoController?.setLooping(true);
        if (_isLive && _useAutoPlayVideo) {
          _videoController?.play();
        }
        notifyListeners();
      });
  }

  void toggleLiveStatus() {
    _isLive = !_isLive;
    if (_isLive) {
      _startLiveSimulation();
      if (_useAutoPlayVideo) {
        _videoController?.play();
      }
    } else {
      _stopLiveSimulation();
      _videoController?.pause();
    }
    notifyListeners();
  }

  void _startLiveSimulation() {
    _liveTimer?.cancel();
    _viewerCount = 42;
    _liveDurationSec = 0;
    _chatMessages = [
      LiveChatMessage(sender: "Sistem Live", message: "Mulai menyiarkan secara langsung! ✨", isSystem: true)
    ];
    
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isLive) {
        timer.cancel();
        return;
      }
      _liveDurationSec++;
      _viewerCount = (_viewerCount + (Random().nextInt(11) - 4)).clamp(10, 350);

      if (Random().nextInt(10) > 6) {
        final user = _mockChatUsers[Random().nextInt(_mockChatUsers.length)];
        final msg = _mockChatTexts[Random().nextInt(_mockChatTexts.length)];
        _chatMessages.add(LiveChatMessage(sender: user, message: msg));
        if (_chatMessages.length > 100) {
          _chatMessages.removeAt(0);
        }
        _scrollToBottom();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void _stopLiveSimulation() {
    _liveTimer?.cancel();
    _viewerCount = 0;
    _liveDurationSec = 0;
    notifyListeners();
  }

  void _scrollToBottom() {
    if (_chatScrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void sendSellerMessage() {
    if (_sellerMessageController.text.trim().isNotEmpty) {
      _chatMessages.add(LiveChatMessage(
        sender: "Penjual",
        message: _sellerMessageController.text.trim(),
        isSeller: true,
      ));
      _sellerMessageController.clear();
      _scrollToBottom();
      notifyListeners();
    }
  }

  void sendQuickReply(String text) {
    _chatMessages.add(LiveChatMessage(
      sender: "Penjual",
      message: text,
      isSeller: true,
    ));
    _scrollToBottom();
    notifyListeners();
  }

  void setPinnedProductIndex(int index) {
    _pinnedProductIndex = _pinnedProductIndex == index ? -1 : index;
    notifyListeners();
  }

  void setUseAutoPlayVideo(bool value) {
    _useAutoPlayVideo = value;
    notifyListeners();
  }

  String formatRupiah(double price) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(price);
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    _sellerMessageController.dispose();
    _chatScrollController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}
