import 'package:flutter/material.dart';
import 'package:aie/service/AuthService.dart';
import 'UserPage.dart';
import 'package:aie/layouts/AppLayout.dart';

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
    return AppLayout(
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
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Login', labelStyle: TextStyle(color: Colors.white)),
                      validator:
                          (v) =>
                              v == null || v.isEmpty ? 'Wprowadź login' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Hasło', labelStyle: TextStyle(color: Colors.white)),
                      validator:
                          (v) =>
                              v == null || v.isEmpty ? 'Wprowadź hasło' : null,
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitLogin,
                      child: const Text("Zaloguj"),
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
