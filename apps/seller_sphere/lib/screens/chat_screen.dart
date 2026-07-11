import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// --- DATA MODELS ---
// Assuming these view models and data classes exist and are structured similarly.
// These would typically be in their own files.

class AppViewModel extends ChangeNotifier {
  List<Product> products = [];
  List<Product> lowStockProducts = [];
  List<Transaction> transactions = [];
  String customStoreName = "My Store";
  TodayTarget? todayTarget;
  List<BuyerChat> buyerChats = [];
  String? activeChatBuyerName;

  void markChatAsRead(String customerName) {
    // Implementation needed
  }

  void sendMessageToBuyer(String customerName, String text) {
    // Implementation needed
  }

  // Dummy data for example
  AppViewModel() {
    customStoreName = "Toko Kelontong";
  }

  bool get isDarkTheme => null;

  get notificationStream => null;

  String? get rtdbUrl => null;

  void toggleDarkTheme() {}

  void updateCustomStoreName(String text) {}

  void updateRtdbUrl(String text) {}
}

class Product {
  final String name;
  final int stock;
  final int minStockThreshold;
  final double sellingPrice;

  Product({required this.name, required this.stock, required this.minStockThreshold, required this.sellingPrice});
}

class Transaction {
  final double totalAmount;
  final double totalProfit;

  Transaction({required this.totalAmount, required this.totalProfit});
}

class TodayTarget {
  final double targetAmount;
  TodayTarget({required this.targetAmount});
}

class BuyerChat {
  final String customerName;
  final int unreadCount;
  final int lastMessageTimestamp;
  final List<BuyerMessage> messages;

  BuyerChat({required this.customerName, required this.unreadCount, required this.lastMessageTimestamp, required this.messages});
}

class BuyerMessage {
  final String id;
  final String text;
  final bool isFromBuyer;
  final int timestamp;

  BuyerMessage({required this.id, required this.text, required this.isFromBuyer, required this.timestamp});
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final int timestamp;

  ChatMessage({
    this.id = '',
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// --- END OF DUMMY DATA ---


// --- UI CONSTANTS ---
const Color neonCyan = Color(0xFF00FFFF);
const Color softTeal = Color(0xFF48A0A6);
const Color warmOrange = Color(0xFFFF8C00);


// --- THE CHAT SCREEN WIDGET ---
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required void Function() onNavigateBack});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _aiInputController;
  late final TextEditingController _buyerInputController;
  final ScrollController _aiScrollController = ScrollController();
  final ScrollController _buyerScrollController = ScrollController();

  final List<ChatMessage> _aiMessages = [];
  bool _isAiLoading = false;
  
  @override
  void initState() {
    super.initState();
    _aiInputController = TextEditingController();
    _buyerInputController = TextEditingController();
    // Initialize AI chat history
  }

  @override
  void dispose() {
    _aiInputController.dispose();
    _buyerInputController.dispose();
    _aiScrollController.dispose();
    _buyerScrollController.dispose();
    super.dispose();
  }
  
  // --- HELPER METHODS (Converted from Kotlin) ---

  String _formatNumber(double number) {
    final format = NumberFormat.getNumberInstance(const Locale('in', 'ID'));
    return format.format(number);
  }

  String _formatTime(int timestamp) {
    final sdf = DateFormat("HH:mm", 'id_ID');
    return sdf.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }
  
  String _formatTimeAndDate(int timestamp) {
    final sdf = DateFormat("dd/MM HH:mm", 'id_ID');
    return sdf.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }
  
  String _getStoreContext(AppViewModel viewModel) {
    final lowStockNames = viewModel.lowStockProducts.map((p) => "${p.name} (Sisa ${p.stock} unit, batasan minimum ${p.minStockThreshold})").join(", ");
    final allProductsSummary = viewModel.products.map((p) => "- ${p.name}: ${p.stock} Unit - Harga Jual: Rp ${_formatNumber(p.sellingPrice)}").join("\n");
    final targetText = viewModel.todayTarget != null ? "Target Penjualan Hari Ini: Rp ${_formatNumber(viewModel.todayTarget!.targetAmount)}" : "Belum ada target penjualan hari ini.";

    return """
        Nama Toko: ${viewModel.customStoreName}
        $targetText
        Jumlah Produk Terdaftar: ${viewModel.products.length}
        Produk Hampir Habis: ${viewModel.lowStockProducts.isEmpty ? "Tidak ada" : lowStockNames}
        Rincian Inventaris:
        $allProductsSummary
    """;
  }

