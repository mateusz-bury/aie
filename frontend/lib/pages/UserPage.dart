import 'package:flutter/material.dart';
import 'package:aie/layouts/LayoutContainer.dart';

class UserPage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String username;

  const UserPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutContainer(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), // Wysokość AppBar
          child: ClipRRect(
            child: AppBar(
              backgroundColor: Colors.blue,
              elevation: 5,
              centerTitle: true,
              title: const Text(
                'Twój profil',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  // topLeft: Radius.circular(30),
                  // topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Dane użytkownika',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              _buildLabel('Imię: $firstName'),
              const SizedBox(height: 12),
              _buildLabel('Nazwisko: $lastName'),
              const SizedBox(height: 12),
              _buildLabel('Email: $email'),
              const SizedBox(height: 12),
              _buildLabel('Nazwa użytkownika: $username'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, color: Colors.black87),
    );
  }
}
