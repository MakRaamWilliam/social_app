import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{

  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBool({
    required String key,
    required bool value,
  }) async
  {
    return await sharedPreferences.setBool(key, value);
  }
  static bool? getBool({
  required String key
}){
      return sharedPreferences.getBool(key);
  }

  static Future<bool> putInt({
    required String key,
    required int value,
  }) async
  {
    return await sharedPreferences.setInt(key, value);
  }
  static int? getInt({
    required String key
  }){
    return sharedPreferences.getInt(key);
  }

  static Future<bool> putDouble({
    required String key,
    required double value,
  }) async
  {
    return await sharedPreferences.setDouble(key, value);
  }
  static double? getDouble({
    required String key
  }){
    return sharedPreferences.getDouble(key);
  }

  static Future<bool> putString({
    required String key,
    required String value,
  }) async
  {
    return await sharedPreferences.setString(key, value);
  }
  static String? getString({
    required String key
  }){
    return sharedPreferences.getString(key);
  }
  static Future<bool> removeData({
    required String key,
  }) async
  {
    return await sharedPreferences.remove(key);
  }



}
