import 'package:flutter/material.dart';
import '../component/HeaderComp.dart';
import '../component/ProfilePageMenuWidget.dart';
import '../component/ProfilePageIconWidget.dart';
import '../component/ProfilePageFormWidget.dart';
import '../utilz/Utilz.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: HeaderComp(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            ProfilePageIconWidget(),
            
            const SizedBox(height: 40),

            // isMobile() ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ProfilePageMenuWidget()
                ),
                Expanded(
                  child: ProfilePageFormWidget()
                )
              ],
            )
            // :
            // ProfilePageMenuWidget(),
            
          ],
        ),
      ),
    );
  }
}