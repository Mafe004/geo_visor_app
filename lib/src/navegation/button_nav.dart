import 'package:flutter/material.dart';

class Bnavigator extends StatefulWidget {
  const Bnavigator({Key? key}) : super(key: key);

  @override
  _BnavigatorState createState() => _BnavigatorState();
}

class _BnavigatorState extends State<Bnavigator> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Noticias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.accessibility),
          label: 'Mapa',
        ),
      ],
    );
  }
}
