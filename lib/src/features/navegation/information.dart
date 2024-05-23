import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

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
          tabs: const [
            Tab(text: 'Mis Reportes'),
            Tab(text: 'Reportes Generales'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MyReportsPage(),
          GeneralReportsPage(),
        ],
      ),
    );
  }
}

class MyReportsPage extends StatelessWidget {
  const MyReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Usuario no autenticado'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Reportes')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final reports = snapshot.data?.docs ?? [];
        if (reports.isEmpty) {
          return const Center(child: Text('No hay reportes disponibles.'));
        }
        return ListView.builder(
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final data = reports[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  data['ubicacion'] ?? 'Ubicación no disponible',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(data['tipoLugar'] ?? 'Tipo de lugar no disponible'),
                trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
                onTap: () {
                  // Acción al tocar el reporte
                },
              ),
            );
          },
        );
      },
    );
  }
}

class GeneralReportsPage extends StatelessWidget {
  const GeneralReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Reportes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final reports = snapshot.data?.docs ?? [];
        if (reports.isEmpty) {
          return const Center(child: Text('No hay reportes disponibles.'));
        }
        return ListView.builder(
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final data = reports[index].data() as Map<String, dynamic>;
            final List<String> imagePaths = List<String>.from(data['images'] ?? []);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubicación: ${data['ubicacion'] ?? 'No disponible'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Tipo de lugar: ${data['tipoLugar'] ?? 'No disponible'}'),
                  ],
                ),
                subtitle: imagePaths.isNotEmpty
                    ? SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imagePaths[index],
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : null,
                trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
                onTap: () {
                  // Acción al tocar el reporte
                },
              ),
            );
          },
        );
      },
    );
  }
}
