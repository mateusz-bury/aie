import 'package:flutter/material.dart';
import 'package:aie/features/auth/presentation/pages/login_page.dart';
import 'package:aie/features/auth/presentation/pages/register_page.dart';
import 'package:aie/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:aie/core/theme/app_theme.dart';

class AieApp extends StatelessWidget {
  const AieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIE Application',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
      },
      home: const WelcomePage(),
    );
  }
}
