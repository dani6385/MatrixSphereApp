import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../providers/help_center_provider.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final helpCenterProvider = Provider.of<HelpCenterProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pusat Bantuan')),
      body: helpCenterProvider.messages.isEmpty
          ? const Center(child: Text('Tidak ada pesan masuk.'))
          : ListView.builder(
              itemCount: helpCenterProvider.messages.length,
              itemBuilder: (context, index) {
                final message = helpCenterProvider.messages[index];
                return ListTile(
                  title: Text(message.sender),
                  subtitle: Text(message.message),
                  trailing: Text(
                    '${message.timestamp.hour}:${message.timestamp.minute}',
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMessageDialog(context, helpCenterProvider),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showMessageDialog(
    BuildContext context,
    HelpCenterProvider helpCenterProvider,
  ) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kirim Pesan ke Manager'),
          content: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              hintText: 'Tulis pesan Anda di sini',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (messageController.text.isNotEmpty) {
                  final message = Message(
                    sender: 'Seller',
                    message: messageController.text,
                    timestamp: DateTime.now(),
                  );
                  helpCenterProvider.addMessage(message);
                  Navigator.pop(context);
                }
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }
}
