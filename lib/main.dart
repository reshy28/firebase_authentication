import 'package:drawer/view/homescreen/homescreen.dart';
import 'package:drawer/view/homescreen/loginScreen/loginScreen.dart';
import 'package:drawer/view/splashscreen/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAMPjFoE-dsenQcaZ-WpWnKsArQwzx1hoI",
          appId: "sampleproject-d1dfc",
          messagingSenderId: "",
          projectId: "sampleproject-d1dfc",
          storageBucket: "sampleproject-d1dfc.appspot.com"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        //login set cheyunadh
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Homescreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
