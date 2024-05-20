import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo_visor_app/src/navegation/register_page.dart';

import '../../main.dart'; // Importa Firestore

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final User? user = userCredential.user;

      if (user != null) {
        // Guarda el token en la información del usuario en Firestore
        final String? token = await FirebaseMessaging.instance.getToken();
        await FirebaseFirestore.instance.collection('Usuarios').doc(user.uid).update({
          'notificationToken': token,
        });

        // Navega al HomeScreen después de iniciar sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), // Cambiar a HomePage
        );
      }
    } catch (e) {
      print(e.toString());

      // Manejar errores de inicio de sesión
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.water,
                size: 100,
              ),
              const SizedBox(height: 50),
              const Text("Bienvenido a geovisor A&S"),
              const SizedBox(height: 25),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'email',
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _signIn,
                child: const Text('Ingresar'),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Aun no tienes usuario?",
                    style: TextStyle(
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      // Navegar a la página de registro cuando se toque el texto
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Registrarse ahora",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}