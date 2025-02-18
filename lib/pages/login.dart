import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:reels/pages/bottombar.dart';
import 'package:reels/provider/loginprovider.dart';
import 'package:reels/utils/notificationhelper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  NotificationHelper notificationSevices = NotificationHelper();

  @override
  void initState() {
    super.initState();
    notificationSevices.requestNofificationPermission();
    notificationSevices.firebaseInit(context);
    notificationSevices.setupInteractMessage(context);
    notificationSevices.getDiviceToken().then((value) {
      log("Device Token Vaue => $value");
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<Loginprovider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 204, 200, 184),
        title: Text("Login"),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  textfield(),
                  SizedBox(
                    height: 10,
                  ),
                  loginButton(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      loginWithPhoneButton(),
                      SizedBox(
                        width: 5,
                      ),
                      if (loginProvider.isLoading)
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.blue,
                          size: 50,
                        ),
                      if (!loginProvider.isLoading)
                        loginWithGoogleButton(loginProvider),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textfield() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Emial Address",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: "Enter Email",
            hintStyle: TextStyle(
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w300),
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Password",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: "Enter Password",
            hintStyle: TextStyle(
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w300),
            prefixIcon: const Icon(Icons.password),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget loginButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 13, 76, 112),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5, // Shadow effect
        ),
        child: const Text(
          "Login",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget loginWithGoogleButton(Loginprovider loginProvider) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () async {
          final user = await loginProvider.signInWithGoogle(context);

          if (user != null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Bottombar()));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: Colors.grey),
          elevation: 3,
        ),
        child: const Text(
          "Login with Google",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget loginWithPhoneButton() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
        ),
        child: const Text(
          "Login with Phone",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
