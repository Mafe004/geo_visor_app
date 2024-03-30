import 'package:flutter/material.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: const Text(
            "Hola",
          ),
        ),
      ),
    );
  }
}