import 'package:flutter/material.dart';
import 'package:wiki_appunti/constants/colors.dart';
import 'package:wiki_appunti/routes/HomePage.dart';
import 'package:wiki_appunti/routes/NotesPage.dart';
import 'package:wiki_appunti/routes/ProfilePage.dart';
import 'package:wiki_appunti/routes/SignInPage.dart';
import 'package:wiki_appunti/routes/SignUpPage.dart';
// import 'package:wiki_appunti/routes/ProfilePage.dart';
// import 'routes/SignInPage.dart';
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
        primarySwatch: teal,
      ),
      debugShowCheckedModeBanner: false,
      color: teal,
      home: SignInPage(),
    );
  }
}
