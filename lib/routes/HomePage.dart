import 'package:flutter/material.dart';
import 'package:wiki_appunti/component/NotesCardWidget.dart';
import '../utilz/Utilz.dart';
import '../component/HeaderComp.dart';
import '../component/HomePageCardWidget.dart';
import '../utilz/WebUtilz.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<List<Map<String, dynamic>>> getMaterie() async {
    final api = WebUtilz();
    final result = await api.request(
      endpoint: 'SUBJECT',
      action: 'GET',
      method: 'POST',
      body: {
        //TODO da togliere
        'classe': '5BII',
      },
    );
    if (result['status'] == 404) {
      return [];
    }
    if (result['data'] is List) {
      return List<Map<String, dynamic>>.from(result['data']).toList();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getAppuntiUtente() async {
    final api = WebUtilz();
    final uuid = await getUUID();
    final result = await api.request(
      endpoint: 'NOTE',
      action: 'GET_BY_UUID',
      method: 'POST',
      body: {
        'uuid': uuid,
      },
    );
    if (result['status'] == 404) {
      return [];
    }
    if (result['data'] is List) {
      return List<Map<String, dynamic>>.from(result['data']).toList();
    }
    return [];
  }

  Map<String, dynamic>? userData;
  Future<void> getData() async {
    Map<String, dynamic> data = await getUserData();
    setState(() {
      userData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Benvenuto/a  ${userData?['username'] ?? 'Utente'}!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    tooltip: 'Aggiungi appunti',
                    onPressed: () {
                      navigateToPage(context, 'notes', false, arguments: {
                        'data': {
                          'titolo': 'Nuovo appunto',
                          'contenuto': '',
                          'autore_uuid': userData?['uuid'] ?? '',
                        },
                        'accessedFor': 'create',
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'I tuoi appunti:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getAppuntiUtente(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Errore: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Nessun appunto trovato.'));
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
              ),
              const SizedBox(height: 16),
              Text(
                'Le tue materie:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getMaterie(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Errore: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Nessuna materia trovata.'));
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
                                navigateToPage(context, 'subject', false,
                                    arguments: {
                                      'materia': subjectInfo['nome'],
                                      'professore': subjectInfo['professore'],
                                      'materia_uuid': subjectInfo['uuid']
                                    });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  HomePageCardWidget(subjectInfo: subjectInfo));
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
