import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token;
  static StreamController<Map> _messageStream =
      new StreamController.broadcast();
  static Stream<Map> get messagesStream => _messageStream.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    print("background Handler ${message.messageId}");
    _messageStream.add(message.data ?? 'No data');
  }

  static Future _onMessagedHandler(RemoteMessage message) async {
    print("message Handler ${message.messageId}");

  }



  static Future _onMessageOpenHandler(RemoteMessage message) async {
    print("background Handler ${message.messageId}");
    _messageStream.add(message.data ?? 'No data');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    await getPermissions();
    token = await FirebaseMessaging.instance.getToken();
    // print(token);
    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessagedHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenHandler);
    // return token;
       

    
  }

  static Future getPermissions() async {

      NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    

    print('User granted permission: ${settings.authorizationStatus}');
    // return token;
  }

  static Future getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  static closeStreams() {
    _messageStream.close();
  }
}




// import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:sindicatos/firebase_options.dart';

// class PushNotificationService {
//   static FirebaseMessaging messaging = FirebaseMessaging.instance;
//   static String token;
//   static StreamController<Map> _messageStream =
//       new StreamController.broadcast();
//   static Stream<Map> get messagesStream => _messageStream.stream;

//   static Future _onBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     print("background Handler ${message.messageId}");
//     _messageStream.add(message.data ?? 'No data');
//   }

//   static Future _onMessagedHandler(RemoteMessage message) async {
//     print("message Handler ${message.notification?.title}");
 
//   }

//   static Future _onMessageOpenHandler(RemoteMessage message) async {
//     print("background Handler ${message.messageId}");
//     _messageStream.add(message.data ?? 'No data');
//   }

//   static Future initializeApp() async {
//     await Firebase.initializeApp();
//     messaging = FirebaseMessaging.instance;
//     token = await FirebaseMessaging.instance.getToken();
//     print(token);
//     // Handlers
//     FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
//     FirebaseMessaging.onMessage.listen(_onMessagedHandler);
    
//     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenHandler);

//             // Request permission to receive notifications

//   }

//   static Future getToken() async {
//     token = await FirebaseMessaging.instance.getToken();

//     print(token);
//     return token;
//   }

//   static closeStreams() {
//     _messageStream.close();
//   }
// }

