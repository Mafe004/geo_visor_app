import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/navegation/Text_box.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Usuario actual
  final currentUser = 'String';

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
        children: [
          SizedBox(height: 50),
          // Foto de perfil
          Icon(Icons.person, size: 72),

          SizedBox(height: 10),
          // Email

          SizedBox(height: 50),
          // Detalles
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Detalles',
              style: TextStyle(color: Colors.black),
            ),
          ),

          // Usuario
          MyTextBox(
            text: 'Prueba',
            sectionName: 'Nombre Usuario',
            onPressed: () => editField('Nombre Usuario'),
          ),
          // Historial
          // Setting Notification
          // Elemento de perfil
          SizedBox(height: 20),
          itemProfile("Notificacion", Icons.add_alert_sharp, () {
            // Navegar a la pantalla de ajustes
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget itemProfile(String title, IconData iconData, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              spreadRadius: 1,
              blurRadius: 10,
            )
          ]
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
        onTap: onPressed,
      ),
    );
  }
}

// Nueva pantalla de ajustes
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool generalNotificationsEnabled = true;
  bool entityNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuración de Notificaciones"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SwitchItem(
            text: "Notificaciones Generales",
            value: generalNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                generalNotificationsEnabled = value;
                updateNotificationSetting("notificaciones_generales", value);
              });
            },
          ),
          SwitchItem(
            text: "Notificaciones Entidades",
            value: entityNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                entityNotificationsEnabled = value;
                updateNotificationSetting("notificaciones_entidades", value);
              });
            },
          ),
        ],
      ),
    );
  }

  void updateNotificationSetting(String field, bool value) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user.uid)
            .update({field: value});
      }
    } catch (e) {
      print("Error updating notification setting: $e");
    }
  }
}

class SwitchItem extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchItem({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      leading: const Icon(Icons.notifications),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}