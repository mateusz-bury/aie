// import 'package:flutter/material.dart';
// import 'LoginPage.dart';
// import 'RegistrationPage.dart';

// class StartPage extends StatelessWidget {
//   const StartPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 40),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const LoginPage()),
//                   );
//                 },
//                 child: const Text(
//                   'Logowanie',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const RegisterPage()),
//                   );
//                 },
//                 child: const Text(
//                   'Rejestracja',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E3A59), Color(0xFF1B2433)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // GÓRNA CZĘŚĆ
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: const [
                    Icon(Icons.shield, size: 100, color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      "Witaj w AIE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Twórz kampanie, postacie i zarządzaj swoją przygodą RPG w jednym miejscu.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ŚRODKOWE PRZYCISKI
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          "Zaloguj się",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          "Zarejestruj się",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // STOPKA
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  "© 2025 AIE – All rights reserved",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

