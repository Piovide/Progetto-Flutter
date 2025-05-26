import 'package:flutter/material.dart';
import '../routes/SettingsPage.dart';
import 'constants/colors.dart';
import 'routes/HomePage.dart';
import 'routes/NotesPage.dart';
import 'routes/ProfilePage.dart';
import 'routes/SignInPage.dart';
import 'routes/SignUpPage.dart';
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
