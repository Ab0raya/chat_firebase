import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String userLoggedInKey = 'LOGGED_IN_KEY';
  static String userNameKey = 'NAME_KEY';
  static String userEmailKey = 'Email_KEY';

  static saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInState() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.getBool(userLoggedInKey);
    return sf.getBool(userLoggedInKey);

  }
  static Future<String?> getName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.getString(userNameKey);
    return sf.getString(userNameKey);

  }
  static Future<String?> getEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.getString(userEmailKey);
    return sf.getString(userEmailKey);

  }
}
