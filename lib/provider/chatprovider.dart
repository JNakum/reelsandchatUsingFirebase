import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _receiverName;
  String? get receiverName => _receiverName;

  void setReceiverName(String name) {
    _receiverName = name;
    notifyListeners(); // UI Update
  }

  Future<String> createChatRoom(String userId1, String userId2) async {
    String chatRoomId = _generateChatRoomId(userId1, userId2);

    QuerySnapshot chatRoomSnapshot = await _firestore
        .collection('chatRooms')
        .where("chatRoomId", isEqualTo: chatRoomId)
        .get();

    if (chatRoomSnapshot.docs.isEmpty) {
      await _firestore.collection('chatRooms').doc(chatRoomId).set({
        'chatRoomId': chatRoomId,
        'users': [userId1, userId2],
        'lastMessage': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  String _generateChatRoomId(String userId1, String userId2) {
    List<String> userIds = [userId1, userId2];
    userIds.sort();
    return userIds.join('_');
  }

  Future<void> sendMessage(String chatRoomId, String message) async {
    if (message.isNotEmpty) {
      var user = FirebaseAuth.instance.currentUser;
      await _firestore
          .collection("chatRooms")
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'senderId': user!.uid,
        'messageText': message,
        'sendBy': user.displayName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': message,
        'sendBy': user.displayName,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
