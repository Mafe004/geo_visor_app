import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Mis Reportes'),
            Tab(text: 'Reportes Generales'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MyReportsPage(),
          GeneralReportsPage(),
        ],
      ),
    );
  }
}

class MyReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text('Usuario no autenticado'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Reportes')
          .where('userId', isEqualTo: user.uid) // Filtra por el ID único del usuario
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final reports = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final data = reports[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['ubicacion']),
              subtitle: Text(data['tipoLugar']),
            );
          },
        );
      },
    );
  }
}

class GeneralReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Reportes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final reports = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final data = reports[index].data() as Map<String, dynamic>;
            // Obtener una lista de las rutas de las imágenes si están disponibles
            final List<String> imagePaths = List<String>.from(data['images'] ?? []);

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubicación: ${data['ubicacion']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Tipo de lugar: ${data['tipoLugar']}'),
                    // Mostrar otros datos aquí...
                  ],
                ),
                subtitle: imagePaths.isNotEmpty
                    ? SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      // Muestra una miniatura de la imagen si está disponible
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Image.network(
                          imagePaths[index],
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}



