import 'package:shared_preferences/shared_preferences.dart';

void saveUUID(String uuid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('uuid', uuid);
}

Future<String?> getUUID() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('uuid');
}

void saveSessionToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('session_token', token);
}

Future<String?> getSessionToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('session_token');
}