import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reels/firebase_options.dart';
import 'package:reels/pages/bottombar.dart';
import 'package:reels/pages/login.dart';
import 'package:reels/provider/chatprovider.dart';
import 'package:reels/provider/loginprovider.dart';
import 'package:reels/provider/logoutprovider.dart';
import 'package:reels/utils/sharedpre.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Loginprovider()),
        ChangeNotifierProvider(create: (context) => Logoutprovider()),
        ChangeNotifierProvider(create: (context) => ChatProvider())
      ],
      child: ReelsApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
  print(message.notification!.body.toString());
  print(message.data.toString());
}

class ReelsApp extends StatelessWidget {
  const ReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: SharedpreHelper
            .getLoginStatus(), // SharedPreference se login status check karenge
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Agar data load ho raha ho toh loader dikhaye
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            // Agar logged in hain
            return Bottombar();
          } else {
            // Agar logged in nahi hain
            return Login();
          }
        },
      ),
    );
  }
}
