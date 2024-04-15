
import 'package:flutter/material.dart';
import '../features/navegation/form.dart';
import '../features/navegation/home_screen.dart';
import '../features/navegation/information.dart';
import '../features/navegation/notipage.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({Key?  key, required this.index});

  @override
  Widget build(BuildContext context) {
    // context.go('home');
    List<Widget> mylist=[
      const InfoPage(),
      const HomeScreen(),
      const NotifPage(),
      const FormExampleApp()
    ];
    return mylist[index];
  }
}