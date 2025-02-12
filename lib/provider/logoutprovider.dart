import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reels/pages/login.dart';
import 'package:reels/utils/sharedpre.dart';

class Logoutprovider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await SharedpreHelper.clearLoginData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout Successful')),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }
  }
}
