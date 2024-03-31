import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information Example'),
      ),
      body: const Center(
        child: Text(
          'Pagina para informacion',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
