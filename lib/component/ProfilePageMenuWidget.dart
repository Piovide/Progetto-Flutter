import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'ProfileMenuWidget.dart';
import '../utilz/Utilz.dart';

class ProfilePageMenuWidget extends StatelessWidget {
  const ProfilePageMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuWidget(title: "Settings", icon: Icons.settings, onPress: (){navigateToPage(context, 'settings', false);}),
        const SizedBox(height: 30),
        ProfileMenuWidget(title: "Informations", icon: Icons.info, onPress: (){}),
        const SizedBox(height: 30),
        ProfileMenuWidget(title: "Delete", icon: Icons.logout_rounded, textColor: red, endIcon: false, onPress: (){}),
        const SizedBox(height: 30),
      ],
    );
  }
}