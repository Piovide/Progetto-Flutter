import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'ProfileMenuWidget.dart';
import '../utilz/Utilz.dart';
import '../utilz/WebUtilz.dart';

class ProfilePageMenuWidget extends StatelessWidget {
  const ProfilePageMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuWidget(
            title: "Settings",
            icon: Icons.settings,
            onPress: () {
              navigateToPage(context, 'settings', false);
            }),
        const SizedBox(height: 30),
        ProfileMenuWidget(
            title: "Informations",
            icon: Icons.info,
            onPress: () {
              navigateToPage(context, 'information', false);
            }),
        const SizedBox(height: 30),
        ProfileMenuWidget(
            title: "Delete Account",
            icon: Icons.logout_rounded,
            textColor: red,
            endIcon: false,
            onPress: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Elimina account :('),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Conferma cancellazione'),
                                  content: Text(
                                      'Sei sicuro di voler cancellare l\'account?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Annulla'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await deleteAccount(context);
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
            }),
        const SizedBox(height: 30),
      ],
    );
  }

  Future<void> deleteAccount(BuildContext context) async {
    final api = WebUtilz();
    final uuid = await getUUID();
    final result = await api.request(
      endpoint: 'AUTH',
      action: 'DELETE_USER',
      method: 'POST',
      body: {
        'uuid': uuid,
      },
    );
    if (result['status'] == 200) {
      if (context.mounted) {
        showSnackBar(
          context,
          "Account eliminato con successo",
          2,
        );
      }
      clearSessionData();
      if (context.mounted) {
        navigateToPage(context, 'signin', true);
      }
    } else {
      if (context.mounted) {
        showSnackBar(
          context,
          "Errore durante l'eliminazione dell'account",
          2,
          backgroundColor: Colors.blueGrey,
        );
      }
    }
  }
}
