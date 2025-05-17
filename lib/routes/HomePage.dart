import 'package:flutter/material.dart';
import '../component/HeaderComp.dart';
import '../component/HomePageCardWidget.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  
  final List<Map<String, String>> classes = [
    {'title': 'Matematica', 'teacher': 'Prof.ssa Chieppa'},
    {'title': 'Informatica', 'teacher': 'Prof.ssa Mongelli'},
    {'title': 'Italiano', 'teacher': 'Prof.ssa Leone'},
    {'title': 'T.P.S.I.T.', 'teacher': 'Prof. Frigo'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderComp(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benvenuto/a  Utente!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:LayoutBuilder(
                builder: (context, constraints) {
                  int itemWidth = 200;
                  int crossAxisCount = (constraints.maxWidth / itemWidth).floor();
                  return GridView.builder(
                    itemCount: classes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount.clamp(1, 4),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 4 / 3,
                    ),
                    itemBuilder: (context, index) {
                      final subjectInfo = classes[index];
                      return InkWell(
                        onTap: () {
                          // Handle tap
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: HomePageCardWidget(subjectInfo: subjectInfo)
                      );
                    },
                  );
                }
              ),
            )
          ],
        ), 
      )
    );
  }
}