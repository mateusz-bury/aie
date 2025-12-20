import 'package:flutter/material.dart';

/// Globalny layout dla całej aplikacji

class AppLayout extends StatelessWidget {
  final Widget child;
  final String? title;

  const AppLayout({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "AIE"),
        backgroundColor: Colors.blueAccent,
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}