import 'package:flutter/material.dart';
import 'package:aie/core/layout/app_layout.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:aie/features/home/presentation/pages/user_page.dart';

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
        _showError('Nieprawidlowy login lub haslo');
      }
    } catch (e) {
      _showError('Blad logowania: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                      'Zaloguj sie',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Login',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Wprowadz login' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Haslo',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Wprowadz haslo' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitLogin,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Zaloguj'),
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
