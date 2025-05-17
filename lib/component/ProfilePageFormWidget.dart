import 'package:flutter/material.dart';
import 'ProfilePageEditButton.dart';
import '../constants/colors.dart';

//TODO: make the password field not interaptive

class ProfilePageFormWidget extends StatelessWidget {
  const ProfilePageFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            enabled: false,
            // enableInteractiveSelection: false,
            focusNode: FocusNode(),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(color: black),
              ),
              label: Text("Nome", style: TextStyle(color: black)),
              prefixIcon: Icon(Icons.person, color: black),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              label: Text("Email"),
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              label: Text("Password"),
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 20),
          ProfilePageEditButton(),
        ],
      ),
    );
  }
}