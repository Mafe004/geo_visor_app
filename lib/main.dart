import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geo_visor_app/src/navegation/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Visor A&S',
      home: LoginPage(), // Asegúrate de que la página de inicio sea LoginPage
    );
  }
}


