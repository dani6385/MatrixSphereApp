import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Untuk format waktu
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

// --- Model Data ---

// --- Halaman Streaming ---
class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isStreaming = false;
  bool _isFrontCamera = true; // Default ke kamera depan
  bool _isMicMuted = false;

  final TextEditingController _chatInputController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  // Placeholder untuk user ID dan stream ID
  final String _currentUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';
  final String _currentUserName = 'Pengguna ${DateTime.now().second}';
  final String _streamId =
      'myLiveStream123'; // ID unik untuk setiap sesi streaming

  // Contoh data produk
  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'T-Shirt Keren',
      imageUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?text=T-Shirt',
      price: 125000,
      stock: 0,
      purchasePrice: 0,
      sellingPrice: 0,
      minStockThreshold: 0,
      ageRating: 0,
      imageUrls: [],
    ),
    Product(
      id: 'p2',
      name: 'Celana Jeans',
      imageUrl: 'https://via.placeholder.com/150/0000FF/FFFFFF?text=Jeans',
      price: 250000,
      stock: 0,
      purchasePrice: 0,
      sellingPrice: 0,
      minStockThreshold: 0,
      ageRating: 0,
      imageUrls: [],
    ),
    Product(
      id: 'p3',
      name: 'Topi Gaul',
      imageUrl: 'https://via.placeholder.com/150/00FF00/FFFFFF?text=Topi',
      price: 75000,
      stock: 0,
      purchasePrice: 0,
      sellingPrice: 0,
      minStockThreshold: 0,
      ageRating: 0,
      imageUrls: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _chatInputController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        _showErrorSnackBar('Tidak ada kamera yang ditemukan.');
        return;
      }

      CameraDescription selectedCamera = _isFrontCamera
          ? _cameras!.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras!.first,
            )
          : _cameras!.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras!.first,
            );

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } on CameraException catch (e) {
      _showErrorSnackBar('Gagal menginisialisasi kamera: ${e.description}');
    }
  }

  Future<void> _toggleCameraLens() async {
    if (_cameras == null || _cameras!.length < 2) return;

    _isFrontCamera = !_isFrontCamera;
    await _cameraController?.dispose();
    setState(() {
      _isCameraInitialized = false;
    });
    await _initializeCamera();
  }

  void _toggleMicMute() {
    setState(() {
      _isMicMuted = !_isMicMuted;
      // Di sini Anda akan mengintegrasikan logika mute/unmute mikrofon dari SDK streaming Anda
      // Contoh: _streamingSdk.muteMicrophone(_isMicMuted);
    });
    _showInfoSnackBar('Mikrofon ${!_isMicMuted ? 'diaktifkan' : 'dimatikan'}');
  }

  void _toggleStreaming() {
    setState(() {
      _isStreaming = !_isStreaming;
    });

    if (_isStreaming) {
      _showInfoSnackBar('Memulai streaming...');
      // TODO: Di sini Anda akan memanggil metode dari SDK streaming Anda
      // Contoh: _streamingSdk.startStream(streamId: _streamId, cameraController: _cameraController);
    } else {
      _showInfoSnackBar('Menghentikan streaming...');
      // TODO: Di sini Anda akan memanggil metode dari SDK streaming Anda
      // Contoh: _streamingSdk.stopStream();
    }
  }

  void _sendMessage() async {
    if (_chatInputController.text.trim().isEmpty) return;

    final message = ChatMessage(
      senderId: _currentUserId,
      senderName: _currentUserName,
      message: _chatInputController.text.trim(),
      timestamp: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('streams')
          .doc(_streamId)
          .collection('chat')
          .add(message.toFirestore());
      _chatInputController.clear();
      _scrollToBottom();
    } catch (e) {
      _showErrorSnackBar('Gagal mengirim pesan: $e');
    }
  }

  void _scrollToBottom() {
    if (_chatScrollController.hasClients) {
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: kAlertRed),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: kBrandPrimary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- Video Preview Kamera ---
          _isCameraInitialized
              ? Positioned.fill(
                  child: CameraPreview(_cameraController!),
                )
              : Container(
                  color: kLightTextPrimary,
                  child: const Center(
                    child: CircularProgressIndicator(color: kLightBackground),
                  ),
                ),

          // --- Overlay: Status Streaming & Kontrol ---
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status LIVE
                if (_isStreaming)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kAlertRed,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                          color: kLightBackground, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Placeholder untuk jumlah penonton
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kLightTextPrimary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.visibility, color: kLightBackground, size: 16),
                      SizedBox(width: 4),
                      Text('123', style: TextStyle(color: kLightBackground)),
                    ],
                  ),
                ),
                // Tombol Kontrol
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isMicMuted ? Icons.mic_off : Icons.mic,
                        color: kLightBackground,
                      ),
                      onPressed: _toggleMicMute,
                    ),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios,
                          color: kLightBackground),
                      onPressed: _toggleCameraLens,
                    ),
                    ElevatedButton.icon(
                      onPressed: _toggleStreaming,
                      icon: Icon(_isStreaming ? Icons.stop : Icons.play_arrow),
                      label: Text(_isStreaming ? 'Stop' : 'Go Live'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isStreaming ? kAlertRed : kSoftTeal,
                        foregroundColor: kLightBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Overlay: Daftar Produk ---
          Positioned(
            bottom: 100, // Di atas chat input
            left: 10,
            child: SizedBox(
              width: 120, // Lebar daftar produk
              height: 200, // Tinggi daftar produk
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ),

          // --- Overlay: Live Chat ---
          Positioned(
            bottom: 100, // Di atas chat input
            right: 10,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6, // Lebar chat
              height: 250, // Tinggi chat
              decoration: BoxDecoration(
                color: kLightTextPrimary.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('streams')
                          .doc(_streamId)
                          .collection('chat')
                          .orderBy('timestamp', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}',
                                  style: const TextStyle(color: kLightBackground)));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: kLightBackground));
                        }

                        final messages = snapshot.data!.docs
                            .map((doc) => ChatMessage.fromFirestore(
                                doc.data() as Map<String, dynamic>))
                            .toList();

                        // Scroll ke bawah setiap kali ada pesan baru
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => _scrollToBottom());

                        return ListView.builder(
                          controller: _chatScrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${message.senderName}: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            message.senderId == _currentUserId
                                                ? Colors.lightBlueAccent
                                                : kLightBackground,
                                      ),
                                    ),
                                    TextSpan(
                                      text: message.message,
                                      style:
                                          const TextStyle(color: kLightBackground),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Chat Input ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 8,
                left: 8,
                right: 8,
                top: 8,
              ),
              color: kLightTextPrimary.withValues(alpha: 0.7),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatInputController,
                      style: const TextStyle(color: kLightBackground),
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        hintStyle:
                            TextStyle(color: kLightBackground.withValues(alpha: 0.7)),
                        filled: true,
                        fillColor: kLightBackground.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: kLightBackground),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Widget Kartu Produk ---
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Aksi ketika produk diklik, misalnya tampilkan detail atau tambahkan ke keranjang
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk ${product.name} diklik!')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: kLightBackground.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: kLightTextPrimary.withValues(alpha: 0.2),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                product.imageUrl ?? '',
                height: 60,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 60,
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, color: kLightBackground),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: kLightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
                        .format(product.price),
                    style: const TextStyle(
                      fontSize: 10,
                      color: kLightBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
