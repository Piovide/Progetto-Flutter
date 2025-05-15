import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../routes/SignInPage.dart';
import '../routes/SignUpPage.dart';
import '../routes/HomePage.dart';
import '../routes/ProfilePage.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

void navigateToPage(BuildContext context, String pageName, bool replace) {
  Widget page;
  switch (pageName) {
    case 'signin':
      page = SignInPage();
      break;
    case 'signup':
      page = SignUpPage();
      break;
    case 'home':
      page = Homepage();
      break;
    case 'profile':
      page = ProfilePage();
      break;
    default:
      throw Exception('Invalid page name: $pageName');
  }
  if (replace) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

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

bool isMobile() {
  if (kIsWeb) return false;
  return Platform.isAndroid || Platform.isIOS;
}

bool isDesktop() {
  if (kIsWeb) return false;
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}

void clearSessionData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('uuid');
  await prefs.remove('session_token');
}