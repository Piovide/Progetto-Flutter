import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utilz/Utilz.dart';

/// A widget that displays the user's profile picture, username, and email.
/// Fetches user data asynchronously and shows a loading indicator while waiting.
/// Includes a camera icon button for future image picker functionality.
class ProfilePageIconWidget extends StatefulWidget {
  @override
  _ProfilePageIconWidgetState createState() => _ProfilePageIconWidgetState();
}

class _ProfilePageIconWidgetState extends State<ProfilePageIconWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found.'));
          }
          final userData = snapshot.data!;
          final username = userData['username'] as String? ?? 'default';
          final email = userData['email'] as String? ?? 'default';

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
                            borderRadius: BorderRadius.circular(100),
                            child: Image(image: AssetImage('assets/cat.jpg'))),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: teal),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt_outlined,
                                  color: white, size: 20),
                              tooltip: '(coming soon) Modifica foto',
                              onPressed: () {},
                            )),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(username,
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text(email, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          );
        });
  }
}
