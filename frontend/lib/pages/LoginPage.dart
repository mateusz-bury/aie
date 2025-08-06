// lib/pages/LoginPage.dart
import 'package:flutter/material.dart';
import 'package:aie/service/AuthService.dart';
import 'UserPage.dart';
import 'package:aie/layouts/LayoutContainer.dart';
import 'package:aie/buttons/Button.dart';

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

    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final user = await AuthService.login(username, password);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserPage(user: user)),
        );
      } else {
        _showError('Nieprawidłowy login lub hasło');
      }
    } catch (e) {
      _showError('Błąd logowania: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    const Text(
                      'Zaloguj się', 
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black
                        )),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: const TextStyle(color:Colors.black),
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Login'),
                      validator:
                          (v) =>
                              v == null || v.isEmpty ? 'Wprowadź login' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      style: const TextStyle(color:Colors.black),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Hasło'),
                      validator:
                          (v) =>
                              v == null || v.isEmpty ? 'Wprowadź hasło' : null,
                    ),
                    
                    const SizedBox(height: 20),
                    Button(
                      'Zaloguj',
                      onPressed: _submitLogin,
                      isLoading: _isLoading, 
                    ), 
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
