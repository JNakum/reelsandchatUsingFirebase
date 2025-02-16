import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _receiverName;
  String? get receiverName => _receiverName;

  // Setter Method
  void setReceiverName(String name) {
    _receiverName = name;
    notifyListeners(); // UI Update
  }

  Future<String> createChatRoom(String currentUser, String otherUser) async {
    // Dono usernames ko alphabetically sort karke unique chatroom ID banao
    List<String> sortedUsernames = [currentUser, otherUser]..sort();
    String chatRoomId = "${sortedUsernames[0]}_${sortedUsernames[1]}";

    DocumentReference chatRoomRef =
        _firestore.collection('chatrooms').doc(chatRoomId);

    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();

    if (!chatRoomSnapshot.exists) {
      // Agar chatroom exist nahi karta, to naya create karo
      await chatRoomRef.set({
        'chatRoomId': chatRoomId,
        'users': [currentUser, otherUser],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }
}
