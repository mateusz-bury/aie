import 'package:aie/layouts/LayoutContainer.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'RegistrationPage.dart';
import 'package:aie/buttons/Button.dart';

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
              const SizedBox(height: 20),
              Button(
                'Logowanie',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              Button(
                'Rejestracja',
                onPressed: () {
                  Navigator.push(
                    context
                    ,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
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
