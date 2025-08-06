// lib/pages/UserPage.dart
import 'package:flutter/material.dart';
import '../service/AuthService.dart';
import 'package:aie/layouts/LayoutContainer.dart';

class UserPage extends StatelessWidget {
  final User user;

  const UserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
  return LayoutContainer(
      child: Scaffold(
      appBar: AppBar(title: const Text('Witaj')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Imię: ${user.firstName}', style: const TextStyle(fontSize: 18)),
            Text('Nazwisko: ${user.lastName}', style: const TextStyle(fontSize: 18)),
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
            Text('Login: ${user.username}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    ),
    );
  }
}
