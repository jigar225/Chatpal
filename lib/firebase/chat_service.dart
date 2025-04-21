import 'package:chatbot/helper/chatmeesage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createNewChat({
    required String senderId,
    required String initialMessage,
    required String userId,
    String? fileUrl, // New optional parameter for image/file URL
  }) async {
    final chatDoc = await _firestore.collection('chats').add({
      'createdAt': FieldValue.serverTimestamp(),
      'userId': userId,
    });

    await chatDoc.collection('messages').add({
      'senderId': senderId,
      'text': initialMessage,
      'fileUrl': fileUrl, // Storing URL if exists
      'timestamp': FieldValue.serverTimestamp(),
    });

    return chatDoc.id;
  }

  Future<void> addMessageToChat({
    required String chatId,
    required String senderId,
    required String message,
    String? fileUrl, // New optional parameter for image/file URL
  }) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'text': message,
      'fileUrl': fileUrl, // Storing URL if exists
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatHistory(String userId) {
    return _firestore
        .collection('chats')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  Stream<List<Chatmeesage>> getFormattedMessages(String chatId) {
  return getChatMessages(chatId).map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Chatmeesage(
        text: data['text'] ?? "",
        isUser: data['senderId'] == 'user',
        timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
        fileUrl: data['fileUrl'],
      );
    }).toList();
  });
}

}
