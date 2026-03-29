import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _keyUserId = 'user_id';
  static const String _keyUserRole = 'user_role';
  
  static Future<void> saveUserId(String id) async {
    await _prefs.setString(_keyUserId, id);
  }

  static String? getUserId() {
    return _prefs.getString(_keyUserId);
  }

  static Future<void> saveUserRole(String role) async {
    await _prefs.setString(_keyUserRole, role);
  }

  static String? getUserRole() {
    return _prefs.getString(_keyUserRole);
  }

  static Future<void> clearUser() async {
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserRole);
  }
}
