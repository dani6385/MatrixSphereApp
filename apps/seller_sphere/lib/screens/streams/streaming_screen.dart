flutter create my_streaming_app
cd my_streaming_app
dependencies:
  flutter:
    sdk: flutter
  camera: ^0.10.5+9 # Pastikan versi terbaru
  firebase_core: ^2.24.2 # Pastikan versi terbaru
  cloud_firestore: ^4.13.6 # Pastikan versi terbaru
  intl: ^0.18.1 # Untuk format tanggal/waktu di chat
  image_picker: ^1.0.4 # Opsional, jika ingin memilih gambar produk dari galeri
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // HANYA UNTUK PENGEMBANGAN!
    }
  }
}
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<key>NSCameraUsageDescription</key>
<string>Aplikasi ini membutuhkan akses kamera untuk live streaming.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Aplikasi ini membutuhkan akses mikrofon untuk live streaming.</string>
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:my_streaming_app/streaming_page.dart'; // Import halaman streaming Anda

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Live Streaming',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StreamingPage(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Untuk format waktu

// --- Model Data ---
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}

class ChatMessage {
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromFirestore(Map<String, dynamic> data) {
    return ChatMessage(
      senderId: data['senderId'] ?? 'unknown',
      senderName: data['senderName'] ?? 'Anonim',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

// --- Halaman Streaming ---
class StreamingPage extends StatefulWidget {
  const StreamingPage({super.key});

  @override
  State<StreamingPage> createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
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
  final String _streamId = 'myLiveStream123'; // ID unik untuk setiap sesi streaming

  // Contoh data produk
  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'T-Shirt Keren',
      imageUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?text=T-Shirt',
      price: 125000,
    ),
    Product(
      id: 'p2',
      name: 'Celana Jeans',
      imageUrl: 'https://via.placeholder.com/150/0000FF/FFFFFF?text=Jeans',
      price: 250000,
    ),
    Product(
      id: 'p3',
      name: 'Topi Gaul',
      imageUrl: 'https://via.placeholder.com/150/00FF00/FFFFFF?text=Topi',
      price: 75000,
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
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.blue),
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
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Placeholder untuk jumlah penonton
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.visibility, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('123', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                // Tombol Kontrol
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isMicMuted ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                      ),
                      onPressed: _toggleMicMute,
                    ),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                      onPressed: _toggleCameraLens,
                    ),
                    ElevatedButton.icon(
                      onPressed: _toggleStreaming,
                      icon: Icon(_isStreaming ? Icons.stop : Icons.play_arrow),
                      label: Text(_isStreaming ? 'Stop' : 'Go Live'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isStreaming ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
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
                color: Colors.black.withOpacity(0.6),
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
                          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        }

                        final messages = snapshot.data!.docs
                            .map((doc) => ChatMessage.fromFirestore(doc.data() as Map<String, dynamic>))
                            .toList();

                        // Scroll ke bawah setiap kali ada pesan baru
                        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                        return ListView.builder(
                          controller: _chatScrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${message.senderName}: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: message.senderId == _currentUserId ? Colors.lightBlueAccent : Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: message.message,
                                      style: const TextStyle(color: Colors.white),
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
              color: Colors.black.withOpacity(0.7),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatInputController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
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
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                product.imageUrl,
                height: 60,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 60,
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, color: Colors.white),
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
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(product.price),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.green,
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

