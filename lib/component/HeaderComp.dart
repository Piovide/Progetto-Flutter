// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progetto_flutter/constants/colors.dart';
import 'package:progetto_flutter/utilz/Utilz.dart';
import 'package:progetto_flutter/utilz/WebUtilz.dart';

class HeaderComp extends AppBar implements PreferredSizeWidget {
  HeaderComp(BuildContext context)
      : super(
          title: Row(
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
          ),
          backgroundColor: teal,
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () async {
                final RenderBox renderBox =
                    (context.findRenderObject() as RenderBox);
                final Offset offset = renderBox.localToGlobal(
                  Offset(renderBox.size.width, 0),
                );
                final api = WebUtilz();
                Future<List<Map<String, dynamic>>> getNotifications() async {
                  String? uuid = await getUUID();

                  final result = await api.request(
                  endpoint: 'NOTIFICATION',
                  action: 'GET',
                  method: 'POST',
                  body: {
                    'utente_uuid': 'uuid',
                  },
                  );
                  print(result);
                  if (result['status'] == 404) {
                    return [];
                  }
                  if (result['data'] is List) {
                  return List<Map<String, dynamic>>.from(result['data']);
                  }
                  return [];
                }

                List<Map<String, dynamic>> notifications = await getNotifications();
                if (notifications.isEmpty) {
                  print('Non hai notifiche');
                } else {
                  print('Hai ${notifications.length} notifiche');
                }
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


                          // FutureBuilder<List<Map<String, dynamic>>>(
                          //   future: getNotifications(),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState == ConnectionState.waiting) {
                          //       return Center(child: CircularProgressIndicator());
                          //     } else if (snapshot.hasError) {
                          //       return Center(child: Text('Errore nel caricamento delle notifiche'));
                          //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          //       return Center(
                          //         child: Text(
                          //           'Non hai notifiche',
                          //           style: TextStyle(color: Colors.grey),
                          //         ),
                          //       );
                          //     } else {
                          //       return Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: snapshot.data!
                          //             .map((notification) => ListTile(
                          //                   title: Text(notification['title'] ?? 'Nessun titolo'),
                          //                   subtitle: Text(notification['message'] ?? ''),
                          //                 ))
                          //             .toList(),
                          //       );
                          //     }
                          //   },
                          // ),
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
                            //TODO: clear line below
                            saveSessionToken('dffdsgfddsfsafdfasdfdsf');
                            
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
                            }

                            return success;
                          }

                          Navigator.pop(context);

                          logoutUser().then((value) {
                            if (value) {
                              clearSessionData();
                              navigateToPage(context, 'signin', true);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
