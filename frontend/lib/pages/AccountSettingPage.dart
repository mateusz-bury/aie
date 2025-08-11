// lib/pages/AccountSettingsPage.dart
import 'package:flutter/material.dart';
import '../service/AuthService.dart';
import 'package:aie/layouts/LayoutContainer.dart';

class AccountSettingsPage extends StatelessWidget {
  final User user;

  const AccountSettingsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return LayoutContainer(
      child: Scaffold(
        appBar: AppBar(title: const Text('Ustawienia konta')),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Zmień hasło'),
              onTap: () {
                // TODO: API zmiany hasła
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
