import 'package:flutter/material.dart';
import 'package:progetto_flutter/constants/colors.dart';

class ProfilePageIconWidget extends StatelessWidget {
  const ProfilePageIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: white,
                      size: 20,
                    )
                  ),
                )
              ],
            ),            
            const SizedBox(height: 10),
            Text("Nome", style: Theme.of(context).textTheme.headlineMedium),
            Text("Email", style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}