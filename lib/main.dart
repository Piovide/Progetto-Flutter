import 'package:flutter/material.dart';
import 'routes/SignInPage.dart';
import 'routes/SignUpPage.dart';
import 'routes/HomePage.dart';

void main() {
  runApp(WikiApp());
}

// ignore: use_key_in_widget_constructors
class WikiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiki Appunti',      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      color: Colors.blue,
      home: SignInPage(),
    );
  }
}

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
