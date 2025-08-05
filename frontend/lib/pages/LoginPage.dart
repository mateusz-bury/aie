// lib/pages/LoginPage.dart
import 'package:flutter/material.dart';
import '../service/AuthService.dart';
import 'UserPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await AuthService.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      final user = AuthService.getCurrentUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserPage(user: user!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nieprawidłowy login lub hasło')),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Logowanie',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Login'),
                  validator: (v) => v == null || v.isEmpty ? 'Wprowadź login' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Hasło'),
                  obscureText: true,
                  validator: (v) => v == null || v.isEmpty ? 'Wprowadź hasło' : null,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Zaloguj się'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
