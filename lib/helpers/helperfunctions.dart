import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'constants.dart';

class HelperFunctions {
  static String spUserLoggedInKey = 'isUserLoggedIn';
  static String spUserNameInKey = 'userName';
  static String spUserEmailKey = 'userEmail';
  static String spUserId = 'userId';
  static String spReceiverNameInKey = 'receiverName';
  static String spReceiverEmailKey = 'receiverEmail';
  static String spReceiverId = 'receiverId';

  static Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  //saving data to Shared preference
  static Future<void> saveUserLoggedInSP(bool isUserLoggedIn) async {
    SharedPreferences pref = await _pref;
    return pref.setBool(spUserLoggedInKey, isUserLoggedIn);
  }

  static Future<void> saveUserIdSP(String userId) async {
    SharedPreferences pref = await _pref;
    return await pref.setString(spUserId, userId);
  }

  static Future<void> saveUserNameSP(String userName) async {
    SharedPreferences pref = await _pref;
    return await pref.setString(spUserNameInKey, userName);
  }

  static Future<void> saveUserEmailSP(String userEmail) async {
    SharedPreferences pref = await _pref;
    return await pref.setString(spUserEmailKey, userEmail);
  }

  static Future<void> saveReceiverIdSP(String userId) async {
    SharedPreferences pref = await _pref;
    return await pref.setString(spReceiverNameInKey, userId);
  }

  static Future<void> saveReceiverNameSP(String userName) async {
    SharedPreferences pref = await _pref;
    return await pref.setString(spReceiverNameInKey, userName);
  }

  static Future<void> saveReceiverEmailSP(String userEmail) async {
    SharedPreferences pref = await _pref;
    return await pref.setString(spReceiverEmailKey, userEmail);
  }

  //Getting data from shared preferences
  static Future<bool> getUserLoggedInSP() async {
    SharedPreferences pref = await _pref;
    if (!pref.containsKey(spUserLoggedInKey)) {
      return false;
    }
    return pref.getBool(spUserLoggedInKey);
  }

  static Future<String> getUserNameSP() async {
    SharedPreferences pref = await _pref;
    return pref.getString(spUserNameInKey);
  }

  static Future<String> getUserIdSP() async {
    SharedPreferences pref = await _pref;
    return pref.getString(spUserId);
  }

  static Future<String> getUserEmailSP() async {
    SharedPreferences pref = await _pref;
    return pref.getString(spUserEmailKey);
  }

  static Future<String> getReceiverNameSP() async {
    SharedPreferences pref = await _pref;
    return pref.getString(spReceiverNameInKey);
  }

  static Future<String> getReceiverIdSP() async {
    SharedPreferences pref = await _pref;
    return pref.getString(spReceiverId);
  }

  static Future<String> getReceiverEmailSP() async {
    SharedPreferences pref = await _pref;
    return pref.getString(spReceiverEmailKey);
  }

  static Future<void> resetAllSP() async {
    SharedPreferences pref = await _pref;
    return pref.clear();
  }

  static getUserName() async {
    if (Constants.myName == null) {
      Constants.myName = await HelperFunctions.getUserNameSP();
    }
    return Constants.myName;
  }

  static getReceiverName() async {
    if (Constants.reciverName == null) {
      Constants.reciverName = await HelperFunctions.getReceiverNameSP();
    }
    return Constants.reciverName;
  }

  static getNewUUId() {
    return Uuid().v4();
  }
}
