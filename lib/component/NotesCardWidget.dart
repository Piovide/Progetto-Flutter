import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utilz/Utilz.dart';
import '../utilz/WebUtilz.dart';

/// Un widget che mostra una card per un appunto.
/// Visualizza il titolo, il contenuto e un pulsante per info/eliminazione.
/// Permette di eliminare l'appunto tramite un dialog di conferma.
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                subjectInfo['contenuto']!,
                maxLines: 20,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 12,
                  color: grey,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Elimina appunto'),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Conferma cancellazione'),
                                        content: Text(
                                            'Sei sicuro di voler cancellare questo appunto?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Annulla'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await deleteNote(
                                                  context, subjectInfo['uuid']);
                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Text('Elimina'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.info_outline_rounded,
                  ),
                  tooltip: subjectInfo['descrizione'] ??
                      'Nessuna descrizione disponibile',
                )),
          )
        ],
      ),
    );
  }

  Future<void> deleteNote(BuildContext context, uuid) async {
    final api = WebUtilz();
    final result = await api.request(
      endpoint: 'NOTE',
      action: 'DELETE',
      method: 'POST',
      body: {
        'uuid': uuid,
      },
    );
    if (result['status'] == 200) {
      if (context.mounted) {
        showSnackBar(
          context,
          "Appunto eliminato con successo",
          2,
        );
      }
    } else {
      if (context.mounted) {
        showSnackBar(
          context,
          "Errore durante l'eliminazione dell'appunto",
          2,
          backgroundColor: Colors.blueGrey,
        );
      }
    }
  }
}
