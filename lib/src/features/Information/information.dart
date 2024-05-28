import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geo_visor_app/src/features/Information/viewReportPage.dart';
import 'package:intl/intl.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>
    with SingleTickerProviderStateMixin {
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

  Future<Color> _getUserColor(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('Usuarios')
        .doc(userId)
        .get();
    if (userDoc.exists) {
      return Colors.blue;
    }
    final entityDoc = await FirebaseFirestore.instance
        .collection('DatosEntidad')
        .doc(userId)
        .get();
    if (entityDoc.exists) {
      return Colors.green;
    }
    return Colors
        .grey; // Default color if userId not found in either collection
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Usuario no autenticado'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final userData = snapshot.data?.data() as Map<String, dynamic>?;

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
                final List<String> imagePaths =
                    List<String>.from(data['images'] ?? []);
                final timestamp = (data['timestamp'] as Timestamp).toDate();
                final formattedDateTime =
                    DateFormat('dd/MM/yyyy HH:mm').format(timestamp);

                return FutureBuilder<Color>(
                  future: _getUserColor(data['userId']),
                  builder: (context, colorSnapshot) {
                    if (colorSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (colorSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${colorSnapshot.error}'));
                    }
                    final userColor = colorSnapshot.data ?? Colors.grey;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ViewReportPage(reportSnapshot: reports[index]),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: userColor,
                                    backgroundImage: user.photoURL != null
                                        ? NetworkImage(user.photoURL!)
                                        : AssetImage(
                                                'assets/default_profile_picture.png')
                                            as ImageProvider,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${userData?['name'] ?? 'Usuario Desconocido'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ubicación: ${data['ubicacion'] ?? 'No disponible'}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                  'Descripción: ${data['Descripcion'] ?? 'No disponible'}'),
                              const SizedBox(height: 8),
                              Text(
                                '$formattedDateTime',
                                style: TextStyle(fontWeight: FontWeight.w200),
                              ),
                              if (imagePaths.isNotEmpty)
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imagePaths.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(imagePaths[index]),
                                            width: 200,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class GeneralReportsPage extends StatelessWidget {
  const GeneralReportsPage({Key? key}) : super(key: key);

  Future<Color> _getUserColor(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('Usuarios')
        .doc(userId)
        .get();
    if (userDoc.exists) {
      return Colors.blue;
    }
    final entityDoc = await FirebaseFirestore.instance
        .collection('DatosEntidad')
        .doc(userId)
        .get();
    if (entityDoc.exists) {
      return Colors.green;
    }
    return Colors
        .grey; // Default color if userId not found in either collection
  }

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
            final List<String> imagePaths =
                List<String>.from(data['images'] ?? []);
            final timestamp = (data['timestamp'] as Timestamp).toDate();
            final formattedDateTime =
                DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
            final userId = data['userId'];

            return FutureBuilder<Color>(
              future: _getUserColor(userId),
              builder: (context, colorSnapshot) {
                if (colorSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (colorSnapshot.hasError) {
                  return Center(child: Text('Error: ${colorSnapshot.error}'));
                }
                final userColor = colorSnapshot.data ?? Colors.grey;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewReportPage(reportSnapshot: reports[index]),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: userColor,
                                backgroundImage: AssetImage(
                                    'assets/default_profile_picture.png'),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${data['userName'] ?? 'Usuario Desconocido'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ubicación: ${data['ubicacion'] ?? 'No disponible'}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                              'Descripción: ${data['Descripcion'] ?? 'No disponible'}'),
                          const SizedBox(height: 8),
                          Text(
                            '$formattedDateTime',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          if (imagePaths.isNotEmpty)
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imagePaths.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(imagePaths[index]),
                                        width: 200,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
