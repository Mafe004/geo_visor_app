import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geo_visor_app/src/features/Information/button_nav.dart';
import 'package:geo_visor_app/src/features/profile/login_page.dart';
import 'package:geo_visor_app/src/routing/routes.dart';
import 'package:firebase_core/firebase_core.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
int initialReportCount = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
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
    final User? user = FirebaseAuth.instance.currentUser;
    return user != null ? const HomePage() : LoginPage();
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
  String userName = 'Cargando...';

  @override
  void initState() {
    super.initState();
    myBnb = Bnavigator(currentIndex: (i) {
      setState(() {
        index = i;
      });
    });

    // Obtener el conteo inicial de reportes y luego escuchar los cambios
    getInitialReportCount().then((count) {
      setState(() {
        initialReportCount = count;
      });
      listenForReportChanges();
    });

    // Obtener el nombre de usuario
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    String? fetchedName = await getUserName();
    setState(() {
      userName = fetchedName ?? 'Usuario sin nombre';
    });
  }

  Future<String?> getUserName() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Usuarios').doc(currentUser.uid).get();
      if (userDoc.exists && userDoc.data() != null && userDoc['name'] != null) {
        return userDoc['name'];
      } else {
        return null; // O un valor predeterminado, por ejemplo: 'Usuario sin nombre'
      }
    } else {
      return null;
    }
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('DatosEntidad').doc(currentUser.uid).get();
      if (userDoc.exists && userDoc.data() != null && userDoc['nombre'] != null) {
        return userDoc['name'];
      } else {
        return null; // O un valor predeterminado, por ejemplo: 'Usuario sin nombre'
      }
    } else {
      return null;
    }

  }

  Future<int> getInitialReportCount() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Reportes').get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: myBnb,
      body: FutureBuilder<String?>(
        future: getUserName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Routes(index: index, userName: snapshot.data ?? "Usuario sin nombre");
          }
        },
      ),
    );
  }
}

// Función para enviar notificación local
void sendLocalNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

// Función para escuchar cambios en la colección de reportes
void listenForReportChanges() {
  FirebaseFirestore.instance.collection('Reportes').snapshots().listen((snapshot) {
    int currentReportCount = snapshot.docs.length;
    if (currentReportCount > initialReportCount) {
      initialReportCount = currentReportCount; // Actualizar el conteo inicial
      sendMessageIfNotificationsEnabled();
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



