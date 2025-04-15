import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  init() async {
    prefs = await _prefs;
  }

  Future<void> setInt(PrefKey key, int value) async {
    await prefs.setInt(key.toString(), value);
  }

  Future<void> setBool(PrefKey key, bool value) async {
    await prefs.setBool(key.toString(), value);
  }

  Future<void> setDouble(PrefKey key, double value) async {
    await prefs.setDouble(key.toString(), value);
  }

  Future<void> setString(PrefKey key, String value) async {
    await prefs.setString(key.toString(), value);
  }

  Future<void> setStringList(PrefKey key, List<String> value) async {
    await prefs.setStringList(key.toString(), value);
  }

  Future<int> getInt(PrefKey key, {int defaultValue = 0}) async {
    var res = prefs.getInt(key.toString()) ?? defaultValue;
    return res;
  }

  Future<bool> getBool(PrefKey key, {bool defaultValue = false}) async {
    var res = prefs.getBool(key.toString()) ?? defaultValue;
    return res;
  }

  Future<double> getDouble(PrefKey key, {double defaultValue = 0}) async {
    var res = prefs.getDouble(key.toString()) ?? defaultValue;
    return res;
  }

  Future<String> getString(PrefKey key, {String defaultValue = ""}) async {
    var res = prefs.getString(key.toString()) ?? defaultValue;
    return res;
  }

  Future<List<String>> getStringList(PrefKey key) async {
    var res = prefs.getStringList(key.toString()) ?? [];
    return res;
  }

  Future<void> clear() async {
    await prefs.clear();
  }
}

enum PrefKey {
  isLoggedIn,
  isSetupComplete,
  token,
  refreshToken,
  tokenExpiresIn,
  tokenStartTime,
  isProduction,
  userEmail
}
