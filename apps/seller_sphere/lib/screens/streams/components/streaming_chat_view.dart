import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../models/chat_model.dart';

class StreamingChatView extends StatelessWidget {
  final String streamId;
  final String currentUserId;
  final ScrollController scrollController;

  const StreamingChatView({
    super.key,
    required this.streamId,
    required this.currentUserId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      right: 10,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: 250,
        decoration: BoxDecoration(
          color: kLightTextPrimary.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('streams')
              .doc(streamId)
              .collection('chat')
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Center(child: Icon(Icons.error));
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: kLightBackground));
            }

            final messages = snapshot.data!.docs
                .map((doc) => ChatMessage.fromFirestore(
                    doc.data() as Map<String, dynamic>))
                .toList();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });

            return ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) => _buildChatItem(messages[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatItem(ChatMessage message) {
    final isMe = message.senderId == currentUserId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${message.senderName}: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe ? Colors.lightBlueAccent : kLightBackground,
              ),
            ),
            TextSpan(
              text: message.message,
              style: const TextStyle(color: kLightBackground),
            ),
          ],
        ),
      ),
    );
  }
}