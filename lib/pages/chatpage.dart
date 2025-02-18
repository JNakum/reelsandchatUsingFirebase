import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reels/provider/chatprovider.dart';

class Chatpage extends StatefulWidget {
  final String chatRoomId;
  const Chatpage({super.key, required this.chatRoomId});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xff703eff),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 5),
                  Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      return Text(
                        chatProvider.receiverName ?? "Unknown",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Chat Area
            Expanded(
              child: chatScreen(chatProvider),
            ),
          ],
        ),
      ),
    );
  }

  // Chat Screen
  Widget chatScreen(ChatProvider chatProvider) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      child: Column(
        children: [
          SizedBox(height: 50),

          // **Messages List**
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getMessages(widget.chatRoomId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;
                var currentUser = FirebaseAuth.instance.currentUser?.uid;

                return ListView.builder(
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    var senderId = message['senderId'];
                    var messageText = message['messageText'];

                    return Align(
                      alignment: senderId == currentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: senderId == currentUser
                              ? Colors.blue
                              : Colors.black45,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: senderId == currentUser
                                ? Radius.circular(30)
                                : Radius.circular(0),
                            bottomRight: senderId == currentUser
                                ? Radius.circular(0)
                                : Radius.circular(30),
                          ),
                        ),
                        child: Text(
                          messageText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // **Message Input**
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Color(0xff703eff),
                      borderRadius: BorderRadius.circular(60)),
                  child: Icon(Icons.mic, size: 35, color: Colors.white),
                ),
                SizedBox(width: 10),

                // **TextField**
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Color(0xFFececf5),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: InputBorder.none,
                        hintText: "Write a Message..",
                        suffixIcon: Icon(Icons.attach_file),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                // **Send Button**
                GestureDetector(
                  onTap: () {
                    chatProvider.sendMessage(
                        widget.chatRoomId, _messageController.text);
                    _messageController.clear();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Color(0xff703eff),
                        borderRadius: BorderRadius.circular(60)),
                    child: Icon(Icons.send, size: 30, color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
