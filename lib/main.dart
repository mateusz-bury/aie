import 'package:aie/pages/startPage.dart';
import 'package:flutter/material.dart';
import 'package:aie/pages/UserPage.dart';
void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: UserPage(
        firstName: 'Jan',
        lastName: 'Kowalski',
        email: 'jan.kowalski@example.com',
        username: 'jankowal',
      ),
    );
  }
}


