import 'package:flutter/material.dart';
import 'package:wiki_appunti/component/SettingsMenuComponent.dart';
import '../component/HeaderComp.dart';

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