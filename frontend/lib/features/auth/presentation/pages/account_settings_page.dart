import 'package:flutter/material.dart';
import 'package:aie/features/auth/presentation/pages/change_password_page.dart';
import 'package:aie/features/auth/presentation/pages/change_email_page.dart';
import 'package:aie/features/auth/presentation/pages/delete_account_page.dart';
import 'package:aie/features/auth/domain/user.dart';
import 'package:aie/core/theme/theme_controller.dart';

class AccountSettingsPage extends StatelessWidget {
  final User user;

  const AccountSettingsPage({super.key, required this.user});

  Widget _themeRadio(
    BuildContext context,
    AieThemeKey value,
    String title,
    String subtitle,
  ) {
    return ValueListenableBuilder(
      valueListenable: ThemeController.instance.current,
      builder: (_, current, __) {
        return RadioListTile<AieThemeKey>(
          value: value,
          groupValue: current,
          onChanged: (v) {
            if (v != null) ThemeController.instance.setTheme(v);
          },
          title: Text(title),
          subtitle: Text(subtitle),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onTap: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const ChangeEmailPage()),
              );
              if (changed == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Zmieniono email.')),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Usuń konto'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeleteAccountPage()),
              );
            },
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Wygląd',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          _themeRadio(
            context,
            AieThemeKey.blue,
            'Niebieski (domyślny)',
            'Obecny gradient AIE',
          ),
          _themeRadio(
            context,
            AieThemeKey.red,
            'Czerwony',
            'Czerwony gradient',
          ),
          _themeRadio(context, AieThemeKey.gray, 'Szary techniczny', 'Jasny'),
        ],
      ),
    );
  }
}
