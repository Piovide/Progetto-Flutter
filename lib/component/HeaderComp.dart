// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utilz/Utilz.dart';
import '../utilz/WebUtilz.dart';

/// HeaderComp è un componente AppBar personalizzato che mostra il titolo e le icone.
/// Se `showIcons` è true, visualizza le icone delle notifiche e del profilo.
/// Gestisce la visualizzazione delle notifiche e le azioni di profilo/logout tramite menu popup.

class HeaderComp extends AppBar implements PreferredSizeWidget {
  HeaderComp(BuildContext context, bool showIcons)
      : super(
          title: showIcons
              ? Row(
                  children: [
                    Icon(
                      Icons.note_alt,
                      size: 40,
                      color: black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Wiki Appunti',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : null,
          backgroundColor: teal,
          centerTitle: false,
          actions: showIcons
              ? [
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () async {
                      final BuildContext localContext = context;
                      final RenderBox renderBox =
                          (localContext.findRenderObject() as RenderBox);
                      final Offset offset = renderBox.localToGlobal(
                        Offset(renderBox.size.width, 0),
                      );
                      final api = WebUtilz();
                      Future<List<Map<String, dynamic>>>
                          getNotifications() async {
                        String? uuid = await getUUID();

                        final result = await api.request(
                          endpoint: 'NOTIFICATION',
                          action: 'GET',
                          method: 'POST',
                          body: {
                            'utente_uuid': uuid ?? '',
                          },
                        );
                          if (kDebugMode) {
                            print(result);
                          }
                        
                        if (result['status'] == 404) {
                          return [];
                        }
                        if (result['data'] is List) {
                          return List<Map<String, dynamic>>.from(
                              result['data']);
                        }
                        return [];
                      }

                      List<Map<String, dynamic>> notifications =
                          await getNotifications();

                      // Check if context is still valid before using it
                      if (!localContext.mounted) return;

                      showMenu(
                        context: localContext,
                        position: RelativeRect.fromLTRB(
                          offset.dx,
                          offset.dy + 60,
                          offset.dx + renderBox.size.width,
                          offset.dy,
                        ),
                        items: [
                          PopupMenuItem(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Notifiche',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Divider(),
                                if (notifications.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Nessuna notifica'),
                                  )
                                else
                                  ...notifications.map((notification) {
                                    return ListTile(
                                      title: Text(notification['tipo']),
                                      subtitle: Text(notification['messaggio']),
                                      onTap: () {
                                        // Handle notification tap
                                        Navigator.pop(localContext);
                                        navigateToPage(
                                            localContext, 'profile', false);
                                      },
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.account_circle_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      final RenderBox renderBox =
                          (context.findRenderObject() as RenderBox);
                      final Offset offset = renderBox.localToGlobal(
                        Offset(renderBox.size.width, 0),
                      );

                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          offset.dx,
                          offset.dy + 60,
                          offset.dx + renderBox.size.width,
                          offset.dy,
                        ),
                        items: [
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Profilo'),
                              onTap: () {
                                // Handle profile action
                                Navigator.pop(context);
                                navigateToPage(context, 'profile', false);
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.logout),
                              title: Text('Logout'),
                              onTap: () {
                                // Handle logout action
                                final api = WebUtilz();

                                Future<bool> logoutUser() async {
                                  bool success = false;

                                  String? token = await getSessionToken();
                                  String? uuid = await getUUID();

                                  final result = await api.request(
                                    endpoint: 'AUTH',
                                    action: 'LOGOUT',
                                    method: 'POST',
                                    body: {
                                      'uuid': uuid,
                                      if (token != null) 'token': token,
                                    },
                                  );
                                  if (result['status'] == 200) {
                                    success = true;
                                    clearSessionData();
                                  }

                                  return success;
                                }

                                Navigator.pop(context);

                                logoutUser().then((value) {
                                  if (value) {
                                    clearSessionData();
                                    if (context.mounted) {
                                      navigateToPage(context, 'signin', true);
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ]
              : [],
        );

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
