import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/navegation/text_field.dart';

import 'button.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  //txt edit control
  final emailTextcontroller = TextEditingController();
  final passwordTextcontroller = TextEditingController();
  final confirmPasswordTextcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //logo
              const Icon(
                Icons.water,
                size: 100,
              ),

              const SizedBox(height: 50),

              //Msg
              const Text("Crear Cuenta",
              ),

              const SizedBox(height: 25),

              //emailtxt
              MyTextField(
                controller: emailTextcontroller,
                hintText: 'email',
                obscureText: false,
              ),

              const SizedBox(height: 10),
              //pswtxt
              MyTextField(
                controller: passwordTextcontroller,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              //confirmpswtxt
              MyTextField(
                controller: confirmPasswordTextcontroller,
                hintText: 'Confirmar Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),
              //sign in btn
              MyButton(
                onTap: (){},
                text: 'Registrar',
              ),

              const SizedBox(height: 25),

              //register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ya tienes cuenta?",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Ingresar ahora",
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
