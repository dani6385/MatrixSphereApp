import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';
import 'package:seller_sphere/utils/formatting.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class OrderPickupItem extends StatelessWidget {
  final ShopsphereOrder order;
  final void Function(String) onNavigateToChat;
  
  const OrderPickupItem({super.key, required this.order, required this.onNavigateToChat, required AppViewModel viewModel});
  
  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _OrderVerificationDialog(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AppViewModel>();
    final isPickedUp = order.status == "Selesai Diambil";
    
    return Card(
      color: isPickedUp
          ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isPickedUp ? null : Theme.of(context).primaryColor,
                        ),
                      ),
                      Row(
                        children: [
                          Text("Pembeli: ${order.customerName}", style: const TextStyle(fontSize: 11)),
                          SizedBox(
                             width: 28, height: 28,
                             child: IconButton(
                               iconSize: 14,
                               onPressed: () {
                                 viewModel.activeChatBuyerName = order.customerName;
                                 onNavigateToChat(order.customerName);
                               },
                               icon: const Icon(Icons.chat, color: Color(0xFF00FFFF)),
                             ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                _StatusBadge(status: order.status),
              ],
            ),
             const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${order.productName} x${order.quantity}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                Text(formatRupiah(order.totalAmount), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
             const SizedBox(height: 6),
             Align(
                alignment: Alignment.centerLeft,
                child: Text("No. HP Pembeli: ${order.courierPhone}", style: const TextStyle(fontSize: 11))
             ),

            if (order.status == "Perlu Dipacking")
                _PackingInstruction(),
            
            if (order.status == "Siap Diambil")
                 _VerificationInfo(),

            if (!isPickedUp) ...[
                const SizedBox(height: 10),
                if (order.status == "Perlu Dipacking")
                    ElevatedButton(
                        onPressed: () => viewModel.finishPacking(order.id),
                        child: const Text("Barang Selesai, Silakan Ambil")
                    )
                else if (order.status == "Siap Diambil")
                     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           TextButton(onPressed: () => viewModel.callCourier(order.id), child: const Text("Hubungi Pembeli")),
                           TextButton(onPressed: () => viewModel.printOrderLabel(order.id), child: const Text("Cetak Nota")),
                           ElevatedButton(onPressed: () => _showVerificationDialog(context), child: const Text("Konfirmasi Diambil")),
                        ],
                     )
            ]
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == "Selesai Diambil" ? Color(0xFF4CAF50) : (status == "Siap Diambil" ? Color(0xFF00FFFF) : Color(0xFFFFA500));
    return Chip(
      label: Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      backgroundColor: color.withValues(alpha: 0.15),
      labelStyle: TextStyle(color: color),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}

class _PackingInstruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFA500).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning, color: Color(0xFFFFA500), size: 14),
            SizedBox(width: 8),
            Text("Silakan lakukan packing untuk pesanan ini.", style: TextStyle(color: Color(0xFFFFA500), fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _VerificationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 6.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 12),
          SizedBox(width: 4),
          Text("Verifikasi Barcode & PIN Aman Aktif", style: TextStyle(color: Color(0xFF4CAF50), fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _OrderVerificationDialog extends StatefulWidget {
    final ShopsphereOrder order;
    const _OrderVerificationDialog({required this.order});

  @override
  State<_OrderVerificationDialog> createState() => _OrderVerificationDialogState();
}

class _OrderVerificationDialogState extends State<_OrderVerificationDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _inputCode = '';
  String _errorMessage = '';
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1); // Default to camera
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _onVerifySuccess() {
      context.read<AppViewModel>().confirmOrderPickup(widget.order.id);
      Navigator.of(context).pop();
  }

  void _checkManualCode() {
      if (_inputCode == widget.order.verificationCode) {
          _onVerifySuccess();
      } else {
          setState(() {
              _errorMessage = "Kode verifikasi salah!";
          });
      }
  }

  void _simulateScan() {
      setState(() {
          _isScanning = true;
          _errorMessage = '';
      });
      Future.delayed(const Duration(milliseconds: 1800), () {
          setState(() {
              _isScanning = false;
              _inputCode = widget.order.verificationCode;
          });
      });
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Verifikasi Pengambilan"),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OrderInfoCard(order: widget.order),
            const SizedBox(height: 12),
            TabBar(
              controller: _tabController,
              tabs: const [
                 Tab(text: "Manual"),
                 Tab(text: "Kamera"),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildManualTab(),
                  _buildCameraTab(),
                ],
              ),
            ),
             if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 11)),
          ],
        ),
      ),
      actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Batal")),
          if (_tabController.index == 0)
            ElevatedButton(onPressed: _inputCode.length == 6 ? _checkManualCode : null, child: const Text("Konfirmasi")),
      ],
    );
  }
  
  Widget _buildManualTab() {
      return Column(
        children: [
            const Text("Ketik kode verifikasi 6-digit dari pembeli.", style: TextStyle(fontSize: 11)),
            const SizedBox(height: 12),
            if(_isScanning)
                const CircularProgressIndicator(),
            if(!_isScanning)
                TextField(
                    onChanged: (v) => setState(() => _inputCode = v),
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Kode Verifikasi",
                        hintText: widget.order.verificationCode,
                    ),
                ),
            const Spacer(),
            TextButton(onPressed: _simulateScan, child: const Text("Simulasi Scan Barcode")),
        ],
      );
  }
  
  Widget _buildCameraTab() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MobileScanner(
            onDetect: (capture) {
                final String? code = capture.barcodes.first.rawValue;
                if(code != null) {
                    if (code == widget.order.verificationCode) {
                      _onVerifySuccess();
                    } else {
                      setState(() {
                         _errorMessage = "Kode salah. Coba lagi.";
                      });
                    }
                }
            },
        ),
      );
  }
}

class _OrderInfoCard extends StatelessWidget {
    final ShopsphereOrder order;
    const _OrderInfoCard({required this.order});
    
    @override
    Widget build(BuildContext context) {
      return Card(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text("Pesanan: ${order.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Pelanggan: ${order.customerName}", style: const TextStyle(fontSize: 12)),
                    Text("Produk: ${order.productName} x${order.quantity}", style: const TextStyle(fontSize: 11)),
                ],
            ),
        ),
      );
    }
}
