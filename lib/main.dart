import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/navegation/button_nav.dart';
import 'package:geo_visor_app/src/routing/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FormExampleApp());

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


