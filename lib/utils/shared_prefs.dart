import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static String? getString(String key) {
    return _prefsInstance?.getString(key);
  }

  static setString(String key, String value) {
    _prefsInstance?.setString(key, value);
  }

  static bool? getBool(String key) {
    return _prefsInstance?.getBool(key);
  }

  static setBool(String key, bool value) {
    _prefsInstance?.setBool(key, value);
  }

  static clearData() {
    _prefsInstance?.clear();
  }
}
