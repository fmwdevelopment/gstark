import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSharedPref {
  static final CustomSharedPref _instance = CustomSharedPref._();

  CustomSharedPref._();

  static CustomSharedPref get instance => _instance;

  static Future setPref<T>(String key, T value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    switch (T) {
      case bool:
        pref.setBool(key, value as bool);
        break;
      case List: //need to change to List<String>
        pref.setStringList(key, value as List<String>);
        break;
      case String:
        pref.setString(key, value as String);
        break;
      case int:
        pref.setInt(key, value as int);
        break;
      case double:
        pref.setDouble(key, value as double);
        break;
      case Map:
        pref.setString(key, json.encode(value));
        break;
      case dynamic:
        pref.setString(key, value.toString());
        break;
      default:
        break;
    }
  }

  static Future getPref<T>(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    switch (T) {
      case bool:
        return pref.getBool(key);
      case List: //need to change to List<String>
        return pref.getStringList(key);
      case String:
        return pref.getString(key) ?? '';
      case int:
        return pref.getInt(key);
      case double:
        return pref.getDouble(key);
      case Map:
        return json.decode(pref.getString(key) ?? "");
      case dynamic:
        return pref.getString(key);

      default:
        break;
    }
  }

  static Future removePref(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }

  static Future<bool> clearAllPrefs() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.clear();
  }

  static Future containsKey(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(key);
  }
}
