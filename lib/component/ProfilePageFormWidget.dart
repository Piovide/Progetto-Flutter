import 'package:flutter/material.dart';
import 'ProfilePageEditButton.dart';

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
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              label: Text("Nome"),
              prefixIcon: Icon(Icons.person),
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