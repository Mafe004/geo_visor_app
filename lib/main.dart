import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/features/navegation/button_nav.dart';
import 'package:geo_visor_app/src/features/notification/push_noti_provider.dart';
import 'package:geo_visor_app/src/navegation/login_page.dart';
import 'package:geo_visor_app/src/routing/routes.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PushNotiPro().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Visor A&S',
      home: AuthenticationWrapper(), // Utiliza AuthenticationWrapper para determinar qué página mostrar
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aquí puedes agregar lógica para verificar si el usuario está autenticado
    final bool isUserLoggedIn = false; // Cambia a tu lógica real de autenticación

    return isUserLoggedIn ? const HomePage() : LoginPage(); // Mostrar LoginPage si el usuario no está autenticado
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  Bnavigator? myBnb;

  @override
  void initState() {
    myBnb = Bnavigator(currentIndex: (i) {
      setState(() {
        index = i;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: myBnb,
      body: Routes(index: index),
    );
  }
}
