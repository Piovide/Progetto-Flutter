import 'package:flutter/material.dart';
import 'package:progetto_flutter/constants/colors.dart';
import 'package:progetto_flutter/utilz/Utilz.dart';

class ProfilePageIconWidget extends StatefulWidget {
  @override
  _ProfilePageIconWidgetState createState() => _ProfilePageIconWidgetState();
}


class _ProfilePageIconWidgetState extends State<ProfilePageIconWidget> {
  
  //TODO: implement image picker

  @override
  Widget build(BuildContext context) {

    saveUserData(
      {
        "username" : "pierino.rossi",
        "email" : "pierino.rossi@gmail.com",
        "name" : "Pierino",
        "surname" : "Rossi",
        "dateOfBirth" : "01/01/2000",
        "genre" : "maschio",
        "password" : "password123"
      }
    );

    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        final userData = snapshot.data!;
        final username = userData['username'] as String;
        final email = userData['email'] as String;
      
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100), child:  Image(image: AssetImage('assets/cat.jpg'))
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: teal),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: white,
                            size: 20
                          ),
                          onPressed: () {
                            
                          },
                        )
                      ),
                    )
                  ],
                ),            
                const SizedBox(height: 10),
                Text(username, style: Theme.of(context).textTheme.headlineMedium),
                Text(email, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
              ],
            ),
          ],
        );
      }
    );
  }
}