import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/navegation/home_screen.dart';
import 'package:geo_visor_app/src/navegation/button_nav.dart';
import 'package:geo_visor_app/src/navegation/information.dart';
import 'package:geo_visor_app/src/navegation/notipage.dart';
import 'package:geo_visor_app/src/routing/routes.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Geo Visor A&S',
      home: HomePage(),

    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage ({Key? key}) :super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index=0;
  Bnavigator ?myBnb;

  @override
  void initState() {
    myBnb = Bnavigator(currentIndex: (i){
      setState(() {
        index = i;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: myBnb,
      body: Routes(index: index),

    );
  }
}


