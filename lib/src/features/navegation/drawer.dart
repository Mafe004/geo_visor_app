import 'package:flutter/material.dart';

import 'my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function ()? onProfileTap;
  const MyDrawer ({super.key, required this.onProfileTap,});

  @override
  Widget build (BuildContext context) {
    return Drawer (
    backgroundColor: Colors.blueAccent,
    child: Column(
      children: [
        //header
        DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            ),
        ),

        //perfil list
        MyListTile(
            icon: Icons.person,
            text: 'P E R F I L',
            onTap: onProfileTap,
        ),

        //logout list
        MyListTile(
          icon: Icons.logout,
          text: 'C E R R A R   S E S I O N',
          onTap: onProfileTap,
        ),
      ],
    ),
    );
  }
}