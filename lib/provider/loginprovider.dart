import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reels/utils/sharedpre.dart';

class Loginprovider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  String _userName = "";

  String get userName => _userName;

  bool get isLoading => _isLoading;

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        _userName = user.displayName ?? "User";
        await SharedpreHelper.setLoginStatus(true);
        final userRef =
            FirebaseFirestore.instance.collection("users").doc(user.uid);

        final userDoc = await userRef.get();
        if (!userDoc.exists) {
          userRef.set({
            "Name": user.displayName, // Name is The users table column name ,
            'Email': user.email,
            "Id": user.uid,
            'Image': user.photoURL,
            "UserName": user.displayName?.toUpperCase(),
            'Searchkey': user.displayName?.toLowerCase(),
          });
        }
      }

      _isLoading = false;
      notifyListeners();

      return user;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In faild : ${e.toString()}")));
      return null;
    }
  }
}
