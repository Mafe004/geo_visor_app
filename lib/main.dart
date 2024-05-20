import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/features/navegation/button_nav.dart';
import 'package:geo_visor_app/src/navegation/login_page.dart';
import 'package:geo_visor_app/src/routing/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
  listenForReportChanges();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Visor A&S',
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isUserLoggedIn = false; // Cambia a tu lógica real de autenticación
    return isUserLoggedIn ? const HomePage() : LoginPage();
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

// Función para enviar notificación local
void sendLocalNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

// Función para escuchar cambios en la colección de reportes
// Función para escuchar cambios en la colección de reportes
void listenForReportChanges() {
  FirebaseFirestore.instance.collection('Reportes').snapshots().listen((snapshot) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        // Verificar si las notificaciones generales están habilitadas antes de enviar el mensaje
        sendMessageIfNotificationsEnabled();
      }
    }
  });
}
// Función para enviar el mensaje si las notificaciones generales están habilitadas
void sendMessageIfNotificationsEnabled() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Obtener el estado de las notificaciones generales
      final snapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(user.uid)
          .get();
      final generalNotificationsEnabled = snapshot.data()?['notificaciones_generales'];

      // Verificar si se obtuvo correctamente el estado de las notificaciones generales
      print('Estado de notificaciones generales: $generalNotificationsEnabled');

      // Verificar si las notificaciones generales están habilitadas
      if (generalNotificationsEnabled == true) {
        // Enviar el mensaje
        sendLocalNotification('Nuevo reporte', 'Se ha enviado un nuevo reporte');
      } else {
        print('Las notificaciones generales están desactivadas. El mensaje no fue enviado.');
      }
    }
  } catch (e) {
    print("Error al enviar el mensaje: $e");
  }
}


