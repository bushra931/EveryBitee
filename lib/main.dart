import 'package:everybite/profilepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:everybite/homepage.dart';
import 'package:everybite/loginpage.dart';
import 'package:everybite/StartSplashScreen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // <-- Corrected: Added missing `{`
    return MaterialApp(
      title: 'EveryBite',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: const Color.fromARGB(255, 181, 232, 78),
      //   ),
      //   useMaterial3: true,
      // ),
      home: const SplashScreen(),
    );
  } // <-- Corrected: Added missing `}`
}