  String _generateSmartFallback(String query, AppViewModel viewModel) {
    final q = query.toLowerCase();
    if (q.contains("stok") || q.contains("habis") || q.contains("kurang") || q.contains("restock")) {
      if (viewModel.lowStockProducts.isEmpty) {
        return "Luar biasa! Saat ini tidak ada produk di toko **${viewModel.customStoreName}** yang berada di bawah batas minimum stok. Semua stok barang Anda aman dan mencukupi.";
      } else {
        var listBuilder = StringBuffer();
        listBuilder.writeln("Saat ini terdapat **${viewModel.lowStockProducts.length} produk** yang hampir habis:\n");
        for (var prod in viewModel.lowStockProducts) {
          listBuilder.writeln("🔴 **${prod.name}**");
          listBuilder.writeln("   • Sisa Stok: **${prod.stock} Unit**");
          listBuilder.writeln("   • Batas Min: ${prod.minStockThreshold} Unit\n");
        }
        listBuilder.write("💡 **Saran:** Segera hubungi pemasok Anda untuk melakukan pemesanan ulang.");
        return listBuilder.toString();
      }
    } else if (q.contains("penjualan") || q.contains("transaksi") || q.contains("omset") || q.contains("untung")) {
      final totalRevenue = viewModel.transactions.fold<double>(0, (sum, item) => sum + item.totalAmount);
      final totalProfit = viewModel.transactions.fold<double>(0, (sum, item) => sum + item.totalProfit);
      final targetText = viewModel.todayTarget != null ? "Target penjualan hari ini adalah **Rp ${_formatNumber(viewModel.todayTarget!.targetAmount)}**." : "Anda belum menetapkan target nominal penjualan untuk hari ini.";

      return """
          Berikut adalah ringkasan kinerja toko **${viewModel.customStoreName}**:
          
          📊 **Statistik Penjualan:**
          • Total Transaksi: **${viewModel.transactions.length} transaksi**
          • Estimasi Pendapatan: **Rp ${_formatNumber(totalRevenue)}**
          • Estimasi Keuntungan: **Rp ${_formatNumber(totalProfit)}**
          
          🎯 **Status Target:**
          • $targetText
      """;
    } else {
      return """
          Asisten mengonfirmasi status toko **${viewModel.customStoreName}** dalam kondisi prima:
          • Jumlah produk aktif: **${viewModel.products.length} barang**
          • Produk perlu restok: **${viewModel.lowStockProducts.length} barang**
          • Total transaksi tercatat: **${viewModel.transactions.length} penjualan**
      """;
    }
  }

  Future<void> _callGeminiApi(String prompt, AppViewModel viewModel) async {
    setState(() {
      _isAiLoading = true;
    });

    // NOTE: Replace with your actual API key retrieval mechanism
    const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'MY_GEMINI_API_KEY');

    if (apiKey.isEmpty || apiKey == 'MY_GEMINI_API_KEY') {
      final responseText = _generateSmartFallback(prompt, viewModel);
      _onAiResult(responseText);
      return;
    }

