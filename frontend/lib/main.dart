import 'package:aie/pages/StartPage.dart';
import 'package:flutter/material.dart';

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
      home: const StartPage(),
    );
  }
}
