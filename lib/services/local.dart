import 'package:shared_preferences/shared_preferences.dart';

Future storeLocal(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future clearLocal(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

Future<String?> retrieveLocal(String key) async {
  final prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString(key);
  return value;
}

Future clearAllLocal() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
