// lib/pages/StartPage.dart
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'package:aie/layouts/LayoutContainer.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text(
                  'Logowanie',
                  style:TextStyle(
                    color: Colors.black
                  ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
