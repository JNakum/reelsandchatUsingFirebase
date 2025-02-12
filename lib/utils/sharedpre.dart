import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart'; // Import for log()

class SharedpreHelper {
  static const String isLoggedInKey = "isLoggedIn";

  // Save Login State
  static Future<void> setLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, isLoggedIn);

    log("Login status saved: $isLoggedIn"); // Log when status is saved
  }

  // Get Login Status
  static Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;

    log("Login status fetched: $isLoggedIn"); // Log when status is fetched
    return isLoggedIn;
  }

  // Clear Login Data
  static Future<void> clearLoginData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(isLoggedInKey);

    log("Login data cleared."); // Log when data is cleared
  }
}
