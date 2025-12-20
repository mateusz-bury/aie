import 'package:flutter/material.dart';
import 'package:aie/features/auth/presentation/pages/change_password_page.dart';
import 'package:aie/features/auth/domain/user.dart';

class AccountSettingsPage extends StatelessWidget {
  final User user;

  const AccountSettingsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: const Text('Ustawienia konta')),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Zmień hasło'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Zmień adres e-mail'),
              onTap: () {
                // TODO: API zmiany e-maila
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Usuń konto'),
              onTap: () {
                // TODO: API usunięcia konta
              },
            ),
          ],
        ),
      ),
    );
  }
}
