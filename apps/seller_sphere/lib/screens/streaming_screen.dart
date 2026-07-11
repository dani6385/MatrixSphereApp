
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart'; // For number formatting

import '../viewmodels/app_view_model.dart'; // Assuming ViewModel is here
import '../models/shopsphere_order.dart'; // Assuming Product model is here
import '../utils/color_utils.dart'; // Assuming colors might be here

// --- Custom Colors (as defined in the original theme) ---
const Color neonCyan = Color(0xFF00FFFF);
const Color alertRed = Color(0xFFF44336);
const Color softTeal = Color(0xFF4DB6AC);
const Color vividOrchid = Color(0xFFD000C8);

class LiveChatMessage {
  final String sender;
  final String message;
  final bool isSystem;
  final bool isSeller;

  LiveChatMessage({
    required this.sender,
    required this.message,
    this.isSystem = false,
    this.isSeller = false,
  });
}

class StreamingScreen extends StatefulWidget {
  final AppViewModel viewModel;

  const StreamingScreen({Key? key, required this.viewModel}) : super(key: key);

  @override
  _StreamingScreenState createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> with TickerProviderStateMixin {
  bool _isLive = false;
  int _viewerCount = 0;
  int _liveDurationSec = 0;
  Timer? _liveTimer;

  bool _useAutoPlayVideo = true;
  String _selectedVideoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  final TextEditingController _customVideoUrlController = TextEditingController();

  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;

  final List<LiveChatMessage> _chatMessages = [];
  final TextEditingController _sellerMessageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  
  late TabController _tabController;
  int _pinnedProductIndex = -1;

  final Random _random = Random();

  final List<String> _mockChatUsers = ["Randi", "Siska", "Budi", "Dewi", "Amir", "Vina", "Andi", "Lia", "Aris", "Mega"];
  final List<String> _mockChatTexts = [
    "Kualitasnya bagus banget kak!",
    "Masih ada diskon promonya?",
    "Spill keranjang kuning nomor 1 dong",
    "Sisa warna apa aja ya?",
    "Bisa bayar COD ga?",
    "Ukuran XL ready kak?",
    "Udah aku checkout ya, tolong segera kirim",
    "Recommended seller mantap!",
    "Bahan bajunya adem ga kak?",
    "Ongkir ke Surabaya berapa ya?"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (_useAutoPlayVideo) {
      _initializeVideo(_selectedVideoUrl);
    }
  }

  void _initializeVideo(String url) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    _initializeVideoPlayerFuture = _videoController!.initialize().then((_) {
      _videoController!.setLooping(true);
      if (_isLive) {
        _videoController!.play();
      }
      setState(() {});
    });
  }

