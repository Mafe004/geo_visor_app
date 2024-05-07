import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotiPro {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  initNotification(){
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token){
      print("--------------TOKEN--------------");
      print(token);
    });
  }
}

