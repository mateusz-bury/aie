import 'package:aie/pages/StartPage.dart';
import 'package:flutter/material.dart';
import 'package:aie/pages/LoginPage.dart';
import 'package:aie/pages/RegisterPage.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIE Application',
      debugShowCheckedModeBanner: false,
      routes: {
    '/login': (_) => const LoginPage(),
    '/register': (_) => const RegisterPage(), // jeśli istnieje
  },
      home: const WelcomePage(),
    );
  }
}
