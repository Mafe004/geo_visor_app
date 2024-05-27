import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo_visor_app/src/features/profile/register_page.dart';
import '../../../main.dart'; // Importa Firestore

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Agregar clave global para validar el formulario
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? _errorText; // Variable para mostrar mensajes de error

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      // Validar los campos de correo electrónico y contraseña
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        final User? user = userCredential.user;

        if (user != null) {
          // Verifica si el usuario está en la colección de Entidades
          final entityDoc = await FirebaseFirestore.instance.collection('DatosEntidad').doc(user.uid).get();
          if (entityDoc.exists) {
            // Es una entidad, guarda el token en la información de la entidad
            final String? token = await FirebaseMessaging.instance.getToken();
            await FirebaseFirestore.instance.collection('DatosEntidad').doc(user.uid).update({
              'notificationToken': token,
            });
            // Navega a la página específica de entidades
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()), // Cambiar a la página de entidad
            );
          } else {
            // Verifica si el usuario está en la colección de Usuarios
            final userDoc = await FirebaseFirestore.instance.collection('Usuarios').doc(user.uid).get();
            if (userDoc.exists) {
              // Es un usuario normal, guarda el token en la información del usuario
              final String? token = await FirebaseMessaging.instance.getToken();
              await FirebaseFirestore.instance.collection('Usuarios').doc(user.uid).update({
                'notificationToken': token,
              });
              // Navega a la página específica de usuarios
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()), // Cambiar a HomePage
              );
            } else {
              setState(() {
                _errorText = 'No se encontró el tipo de usuario.';
              });
            }
          }
        }
      } catch (e) {
        setState(() {
          _errorText = 'Error al iniciar sesión. Por favor, verifica tus credenciales.';
        });
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey, // Usar la clave global para validar el formulario
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
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu correo electrónico.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Correo electrónico',
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
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña.';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Contraseña',
                    hintStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                if (_errorText != null) // Mostrar mensaje de error si existe
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      _errorText!,
                      style: const TextStyle(color: Colors.red),
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
                    const Text(
                      "¿No tienes usuario?",
                      style: TextStyle(),
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
                        "Regístrate ahora",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Navegar a la página de restablecimiento de contraseña cuando se toque el texto

                  },
                  child: const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

