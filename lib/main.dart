import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'routes/SignInPage.dart';

/// Punto di ingresso principale dell'app Wiki Appunti.
/// Avvia l'applicazione con il tema principale e la pagina di accesso.
/// 
/// - Usa `MaterialApp` come contenitore.
/// - Imposta il tema principale e rimuove il banner di debug.
/// - La schermata iniziale è `SignInPage`.
void main() {
  runApp(WikiApp());
}

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
