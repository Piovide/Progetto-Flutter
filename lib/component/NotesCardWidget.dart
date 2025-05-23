import 'package:flutter/material.dart';
import 'package:wiki_appunti/constants/colors.dart';

class NotesCardWidget extends StatelessWidget {
  const NotesCardWidget({
    super.key,
    required this.subjectInfo,
  });

  final Map<String, dynamic> subjectInfo;

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
                color: darkTeal,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(subjectInfo['titolo']!,
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              subjectInfo['contenuto']!,
              style: TextStyle(
                fontSize: 14,
                color: grey,
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.info_outline_rounded,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
