import 'package:cooking/screen/add_cooking_menu.dart';
import 'package:cooking/screen/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   NotificationSettings settings = await FirebaseMessaging.instance
//       .requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         criticalAlert: false,
//         provisional: false,
//         sound: false,
//       );

//   //notification permission
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
// flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//     AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

//   print('User granted premission:${settings.authorizationStatus}');
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Got a message whilist in the foreground');
//     print('Message data: ${message.data}');

//     if (message.notification != null) {
//       print(
//         'Message also contained a notification: ${message.notification?.title}',
//       );
//     }
//   });

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   runApp(const MyApp());
// }

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(
        alert: true,

        announcement: false,

        badge: true,

        carPlay: false,

        criticalAlert: false,

        provisional: false,

        sound: true,
      );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  var token = await FirebaseMessaging.instance.getToken();

  print(token);

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');

    print('Message data: ${message.data}');

    if (message.notification != null) {
      print(
        'Message also contained a notification: ${message.notification?.title}',
      );
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

void showNoti(RemoteMessage message) async {
  print(message.notification!.title);

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'your_channel_id',

        'your_channel_name',

        importance: Importance.max,

        priority: Priority.high,

        showWhen: false,
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,

    message.notification?.body,
    platformChannelSpecifics,
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,

  // make sure you call `initializeApp` before using other Firebase services.

  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Material App Bar')),
        body: Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  Body({super.key});
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    return Column(
      children: [
        TextField(controller: emailcontroller),
        TextField(controller: passwordcontroller),
        ElevatedButton(
          onPressed: () async {
            try {
              final credential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                    email: emailcontroller.text,
                    password: passwordcontroller.text,
                  );
              print(credential);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                print('No user found for that email.');
              } else if (e.code == 'wrong-password') {
                print('Wrong password provided for that user.');
              }
            }
          },
          child: Text('login'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCookingMenu()),
            );
          },
          child: Text('Add chicken'),
        ),
        ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: Text('logout'),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Signupscreen()),
            );
          },
          child: Text('Sign up'),
        ),
      ],
    );
  }
}
