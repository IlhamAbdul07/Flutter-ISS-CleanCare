import 'package:shared_preferences/shared_preferences.dart';

class General {
  // ============================== FUNCTION ============================== //
  static Future<void> saveToSharedPreferences(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    data.forEach((key, value) async {
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else {
        throw UnsupportedError(
          'Tipe data $key dengan nilai $value tidak didukung',
        );
      }
    });
  }

  static Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> removeFromSharedPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      await prefs.remove(key);
    }
  }

  static Future<void> editSharedPreferences(
    String key,
    dynamic newValue,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(key)) {
      if (newValue is String) {
        await prefs.setString(key, newValue);
      } else if (newValue is int) {
        await prefs.setInt(key, newValue);
      } else if (newValue is double) {
        await prefs.setDouble(key, newValue);
      } else if (newValue is bool) {
        await prefs.setBool(key, newValue);
      } else {
        throw UnsupportedError('Tipe data untuk key "$key" tidak didukung');
      }
    }
  }
}
