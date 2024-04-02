import 'package:geo_visor_app/src/navegation/home_screen.dart';
import 'package:geo_visor_app/src/navegation/form.dart';
import 'package:flutter/material.dart';
import '../navegation/notipage.dart';
import '../navegation/information.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({Key?  key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> mylist=[
      const InfoPage(),
      const HomeScreen(),
      const NotifPage(),
      const FormExampleApp()
    ];
    return mylist[index];
  }
}