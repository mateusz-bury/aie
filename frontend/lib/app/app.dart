import 'package:flutter/material.dart';
import 'package:aie/features/auth/presentation/pages/login_page.dart';
import 'package:aie/features/auth/presentation/pages/register_page.dart';
import 'package:aie/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:aie/core/theme/theme_controller.dart';

class AieApp extends StatefulWidget {
  const AieApp({super.key});

  @override
  State<AieApp> createState() => _AieAppState();
}

class _AieAppState extends State<AieApp> {
  @override
  void initState() {
    super.initState();
    ThemeController.instance.load();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeController.instance.current,
      builder: (_, __, ___) {
        return MaterialApp(
          title: 'AIE Application',
          debugShowCheckedModeBanner: false,
          theme: ThemeController.instance.themeData,
          routes: {
            '/login': (_) => const LoginPage(),
            '/register': (_) => const RegisterPage(),
          },
          home: const WelcomePage(),
        );
      },
    );
  }
}
