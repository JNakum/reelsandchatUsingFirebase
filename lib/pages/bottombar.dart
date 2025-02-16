import 'package:flutter/material.dart';
import 'package:reels/pages/chathome.dart';

import 'package:reels/pages/videoreels.dart';
import 'package:reels/provider/logoutprovider.dart';
import 'package:reels/utils/sharedpre.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    VideoReels(),
    Chathome(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: Text(
          "Chat And Reels.",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                Logoutprovider().signOut(context);
                await SharedpreHelper.clearLoginData();
              },
              icon: Icon(Icons.login_outlined))
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey, // Set the color you want
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.blueGrey,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.video_library), label: "Reels"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat")
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
