import 'package:flutter/material.dart';

class NotifPage extends StatelessWidget {
  const NotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Example'),
      ),
      body: const Center(
        child: Text(
          'Pagina de notificacion',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
