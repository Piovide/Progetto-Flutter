import 'package:flutter/material.dart';

class HomePageCardWidget extends StatelessWidget {
  const HomePageCardWidget({
    super.key,
    required this.subjectInfo,
  });

  final Map<String, String> subjectInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                subjectInfo['title']!,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              subjectInfo['teacher']!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: (){},
                icon: Icon(
                  Icons.info_outline_rounded,
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}