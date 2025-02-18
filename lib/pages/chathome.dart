import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reels/pages/chatpage.dart';
import 'package:reels/provider/chatprovider.dart';
import 'package:reels/provider/loginprovider.dart';

class Chathome extends StatefulWidget {
  const Chathome({super.key});

  @override
  State<Chathome> createState() => _ChathomeState();
}

class _ChathomeState extends State<Chathome> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Loginprovider>(context, listen: false).checkLoginStatus();
    });
  }

  void searchUser(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('Searchkey', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('Searchkey', isLessThan: '${query.toLowerCase()}z')
        .get();

    var loginProvider = Provider.of<Loginprovider>(context, listen: false);
    String loggedInUserName = loginProvider.userName.toLowerCase();

    setState(() {
      searchResults = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((user) {
        // Login user ko exclude karna
        return user['UserName'].toLowerCase() != loggedInUserName;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Hello,",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 2),
                  Consumer<Loginprovider>(
                    builder: (context, loginProvider, child) {
                      return Text(
                        loginProvider.userName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepOrange,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Welcome To Chat",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 30),
            chatscreen(),
          ],
        ),
      ),
    );
  }

  Widget chatscreen() {
    final loginProvider = Provider.of<Loginprovider>(context);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blueGrey[700],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: searchController,
                onChanged: searchUser,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search User Name",
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(child: usernameList(loginProvider, chatProvider)),
          ],
        ),
      ),
    );
  }

  Widget usernameList(Loginprovider loginProvider, ChatProvider chatProvider) {
    return searchResults.isEmpty
        ? Center(
            child: Text(
              "No users found",
              style: TextStyle(color: Colors.white),
            ),
          )
        : ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              var user = searchResults[index];
              return userTile(user, loginProvider, chatProvider);
            },
          );
  }

  Widget userTile(Map<String, dynamic> user, Loginprovider loginProvider,
      ChatProvider chatProvider) {
    return Material(
      elevation: 9.0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: () async {
            String chatRoomId = await chatProvider.createChatRoom(
              loginProvider.userId, // Current User
              user['Id'], // Selected User
            );

            Provider.of<ChatProvider>(context, listen: false)
                .setReceiverName(user['UserName']);

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chatpage(chatRoomId: chatRoomId)),
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  user['Image'],
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['UserName'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                      ),
                    ),
                    Text(
                      "Tap to chat",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
