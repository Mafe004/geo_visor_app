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
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuración de Notificaciones"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SwitchItem(text: "Notificaciones Generales"),
          SwitchItem(text: "Notificaciones Entidades"),
        ],
      ),
    );
  }
}

class SwitchItem extends StatefulWidget {
  final String text;

  const SwitchItem({Key? key, required this.text}) : super(key: key);

  @override
  State<SwitchItem> createState() => _SwitchItemState();
}

class _SwitchItemState extends State<SwitchItem> {
  bool isSelected = false;
  void itemSwitch(bool value){
    setState(() {
      isSelected = !isSelected;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title: Text(widget.text),
      leading: const Icon(Icons.notifications),
      trailing: Switch(value: isSelected, onChanged: itemSwitch),
    );
  }
}
