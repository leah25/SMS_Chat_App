import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String loggedInUserKey = 'LOGGEDINUSERKEY';
  static String userEmailKey = 'USEREMAILKEY';
  static String userNameKey = 'USERNAMEKEY';

  //saving data to SharedPreference
  static Future<bool> setLoggedInUserPreference(bool isUserLoggedIn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(loggedInUserKey, isUserLoggedIn);
  }

  static Future<dynamic> setNamedUserPreference(String theUserName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userEmailKey, theUserName);
  }

  static Future<dynamic> setEmailPreference(String theUserEmail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userNameKey, theUserEmail);
  }
  //getting data from SharedPreference

  static Future<dynamic> getLoggedInUserPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getBool(loggedInUserKey);
  }

  static Future<dynamic> getNamedUserPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getString(userNameKey);
  }

  static Future<dynamic> getEmailUserPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getString(userEmailKey);
  }
}
