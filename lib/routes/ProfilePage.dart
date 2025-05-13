import 'package:flutter/material.dart';
import '../component/HeaderComp.dart';
import '../component/ProfileMenuWidget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderComp(context),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100), child:  Image(image: AssetImage('assets/images/profile.png'))
              ),
            ),
            const SizedBox(height: 10),
            Text("Nome", style: Theme.of(context).textTheme.headlineMedium),
            Text("Email", style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text("Modifica profilo", style: TextStyle(color: Colors.white)),
                ),
            ),
            const SizedBox(height: 40),

            ProfileMenuWidget(title: "Settings", icon: Icons.settings, onPress: (){}),
            const SizedBox(height: 30),
            ProfileMenuWidget(title: "Wallet", icon: Icons.wallet, onPress: (){}),
            const SizedBox(height: 30),
            ProfileMenuWidget(title: "User Management", icon: Icons.verified_user_rounded, onPress: (){}),
            const SizedBox(height: 30),
            ProfileMenuWidget(title: "Informations", icon: Icons.info, onPress: (){}),
            const SizedBox(height: 30),
            ProfileMenuWidget(title: "Logout", icon: Icons.logout_rounded, textColor: Colors.red, endIcon: false, onPress: (){}),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}