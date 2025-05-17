import 'package:flutter/material.dart';
import 'package:progetto_flutter/constants/colors.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: teal.withValues(alpha: 0.1),
        ),
        child: Icon(icon, color: teal, size: 20),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.apply(color:textColor)),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: teal.withValues(alpha: 0.1),
        ),
        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: teal),
      ): null,
    );
  }
}