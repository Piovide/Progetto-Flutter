import 'package:flutter/material.dart';
import '../component/HeaderComp.dart';
import '../component/ProfilePageMenuWidget.dart';
import '../component/ProfilePageIconWidget.dart';
import '../component/ProfilePageFormWidget.dart';

//TODO: fixare i banner gialli e neri per grandezza pagina

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
            ProfilePageIconWidget(),
            
            const SizedBox(height: 40),

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
            ),
            
          ],
        ),
      ),
    );
  }
}