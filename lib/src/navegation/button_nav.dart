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
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Noti',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.accessibility),
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Repo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_alert),
          label: 'Noti',
        ),
      ],
    );
  }
}
