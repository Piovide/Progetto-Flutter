import 'package:flutter/material.dart';
import '../utilz/Utilz.dart';
import '../component/HeaderComp.dart';
import '../component/NotesCardWidget.dart';
import '../utilz/WebUtilz.dart';

class Subjectpage extends StatefulWidget {
  final String materia;
  const Subjectpage({super.key, required this.materia});

  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subjectpage> {
  Future<List<Map<String, dynamic>>> getAppunti() async {
    final api = WebUtilz();
    final result = await api.request(
      endpoint: 'SUBJECT',
      action: 'GET_BY_MATERIA',
      method: 'POST',
      body: {
        'classe': '5BII',
        'materia': widget.materia,
      },
    );
    if (result['status'] == 404) {
      return [];
    }
    if (result['data'] != null && result['data'] is List) {
      return List<Map<String, dynamic>>.from(result['data']).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderComp(context, true),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appunti di ${widget.materia}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getAppunti(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Errore: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                              'Non ci sono appunti disponibili per questa materia.'));
                    }
                    final classes = snapshot.data!;
                    return LayoutBuilder(builder: (context, constraints) {
                      int itemWidth = 200;
                      int crossAxisCount =
                          (constraints.maxWidth / itemWidth).floor();
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
                                navigateToPage(context, 'notes', false,
                                    arguments: {
                                      'data': subjectInfo,
                                      'accessedFor': 'edit',
                                    });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: NotesCardWidget(subjectInfo: subjectInfo));
                        },
                      );
                    });
                  },
                ),
              )
            ],
          ),
        ));
  }
}
