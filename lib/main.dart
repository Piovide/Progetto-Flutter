import 'package:flutter/material.dart';
import 'package:progetto_flutter/constants/colors.dart';
import 'package:progetto_flutter/routes/HomePage.dart';
import 'package:progetto_flutter/routes/NotesPage.dart';
// import 'package:progetto_flutter/routes/ProfilePage.dart';
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
      color: Colors.blue,
      home: Notespage(),
    );
  }
}
