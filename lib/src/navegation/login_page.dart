import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/navegation/button.dart';
import 'package:geo_visor_app/src/navegation/text_field.dart';
    
    class LoginPage extends StatefulWidget {
      final Function()? onTap;
      const LoginPage({super.key, required this.onTap});
    
      @override
      State<LoginPage> createState() => _LoginPageState();
    }
    
    class _LoginPageState extends State<LoginPage> {

      //txt edit control
      final emailTextcontroller = TextEditingController();
      final passwordTextcontroller = TextEditingController();

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
              const Text("Bienvenido a geovisor A&S",
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
                  
                  //sign in btn
                  MyButton(
                      onTap: (){},
                      text: 'Ingresar',
                  ),

                  const SizedBox(height: 25),

                  //register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Aun no tienes usuario?",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
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
    