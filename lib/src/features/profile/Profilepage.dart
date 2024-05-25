import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/navegation/Text_box.dart';
import '../services/settingpge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../profile/login_page.dart'; // Asegúrate de importar la página de inicio de sesión

class ProfilePage extends StatefulWidget {
  final String userName;

  const ProfilePage({Key? key, required this.userName}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Método para editar campo
  Future<void> editField(String field) async {
    // Lógica para editar el campo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(height: 50),
          // Foto de perfil
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_picture.png'),
          ),
          SizedBox(height: 20),
          // Nombre de usuario
          Center(
            child: Text(
              widget.userName,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
          ),
          SizedBox(height: 50),
          // Detalles
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Detalles',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          // Usuario
          MyTextBox(
            text: 'Prueba',
            sectionName: 'Nombre Usuario',
            onPressed: () => editField('Nombre Usuario'),
          ),
          SizedBox(height: 20),
          // Historial
          // Setting Notification
          // Elemento de perfil
          itemProfile("Notificación", Icons.add_alert_sharp, () {
            // Navegar a la pantalla de ajustes
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }),
          SizedBox(height: 20),
          // Elemento para cerrar sesión
          itemProfile("Cerrar sesión", Icons.exit_to_app, () {
            // Cerrar sesión del usuario
            FirebaseAuth.instance.signOut();
            // Navegar de vuelta a la pantalla de inicio de sesión
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
            );
          }),
        ],
      ),
    );
  }

  Widget itemProfile(String title, IconData iconData, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: Offset(0, 3),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(iconData, color: Colors.blueAccent),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
        onTap: onPressed,
      ),
    );
  }
}


