import 'dart:io';
import 'package:black_coffer/home_page.dart';
import 'package:black_coffer/otp.dart';
import 'package:black_coffer/phoneIn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyDjNcWrYUHRkB9wXNTqO2cWS8e649OOwag",
          appId: "1:282590785911:android:115cdfd1e8317872b43172",
          messagingSenderId: "282590785911",
          projectId: "blackcoffer1-450ff",
          storageBucket: "blackcoffer1-450ff.appspot.com",
        ))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blackcoffer ClipCloud',
      theme: ThemeData(),
      initialRoute: 'phoneInfo',
      routes: {
        'phoneInfo': (context) => const phoneIn(),
        'otp': (context) => const otp(
              value: "",
            ),
        'home': (context) => const Home(
              valuee: "ss",
            ),
      },
    );
  }
}
