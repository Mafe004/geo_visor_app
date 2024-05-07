import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotiPro {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initNotification() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print("--------------TOKEN--------------");
      print(token);
      //e0W75xthTHCOY8JdT1EwbN:APA91bHFZTNQRSAbgWevci-YvdlypetTMyRYHbUzzBX3Cdcqgmm_2uoRWiZDIwKI3Vmtxqzb_n8w72KUVb4VOVmxsX-GWjO79S3fq5Pz5TbdRojYwmlokGiGivhOFXDxCx0yWVCmnxzP
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("------onMessage--------");
      print("Notification title: ${message.notification?.title}");
      print("Notification body: ${message.notification?.body}");
      print("Data payload: ${message.data}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("------onLaunch / onResume--------");
      print(message);
    });
  }
}



