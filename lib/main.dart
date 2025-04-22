import 'package:flutter/material.dart';
import 'SignInPage.dart';
import 'SignUpPage.dart';
import 'HomePage.dart';

void main() {
  runApp(LoginApp());
}

// ignore: use_key_in_widget_constructors
class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
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
      page = SignUpPage(); // Ensure you have a SignUpPage widget defined
      break;
    case 'home':
      page = Homepage(); // Ensure you have a Homepage widget defined
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