  void _toggleLiveStatus() {
    setState(() {
      _isLive = !_isLive;

      if (_isLive) {
        _viewerCount = 42;
        _liveDurationSec = 0;
        _chatMessages.clear();
        _chatMessages.add(LiveChatMessage(
          sender: "Sistem Live",
          message: "Mulai menyiarkan secara langsung! ✨",
          isSystem: true,
        ));
        
        if (_useAutoPlayVideo) {
          _videoController?.play();
        }

        _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _liveDurationSec++;
            _viewerCount = max(10, min(350, _viewerCount + _random.nextInt(11) - 4));

            if (_random.nextInt(10) > 6) {
              final user = _mockChatUsers[_random.nextInt(_mockChatUsers.length)];
              final msg = _mockChatTexts[_random.nextInt(_mockChatTexts.length)];
              _chatMessages.add(LiveChatMessage(sender: user, message: msg));
              if (_chatMessages.length > 100) {
                _chatMessages.removeAt(0);
              }
              _scrollToBottom();
            }
          });
        });
      } else {
        _liveTimer?.cancel();
        _viewerCount = 0;
        _liveDurationSec = 0;
        _videoController?.pause();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Assuming this formatting function exists in your view model or a utility class
  String formatRupiah(double price) {
      return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(price);
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    _videoController?.dispose();
    _customVideoUrlController.dispose();
    _sellerMessageController.dispose();
    _chatScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This would come from your view model's stream/state
    final List<Product> products = widget.viewModel.products; 
    final Product? pinnedProduct = _pinnedProductIndex != -1 && _pinnedProductIndex < products.length
        ? products[_pinnedProductIndex]
        : null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.live_tv, color: neonCyan),
            const SizedBox(width: 8),
            Text(
              "Live Streaming Console",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Live Stream Video Player ---
            Expanded(
              flex: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: _isLive ? alertRed : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: _buildVideoPlayer(pinnedProduct),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // --- Interactive Console ---
            Expanded(
              flex: 12,
              child: Card(
                 shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.15), width: 1),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      _buildConsoleHeader(),
                      _buildTabBar(),
                      Expanded(child: _buildTabBarView(products)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(Product? pinnedProduct) {
    return Stack(
      children: [
        if (_isLive)
          _buildLiveContent()
        else
          _buildOfflineContent(),

        // --- Live Status Overlays ---
        if (_isLive) ...[
          _buildLiveStatusBadges(),
          if (pinnedProduct != null)
             _buildPinnedProductOverlay(pinnedProduct),
        ],
        
        // --- Center Text Overlay ---
        if(_isLive)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                _useAutoPlayVideo ? "📺 Putar Video Otomatis Aktif" : "📡 Kamera Aktif Menyiar...",
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLiveContent() {
    if (_useAutoPlayVideo && _videoController != null && _videoController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
      );
    } else {
       // Futuristic glowing camera static lines / radar gradient
       return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
             child: Container(
                width: MediaQuery.of(context).size.height * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                 decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     color: neonCyan.withOpacity(0.04)
                 ),
             )
          ),
       );
    }
  }

  Widget _buildOfflineContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.videocam_off_outlined,
          size: 56,
          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
        ),
        const SizedBox(height: 8),
        Text(
          "Siaran Belum Dimulai",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            "Gunakan fitur ini untuk mempromosikan produk secara langsung (live) kepada pelanggan Anda.",
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLiveStatusBadges() {
    return Positioned(
      top: 12,
      left: 12,
      child: Row(
        children: [
          // LIVE indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: alertRed,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: const Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          // Viewer counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.visibility, color: Colors.white, size: 12),
                const SizedBox(width: 4),
                Text(
                  '$_viewerCount',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Duration timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Text(
              formatDuration(_liveDurationSec),
              style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPinnedProductOverlay(Product pinnedProduct) {
      return Positioned(
          bottom: 12,
          right: 12,
          child: Card(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: neonCyan.withOpacity(0.5), width: 1)
              ),
              child: Container(
                  width: 135,
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Container(
                            height: 36,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(4.0)
                            ),
                            child: const Icon(Icons.shopping_bag_outlined, color: neonCyan, size: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                              pinnedProduct.name,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                          ),
                           Text(
                              formatRupiah(pinnedProduct.sellingPrice),
                              style: const TextStyle(fontSize: 9, color: softTeal, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              decoration: BoxDecoration(
                                  color: neonCyan,
                                  borderRadius: BorderRadius.circular(4.0)
                              ),
                              child: const Center(
                                  child: Text("TERSEMAT", style: TextStyle(color: Colors.black, fontSize: 8.0, fontWeight: FontWeight.bold))
                              ),
                          )
                      ]
                  )
              )
          )
      );
  }

  Widget _buildConsoleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "KONTROL INTERAKTIF",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(
          height: 32,
          child: ElevatedButton.icon(
            onPressed: _toggleLiveStatus,
            icon: Icon(_isLive ? Icons.stop : Icons.play_arrow, size: 16),
            label: Text(_isLive ? "Matikan Live" : "Mulai Live", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isLive ? alertRed : softTeal,
              foregroundColor: _isLive ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: neonCyan,
      unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
      indicatorColor: neonCyan,
      tabs: const [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 16),
              SizedBox(width: 4),
              Text("Live Chat", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 16),
              SizedBox(width: 4),
              Text("Sematkan Produk", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView(List<Product> products) {
    return TabBarView(
      controller: _tabController,
      children: [
        _isLive ? _buildLiveChatTab() : _buildVideoSettingsTab(),
        _buildPinProductTab(products),
      ],
    );
  }
  
  Widget _buildVideoSettingsTab() {
      return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Card(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2), width: 0.5)
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                          const Row(
                                              children: [
                                                  Icon(Icons.play_circle_outline, color: neonCyan, size: 20),
                                                  SizedBox(width: 8),
                                                  Text("Putar Video Demo Otomatis", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                              ]
                                          ),
                                          Switch(
                                              value: _useAutoPlayVideo,
                                              onChanged: (val) => setState(() => _useAutoPlayVideo = val),
                                              activeColor: neonCyan,
                                          )
                                      ]
                                  ),
                                  Text(
                                    "Saat siaran dimulai, sistem akan memutar video promo/demonstrasi produk secara otomatis.",
                                    style: TextStyle(fontSize: 11.0, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8)),
                                  )
                              ]
                          )
                      )
                  ),
                  if(_useAutoPlayVideo) ...[
                      const SizedBox(height: 12),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text("PILIH SUMBER VIDEO SIMULASI:", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey))
                      ),
                      const SizedBox(height: 8),
                      _buildVideoPresetButtons(),
                      const SizedBox(height: 8),
                      _buildCustomUrlField(),
                      const SizedBox(height: 8),
                      _buildActiveSourceInfo()
                  ] else
                    Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                            "Simulasi kamera radar aktif. Klik 'Mulai Live' di atas untuk memulai siaran langsung.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7)),
                        ),
                    )
              ]
          )
      );
  }

  Widget _buildVideoPresetButtons() {
    final presets = [
      {"name": "Fashion Promo", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", "icon": Icons.shopping_bag},
      {"name": "Tech Showcase", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4", "icon": Icons.laptop_chromebook},
      {"name": "Food & Drink", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4", "icon": Icons.restaurant},
    ];
    return Row(
      children: presets.map((p) => Expanded(child: _buildPresetCard(p["name"] as String, p["url"] as String, p["icon"] as IconData))).toList(),
    );
  }

  Widget _buildPresetCard(String name, String url, IconData icon) {
    final isSelected = _selectedVideoUrl == url;
    return Card(
      color: isSelected ? neonCyan.withOpacity(0.15) : Theme.of(context).colorScheme.surface.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: isSelected ? neonCyan : Theme.of(context).colorScheme.outline.withOpacity(0.15), width: 1.0)
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedVideoUrl = url;
            _customVideoUrlController.clear();
            _initializeVideo(url);
          });
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(icon, size: 24, color: isSelected ? neonCyan : Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 6),
              Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? neonCyan : Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomUrlField() {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: _customVideoUrlController,
        onChanged: (val) {
          if (val.isNotEmpty && Uri.tryParse(val)?.hasAbsolutePath == true) {
            setState(() {
              _selectedVideoUrl = val;
              _initializeVideo(val);
            });
          }
        },
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: "URL Video Kustom (MP4)",
          labelStyle: const TextStyle(fontSize: 12),
          prefixIcon: Icon(Icons.link, color: Theme.of(context).colorScheme.onSurfaceVariant),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.3))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: neonCyan)),
        ),
      ),
    );
  }

  Widget _buildActiveSourceInfo() {
      return Card(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  children: [
                      const Icon(Icons.info_outline, color: softTeal, size: 14),
                      const SizedBox(width: 6.0),
                      Expanded(
                          child: Text(
                              "Sumber aktif: ${_selectedVideoUrl.substringAfterLast('/')}",
                              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                          ),
                      )
                  ]
              )
          )
      );
  }

  Widget _buildLiveChatTab() {
    return Column(
      children: [
        // Chat messages
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            itemCount: _chatMessages.length,
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            itemBuilder: (context, index) {
              final msg = _chatMessages[index];
              return Align(
                alignment: msg.isSeller ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: msg.isSeller ? neonCyan.withOpacity(0.12)
                          : msg.isSystem ? Theme.of(context).colorScheme.surfaceVariant
                          : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                    border: msg.isSeller ? Border.all(color: neonCyan.withOpacity(0.4), width: 0.5) : null,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface),
                      children: [
                        TextSpan(
                          text: msg.isSeller ? "Penjual 👑: " : "${msg.sender}: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: msg.isSeller ? neonCyan
                                  : msg.isSystem ? softTeal
                                  : vividOrchid,
                          ),
                        ),
                        TextSpan(text: msg.message),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Quick Replies
        _buildQuickReplies(),
        const SizedBox(height: 4),
        // Message Input
        _buildMessageInput(),
      ],
    );
  }
  
  Widget _buildQuickReplies() {
      final replies = ["Ready Kak! Silakan di-co", "Bisa COD seluruh wilayah!", "Lagi ada diskon 10% ya", "Kualitas dijamin original!"];
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: replies.map((text) => GestureDetector(
                  onTap: () {
                      setState(() {
                          _chatMessages.add(LiveChatMessage(sender: "Penjual", message: text, isSeller: true));
                          _scrollToBottom();
                      });
                  },
                  child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3), width: 0.5)
                      ),
                      child: Text(text, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant))
                  )
              )).toList()
          )
      );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: TextField(
                controller: _sellerMessageController,
                style: const TextStyle(fontSize: 11),
                decoration: InputDecoration(
                  hintText: "Tulis balasan chat...",
                  hintStyle: const TextStyle(fontSize: 11),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: neonCyan),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              style: IconButton.styleFrom(
                  backgroundColor: neonCyan
              ),
              icon: const Icon(Icons.send, size: 16, color: Colors.black),
              onPressed: () {
                if (_sellerMessageController.text.trim().isNotEmpty) {
                  setState(() {
                    _chatMessages.add(LiveChatMessage(
                      sender: "Penjual",
                      message: _sellerMessageController.text.trim(),
                      isSeller: true,
                    ));
                    _sellerMessageController.clear();
                    _scrollToBottom();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinProductTab(List<Product> products) {
    if (products.isEmpty) {
      return const Center(
        child: Text("Tidak ada barang di stok untuk ditawarkan.", style: TextStyle(fontSize: 12)),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6, top: 8),
            child: Text(
              "Ketuk 'Sematkan' untuk menampilkan widget harga produk di layar siaran pembeli.",
              style: TextStyle(fontSize: 11.0, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8)),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final prod = products[index];
              final isPinned = _pinnedProductIndex == index;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 3.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isPinned ? neonCyan : Colors.transparent,
                    width: 0.5
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(prod.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text(formatRupiah(prod.sellingPrice), style: const TextStyle(fontSize: 11, color: softTeal, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Text("Stok: ${prod.stock}", style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 28,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _pinnedProductIndex = isPinned ? -1 : index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPinned ? neonCyan : Theme.of(context).colorScheme.surfaceVariant,
                          foregroundColor: isPinned ? Colors.black : Theme.of(context).colorScheme.onSurfaceVariant,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Text(isPinned ? "Tersemat" : "Sematkan", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Extension to mimic Kotlin's substringAfterLast
extension StringExtension on String {
    String substringAfterLast(String delimiter) {
        final index = lastIndexOf(delimiter);
        if (index == -1) {
            return this;
        }
        return substring(index + delimiter.length);
    }
}
