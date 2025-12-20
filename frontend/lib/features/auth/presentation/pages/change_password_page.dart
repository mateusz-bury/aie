// lib/pages/ChangePasswordPage.dart
import 'package:flutter/material.dart';
import 'package:aie/features/auth/data/auth_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _showMessage(String message, [Color? color]) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> _submitChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final currentPass = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    try {
      final success = await AuthService.changePassword(
        currentPassword: currentPass,
        newPassword: newPass,
        confirmPassword: confirmPass,
      );

      if (success) {
        _showMessage('Hasło zostało zmienione pomyślnie', Colors.green);
        _formKey.currentState!.reset();
      } else {
        _showMessage('Nie udało się zmienić hasła', Colors.red);
      }
    } catch (e) {
      _showMessage('Błąd: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zmiana hasła'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Obecne hasło'),
                  validator:
                      (v) =>
                          v == null || v.isEmpty
                              ? 'Wprowadź obecne hasło'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Nowe hasło'),
                  validator:
                      (v) =>
                          v == null || v.isEmpty ? 'Wprowadź nowe hasło' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Potwierdź nowe hasło',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Potwierdź nowe hasło';
                    }
                    if (v != _newPasswordController.text) {
                      return 'Hasła nie są identyczne';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitChangePassword,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                          : const Text('Zmień hasło'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
