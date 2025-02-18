// import 'package:shared_preferences/shared_preferences.dart';
// class SharedpreferenceHelper{

// static String userIdKey = "USERKEY";
// static String userNameKey = "USERNAMEKEY";
// static String userEmailKey = "USEREMAILKEY";
// static String userImageKey = "USERIMAGEKEY";
// static String userUserNameKey = "USERUSERNAMEKEY";

// Future<bool> saveUserId(String getUserId) async {
// SharedPreferences prefs = await SharedPreferences.getInstance();
// return prefs.setString(userIdKey, getUserId);
// }

// Future<bool> saveUserDisplayName(String getUserName) async {
// SharedPreferences prefs = await SharedPreferences.getInstance();
// return prefs.setString(userNameKey, getUserName);

// }

// Future<bool> saveUserEmail(String getUserEmail) async {
// SharedPreferences prefs = await SharedPreferences.getInstance();
// return prefs.setString(userEmailKey, getUserEmail);
// }

// Future<bool> saveUserImage(String getUserImage) async {
// SharedPreferences prefs = await SharedPreferences.getInstance();
// return prefs.setString(userImageKey, getUserImage);
// }
// Future<bool> saveUserName(String getUserName1) async {
// SharedPreferences prefs = await SharedPreferences.getInstance();
// return prefs.setString (userUserNameKey, getUserName1);
// }
// Future<String?> getUserId() async {
// SharedPreferences prefs = await SharedPreferences.getInstance();
// return prefs.getString(userIdKey);
// }

// Future<String?> getUserDisplayName() async {
// SharedPreferences prefs = await SharedPreferences.getInstance();
// return prefs.getString(userNameKey);
// }

// Future<String?> getUserName() async {
// SharedPreferences prefs = await SharedPreferences.getInstance();
// return prefs.getString(userUserNameKey);
// }

//   Future<String?> getUserEmail() async {  // Added getter for email
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(userEmailKey);
//   }

//   Future<String?> getUserImage() async { // Added getter for image
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(userImageKey);
//   }
// }

//** Code Give me In GEMINI AI */

import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userDisplayNameKey = "USERDISPLAYNAMEKEY"; // Consistent naming
  static String userEmailKey = "USEREMAILKEY";
  static String userImageKey = "USERIMAGEKEY";
  static String userUserNameKey = "USERUSERNAMEKEY";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserDisplayName(String getUserDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userDisplayNameKey, getUserDisplayName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUserImage);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(
        userUserNameKey, getUserName); // Corrected and returns bool
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userDisplayNameKey); // Consistent key
  }

  Future<String?> getUserEmail() async {
    // Added getter for email
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserImage() async {
    // Added getter for image
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUserNameKey);
  }
}
