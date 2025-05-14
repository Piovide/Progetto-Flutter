import 'package:flutter/material.dart';

class ProfilePageEditButton extends StatelessWidget {
  const ProfilePageEditButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}