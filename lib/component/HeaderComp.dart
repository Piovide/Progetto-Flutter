import 'package:flutter/material.dart';
import 'package:progetto_flutter/utilz/Utilz.dart';

class HeaderComp extends AppBar implements PreferredSizeWidget {
  HeaderComp(BuildContext context)
      : super(
          title: Row(
            children: [
              Icon(
                Icons.note_alt,
                size: 40,
                color: Colors.black,
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
          backgroundColor: Colors.blue,
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications,
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
                          if (true)
                            Center(
                              child: Text(
                                'Non hai notifiche',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
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
                          navigateToPage(context, 'profile', true);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: () {
                          // Handle logout action
                          Navigator.pop(context);
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
