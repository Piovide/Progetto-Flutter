import 'package:flutter/material.dart';
import 'ProfileMenuWidget.dart';

class ProfilePageMenuWidget extends StatelessWidget {
  const ProfilePageMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}