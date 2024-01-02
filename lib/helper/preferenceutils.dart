import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async => _prefsInstance = await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

// call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }


  static String getString(String key, [String? defValue]) {
    return _prefsInstance?.getString(key) ?? defValue ?? " ";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }


  static Future<bool> setlogin(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static bool getlogin(String key, [bool? defValue])  {
    return _prefsInstance?.getBool(key) ??defValue?? false;
  }

  static Future<bool> setbool(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static bool getbool(String key, [bool? defValue])  {
    return _prefsInstance?.getBool(key) ??defValue?? false;
  }

  static void clear(){
    _prefsInstance?.clear();
  }
  static void remove(String key) async {
    _prefsInstance?.remove(key);
  }

}