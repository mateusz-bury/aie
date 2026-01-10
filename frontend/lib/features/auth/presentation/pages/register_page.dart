import 'package:flutter/material.dart';
import 'package:aie/core/layout/app_layout.dart';
import 'package:aie/core/theme/app_colors.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:aie/features/auth/presentation/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool _loading = false;

  Future<void> _submitRegister() async {
    if (_loading) return;
    setState(() => _loading = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final repeatPassword = _repeatPasswordController.text.trim();

    final result = await AuthService.register(
      firstName: name,
      lastName: '–',
      email: email,
      username: email.contains('@') ? email.split('@')[0] : email,
      password: password,
      repeatPassword: repeatPassword,
    );

    setState(() => _loading = false);

    if (!mounted) return;

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konto utworzone. Możesz się zalogować.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    final msg = result.message ?? 'Nie udało się zarejestrować.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.accent),
      filled: true,
      fillColor: AppColors.surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Rejestracja',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        'Utwórz konto',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nameController,
                        decoration: _decoration('Imię', Icons.person),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty) ? 'Podaj imię' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _emailController,
                        decoration: _decoration('Email', Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return 'Podaj email';
                          if (!v.contains('@')) return 'Podaj poprawny email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _passwordController,
                        decoration: _decoration('Hasło', Icons.lock),
                        obscureText: true,
                        validator: (value) {
                          final v = (value ?? '');
                          if (v.length < 6) return 'Hasło musi mieć min. 6 znaków';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _repeatPasswordController,
                        decoration: _decoration('Powtórz hasło', Icons.lock_outline),
                        obscureText: true,
                        validator: (value) {
                          final v = (value ?? '');
                          if (v != _passwordController.text) return 'Hasła muszą być takie same';
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _loading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _submitRegister();
                                  }
                                },
                          icon: _loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.person_add),
                          label: Text(_loading ? 'Rejestruję...' : 'Zarejestruj się'),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        },
                        child: const Text('Mam już konto — Zaloguj się'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}