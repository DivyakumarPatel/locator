// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_locator/provider/location_provider.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'google_maps_page.dart';


//create android channel for notifications
AndroidNotificationChannel channel = AndroidNotificationChannel(
    "High importance", "High important notifications ",
    //"This channel is used for important notifications",
    importance: Importance.max,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

//called when app is in terminated mode
Future<void> _firebaseNotificationHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log(message.messageId.toString());
}


void main() async{

   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
//initialize hydrated bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
//initialize firebase notifications and local notifications
   FirebaseMessaging.onBackgroundMessage(_firebaseNotificationHandler);
   await flutterLocalNotificationsPlugin
       .resolvePlatformSpecificImplementation<
       AndroidFlutterLocalNotificationsPlugin>()
       ?.createNotificationChannel(channel);

   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
       alert: true, badge: true, sound: true);
  
  runApp(MyApp() );
}

class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
//instantiates a listener for the app to listen to the notifications
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      RemoteNotification? notification = message?.notification;
      AndroidNotification? android = message?.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              icon: "logo",
            ),
          ),
        );
      }
    });
//handles messages on app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(" A new message on message");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              icon: "logo",
            ),
          ),
        );
      }
    });
//handles messages on app in background and not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(" A new message onmessageopenned app");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: Text(notification.body.toString()),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleMapPage(),
    );
  }
}
