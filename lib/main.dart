import 'package:flutter/material.dart';
import 'routes/SignInPage.dart';
// import 'routes/SignUpPage.dart';
// import 'routes/HomePage.dart';
// import 'routes/ProfilePage.dart';

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


