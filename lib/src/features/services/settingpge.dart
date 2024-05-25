import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool generalNotificationsEnabled = false;
  bool entityNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    loadNotificationSettings();
  }

  Future<void> loadNotificationSettings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user.uid)
            .get();
        final data = snapshot.data();
        if (data != null) {
          setState(() {
            generalNotificationsEnabled = data['notificaciones_generales'] ?? false;
            entityNotificationsEnabled = data['notificaciones_entidades'] ?? false;
          });
        }
      }
    } catch (e) {
      print("Error loading notification settings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuración de Notificaciones"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
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
        title: Text(text),
        leading: Icon(Icons.notifications, color: Colors.blueAccent),
        trailing: Switch(value: value, onChanged: onChanged),
      ),
    );
  }
}
