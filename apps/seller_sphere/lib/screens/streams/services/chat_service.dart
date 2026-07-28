import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String streamId, ChatMessage message) async {
    await _firestore
        .collection('streams')
        .doc(streamId)
        .collection('chat')
        .add(message.toFirestore());
  }

  Stream<QuerySnapshot> getChatStream(String streamId) {
    return _firestore.collection('streams').doc(streamId).collection('chat').snapshots();
  }
}