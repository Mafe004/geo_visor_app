import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:http/http.dart' as http;

class PushNotiPro {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void initNotification() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print("--------------TOKEN--------------");
      print(token);
    });
  }

  Future<List<String>> getAllUserTokens() async {
    try {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
      await _firestore.collection('Usuarios').get();

      List<String> tokens = [];

      usersSnapshot.docs.forEach((doc) {
        if (doc.exists) {
          String? token = doc.get('notificationToken');
          if (token != null) {
            tokens.add(token);
          }
        }
      });

      return tokens;
    } catch (e) {
      print('Error obteniendo tokens de usuarios: $e');
      return [];
    }
  }

}
