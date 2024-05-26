import 'package:flutter/material.dart';

import '../features/Information/form.dart';
import '../features/Information/information.dart';
import '../features/profile/Profilepage.dart';
import '../navegation/home_screen.dart';

class Routes extends StatelessWidget {
  final int index;
  final String userName;

  const Routes({Key? key, required this.index, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> mylist = [
      const InfoPage(),
      const HomeScreen(),
      const FormExampleApp(),
      ProfilePage(userName: userName),
    ];
    return mylist[index];
  }
}
