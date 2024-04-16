import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/navegation/Text_box.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {

  //user
  final currentUser = String;

  //editarcampo
  Future<void> editField(String field) async {

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
          const SizedBox(height: 50),
          //foto perfil
          Icon(Icons.person,
            size: 72,
          ),

          const SizedBox(height: 10),
          //Email


          const SizedBox(height: 50),
          //Detalles
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Detalles',
              style: TextStyle(color: Colors.black),
            ),
          ),

          //usuario
          MyTextBox(text: 'Prueba', sectionName: 'Nombre Usuario', onPressed: () => editField('Nombre Usuario'),
          ),
          //historial
        ],
      ),
    );
  }
}
