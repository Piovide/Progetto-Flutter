import 'package:flutter/material.dart';
import 'package:wiki_appunti/component/SettingsMenuComponent.dart';
import '../component/HeaderComp.dart';

/// Una semplice pagina delle impostazioni che mostra le opzioni per il tema scuro
/// e le notifiche. Utilizza uno scroll view e un'intestazione personalizzata.
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderComp(context, false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            
            Center(
              child: Text('Settings', style: Theme.of(context).textTheme.headlineLarge),
            ),

            SizedBox(height: 70),

            SettingsMenuComponent(title: 'DarkMode', icon: Icons.dark_mode_outlined),
            
            SettingsMenuComponent(title: 'Notifications', icon: Icons.notifications_rounded),
            
          ],
        ),
      ),
    );
  }
}