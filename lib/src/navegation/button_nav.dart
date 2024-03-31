import 'package:flutter/material.dart';

class Bnavigator extends StatefulWidget {
  const Bnavigator({Key? key}) : super(key: key);

  @override
  _BnavigatorState createState() => _BnavigatorState();
}

class _BnavigatorState extends State<Bnavigator> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int i){
        setState(() {

        });
        index = i;
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.indigoAccent,
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
