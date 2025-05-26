import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:wiki_appunti/routes/InformationPage.dart';
import '../routes/SignInPage.dart';
import '../routes/SignUpPage.dart';
import '../routes/HomePage.dart';
import '../routes/ProfilePage.dart';
import '../routes/SubjectPage.dart';
import '../routes/NotesPage.dart';
import '../routes/SettingsPage.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

void navigateToPage(BuildContext context, String pageName, bool replace,
    {Map<String, dynamic>? arguments}) {
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
    case 'subject':
      page = Subjectpage(materia: arguments?['materia']);
      break;
    case 'notes':
      page = Notespage(
          data: arguments?['data'], accessedFor: arguments?['accessedFor']);
      break;
    case 'settings':
      page = SettingsPage();
      break;
    case 'information':
      page = InformationPage();
      break;
    default:
      throw Exception('Invalid page name: $pageName');
  }
  if (replace) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false,
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

void showSnackBar(BuildContext context, String message, int duration,
    {Color? backgroundColor}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: duration),
    backgroundColor: backgroundColor ?? Colors.blueGrey,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void saveUserData(Map<String, dynamic> userData) async {
  final prefs = await SharedPreferences.getInstance();
  for (var entry in userData.entries) {
    if (entry.value is String) {
      await prefs.setString(entry.key, entry.value);
    } else if (entry.value is int) {
      await prefs.setInt(entry.key, entry.value);
    } else if (entry.value is bool) {
      await prefs.setBool(entry.key, entry.value);
    } else if (entry.value is double) {
      await prefs.setDouble(entry.key, entry.value);
    }
  }
}

void refreshUserData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('nome');
  await prefs.remove('cognome');
  await prefs.remove('data_nascita');
  await prefs.remove('sesso');
}

Future<Map<String, dynamic>> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  Map<String, dynamic> userData = {};
  for (var key in keys) {
    userData[key] = prefs.get(key);
  }
  return userData;
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
  await prefs.clear();
}
