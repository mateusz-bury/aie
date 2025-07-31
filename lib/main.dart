import 'package:flutter/material.dart';
import 'RegistrationPage.dart';
import 'GradientContainer.dart';
import 'LoginPageButton.dart'; // zakładam, że to StyleButton

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
      debugShowCheckedModeBanner: false, // opcjonalnie
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 100, 255),
              Color.fromARGB(255, 100, 200, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoginPageButton(
                'Logowanie',
                onPressed: () {
                  print('Kliknięto logowanie');
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
              const SizedBox(height: 20),
              LoginPageButton(
                'Rejestracja',
                onPressed: () {
                  print('Kliknięto rejestrację');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