    String responseText;
    try {
      final systemInstruction = {
        "parts": [
          {
            "text": """
              You are "Seller Sphere AI Assistant", a smart personal retail manager for the merchant store.
              Respond warmly, politely, and highly professionally in Indonesian language.
              Use Markdown formatting for headings, bullet points, and bold text to make it extremely clean and readable.
              Here is the REAL-TIME context of the merchant's store inventory and transactions. 
              Answer questions strictly based on this data:
              
              ${_getStoreContext(viewModel)}
            """
          }
        ]
      };

      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ],
        "systemInstruction": systemInstruction,
      };

      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        responseText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      } else {
        responseText = _generateSmartFallback(prompt, viewModel);
      }
    } catch (e) {
      responseText = _generateSmartFallback(prompt, viewModel);
    }
    
    _onAiResult(responseText);
  }

  void _onAiResult(String responseText) {
    setState(() {
      _aiMessages.add(ChatMessage(text: responseText, isUser: false, timestamp: DateTime.now().millisecondsSinceEpoch));
      _isAiLoading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_aiScrollController.hasClients) {
          _aiScrollController.animateTo(
          _aiScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleAiSend() {
    if (_aiInputController.text.isNotEmpty && !_isAiLoading) {
      final prompt = _aiInputController.text.trim();
      _aiInputController.clear();
      FocusScope.of(context).unfocus();
      
      setState(() {
        _aiMessages.add(ChatMessage(text: prompt, isUser: true, timestamp: DateTime.now().millisecondsSinceEpoch));
      });

      final viewModel = Provider.of<AppViewModel>(context, listen: false);
      _callGeminiApi(prompt, viewModel);
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
         if (_aiScrollController.hasClients) {
            _aiScrollController.animateTo(
                _aiScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
            );
         }
      });
    }
  }

  void _handleBuyerSend(String buyerName) {
    if (_buyerInputController.text.isNotEmpty) {
        final text = _buyerInputController.text.trim();
        _buyerInputController.clear();
        FocusScope.of(context).unfocus();
        Provider.of<AppViewModel>(context, listen: false).sendMessageToBuyer(buyerName, text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final activeChatBuyerName = viewModel.activeChatBuyerName;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: neonCyan),
          onPressed: () {
            if (activeChatBuyerName != null) {
              context.read<AppViewModel>().activeChatBuyerName = null;
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: softTeal, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeChatBuyerName == null ? "Hub Obrolan Toko" : "Obrolan Pembeli",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  activeChatBuyerName == null ? "Asisten AI & Pesan Pelanggan" : "Sedang terhubung dengan $activeChatBuyerName",
                  style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
      body: activeChatBuyerName == null
          ? _buildHubView(context, viewModel)
          : _buildActiveChatView(context, viewModel, activeChatBuyerName),
    );
  }

  Widget _buildHubView(BuildContext context, AppViewModel viewModel) {
    // Sorting chats: Priority to unread, then reverse chronological order
    final sortedChats = List<BuyerChat>.from(viewModel.buyerChats);
    sortedChats.sort((a, b) {
      if (a.unreadCount > 0 && b.unreadCount == 0) return -1;
      if (b.unreadCount > 0 && a.unreadCount == 0) return 1;
      return b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp);
    });
    
    final totalUnread = viewModel.buyerChats.fold<int>(0, (sum, chat) => sum + chat.unreadCount);

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _buildAiAssistantCard(context, viewModel),
        _buildBuyerMessagesHeader(context, totalUnread),
        _buildBuyerChatList(context, sortedChats),
      ],
    );
  }

  Widget _buildAiAssistantCard(BuildContext context, AppViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: neonCyan.withValues(alpha: 0.25)),
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            _buildAiHeader(context),
            const SizedBox(height: 12),
            _buildAiMessageHistory(context),
            const SizedBox(height: 8),
            _buildQuickActionChips(context, viewModel),
            const SizedBox(height: 10),
            _buildAiInputRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAiHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: neonCyan.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.smart_toy_outlined, color: neonCyan, size: 20),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Asisten AI Pintar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "Tanya stok, omset, & saran penjualan",
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: softTeal.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "ONLINE",
            style: TextStyle(color: softTeal, fontWeight: FontWeight.bold, fontSize: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildAiMessageHistory(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: ListView.builder(
        controller: _aiScrollController,
        itemCount: _aiMessages.length + (_isAiLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (_isAiLoading && index == _aiMessages.length) {
            return const _LoadingBubble();
          }
          final msg = _aiMessages[index];
          return _AiChatBubble(message: msg);
        },
      ),
    );
  }

  Widget _buildQuickActionChips(BuildContext context, AppViewModel viewModel) {
    final suggestions = ["⚠️ Stok Habis", "📊 Omset & Untung", "❓ Panduan Fitur"];
    return Row(
      children: suggestions.map((label) {
        return Expanded(
          child: InkWell(
            onTap: _isAiLoading ? null : () {
              final prompt = switch (label) {
                "⚠️ Stok Habis" => "Apakah ada produk saya yang stoknya mau habis? Berikan analisa.",
                "📊 Omset & Untung" => "Berapa omset dan perkiraan laba toko saya?",
                _ => "Bagaimana cara menggunakan asisten ini?",
              };
               _aiInputController.text = prompt;
               _handleAiSend();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: neonCyan),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAiInputRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: TextField(
              controller: _aiInputController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleAiSend(),
              decoration: InputDecoration(
                hintText: "Ketik pesan untuk AI...",
                hintStyle: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: neonCyan),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: _handleAiSend,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _aiInputController.text.isNotEmpty && !_isAiLoading
                  ? neonCyan
                  : Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.send,
              size: 16,
              color: _aiInputController.text.isNotEmpty && !_isAiLoading
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuyerMessagesHeader(BuildContext context, int totalUnread) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.chat_bubble_outline, color: softTeal, size: 18),
              SizedBox(width: 8),
              Text(
                "Pesan Masuk Pembeli",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (totalUnread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$totalUnread Belum Dibaca",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBuyerChatList(BuildContext context, List<BuyerChat> sortedChats) {
    if (sortedChats.isEmpty) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 40,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 6),
              Text("Tidak ada pesan dari pembeli", style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
            ],
          ),
        ),
      );
    }
    return Column(
      children: sortedChats.map((chat) => _buildBuyerChatItem(context, chat)).toList(),
    );
  }

  Widget _buildBuyerChatItem(BuildContext context, BuyerChat buyerChat) {
    final lastMsg = buyerChat.messages.isNotEmpty ? buyerChat.messages.last.text : "Tidak ada pesan";
    final hasUnread = buyerChat.unreadCount > 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: hasUnread ? neonCyan.withValues(alpha: 0.3) : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      color: hasUnread ? neonCyan.withValues(alpha: 0.04) : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      child: InkWell(
        onTap: () {
          context.read<AppViewModel>().activeChatBuyerName = buyerChat.customerName;
          context.read<AppViewModel>().markChatAsRead(buyerChat.customerName);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: hasUnread ? neonCyan : softTeal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  buyerChat.customerName.length >= 2 ? buyerChat.customerName.substring(0, 2).toUpperCase() : "NA",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: hasUnread ? Colors.black : Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          buyerChat.customerName,
                          style: TextStyle(
                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _formatTimeAndDate(buyerChat.lastMessageTimestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: hasUnread ? neonCyan : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(
                           child: Text(
                            lastMsg,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: hasUnread
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                                                   ),
                         ),
                          if (hasUnread)
                           Padding(
                             padding: const EdgeInsets.only(left: 8.0),
                             child: CircleAvatar(
                               radius: 10,
                               backgroundColor: Colors.red,
                               child: Text(
                                 buyerChat.unreadCount.toString(),
                                 style: const TextStyle(
                                   color: Colors.white,
                                   fontWeight: FontWeight.bold,
                                   fontSize: 11,
                                 ),
                               ),
                             ),
                           ),
                       ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveChatView(BuildContext context, AppViewModel viewModel, String currentBuyerName) {
    final currentChat = viewModel.buyerChats.firstWhere(
        (chat) => chat.customerName.toLowerCase() == currentBuyerName.toLowerCase(),
        orElse: () => BuyerChat(customerName: currentBuyerName, unreadCount: 0, lastMessageTimestamp: 0, messages: []));
    final currentMessages = currentChat.messages;
    
    // Mark as read and scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.markChatAsRead(currentBuyerName);
      if (_buyerScrollController.hasClients) {
        _buyerScrollController.jumpTo(_buyerScrollController.position.maxScrollExtent);
      }
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _buyerScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: currentMessages.length,
            itemBuilder: (context, index) {
              return _BuyerChatBubble(message: currentMessages[index]);
            },
          ),
        ),
        _buildBuyerInputPanel(context, currentBuyerName),
      ],
    );
  }

  Widget _buildBuyerInputPanel(BuildContext context, String currentBuyerName) {
    return Material(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _buyerInputController,
                maxLines: 3,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleBuyerSend(currentBuyerName),
                decoration: InputDecoration(
                  hintText: "Ketik balasan untuk $currentBuyerName...",
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: neonCyan),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _handleBuyerSend(currentBuyerName),
              borderRadius: BorderRadius.circular(24),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: _buyerInputController.text.isNotEmpty ? neonCyan : Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.send,
                  size: 20,
                  color: _buyerInputController.text.isNotEmpty ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CUSTOM CHAT BUBBLE WIDGETS ---

class _AiChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _AiChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;
    final bubbleColor = isUser ? neonCyan : theme.colorScheme.surfaceContainerHighest;
    final contentColor = isUser ? Colors.white : theme.colorScheme.onSurface;
    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: contentColor, fontSize: 12, height: 1.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(message.timestamp)),
            style: TextStyle(fontSize: 8, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          ),
        ),
      ],
    );
  }
}

