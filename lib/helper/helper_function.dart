import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String usernameKey = "USERNAMEKEY";
  static String useremailkey = "USEREMAILKEY";

  //saving data
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  //save user name
  static Future<bool> saveUserNameSF(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(usernameKey, username);
  }

  //save user email
  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(useremailkey, userEmail);
  }
  // geting data

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(useremailkey);
  }

  static Future<String?> getUserName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(usernameKey);
  }
}
