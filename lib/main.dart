import 'package:chat_firebase/pages/home_page.dart';
import 'package:chat_firebase/pages/register_page.dart';
import 'package:chat_firebase/pages/search_page.dart';
import 'package:chat_firebase/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {





  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

           routes: {
             '/': (context)=> const SplashScreen(),
             LoginPage.id: (context)=> const LoginPage(),
             RegisterPage.id: (context)=> const RegisterPage(),
             HomePage.id:(context)=>const HomePage(),
             SearchPage.id:(context)=>const SearchPage(),

           },
        );
  }
}



