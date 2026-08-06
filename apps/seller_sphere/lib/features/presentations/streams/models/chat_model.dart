import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toFirestore() => {
        'senderId': senderId,
        'senderName': senderName,
        'message': message,
        'timestamp': Timestamp.fromDate(timestamp),
      };

  factory ChatMessage.fromFirestore(Map<String, dynamic> map) => ChatMessage(
        senderId: map['senderId'] ?? '',
        senderName: map['senderName'] ?? '',
        message: map['message'] ?? '',
        timestamp: (map['timestamp'] as Timestamp).toDate(),
      );
}