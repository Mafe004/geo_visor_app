
import 'package:flutter/material.dart';
import '../features/navegation/form.dart';
import '../features/navegation/information.dart';
import '../features/navegation/notipage.dart';
import '../navegation/home_maps.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({Key?  key, required this.index});

  @override
  Widget build(BuildContext context) {
    // context.go('home');
    List<Widget> mylist=[
      const InfoPage(),
      const HomeMaps(),
      const FormExampleApp(),
      const NotifPage(),
    ];
    return mylist[index];
  }
}