class _BuyerChatBubble extends StatelessWidget {
  final BuyerMessage message;

  const _BuyerChatBubble({required this.message});
  
  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
      final isFromBuyer = message.isFromBuyer;
      final bubbleColor = !isFromBuyer ? neonCyan : theme.colorScheme.surfaceContainerHighest;
      final contentColor = !isFromBuyer ? Colors.white : theme.colorScheme.onSurface;
      final alignment = !isFromBuyer ? CrossAxisAlignment.end : CrossAxisAlignment.start;

      return Column(
          crossAxisAlignment: alignment,
          children: [
              Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      if (isFromBuyer)
                          Padding(
                              padding: const EdgeInsets.only(right: 8.0, top: 4.0),
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: softTeal.withValues(alpha: 0.15),
                                  child: const Icon(Icons.person, size: 16, color: softTeal),
                              ),
                          ),
                      Flexible(
                        child: Container(
                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                           margin: const EdgeInsets.symmetric(vertical: 2),
                           padding: const EdgeInsets.all(12),
                           decoration: BoxDecoration(
                               color: bubbleColor,
                               borderRadius: BorderRadius.circular(16),
                           ),
                           child: Text(
                               message.text,
                               style: TextStyle(color: contentColor, fontSize: 13, height: 1.4),
                           ),
                                              ),
                      ),
                  ],
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: isFromBuyer ? 44 : 0,
                      right: !isFromBuyer ? 4 : 0,
                      top: 2
                  ),
                  child: Text(
                      DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(message.timestamp)),
                      style: TextStyle(fontSize: 9, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                  ),
              )
          ],
      );
  }
}

class _LoadingBubble extends StatelessWidget {
  const _LoadingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1.5, color: neonCyan),
          ),
          const SizedBox(width: 6),
          Text(
            "AI sedang mengetik...",
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
