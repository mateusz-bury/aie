import 'package:flutter/material.dart';

class LoginPageButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LoginPageButton(this.text, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // możesz dopasować
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 74, 118, 238), // ciemnoniebieski
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // zaokrąglenie rogów
          ),
          elevation: 3, // lekki cień
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
