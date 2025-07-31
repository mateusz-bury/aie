import 'package:flutter/material.dart';
import 'RegistrationPage.dart';
// void main(){
//   runApp(const MaterialApp(home: Scaffold(body: Text("testowy string sobie tutaj dam"))));
// }

void main() {
  runApp(const MaterialApp(
    home: RegistrationPage(), // ← to ustawia formularz jako ekran startowy
    debugShowCheckedModeBanner: false,
  ));
}
