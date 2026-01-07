import 'package:flutter/material.dart';
import 'package:aie/core/widgets/aie_background.dart';

/// Globalny layout dla całej aplikacji

class AppLayout extends StatelessWidget {
  final Widget child;
  final String? title;

  const AppLayout({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "AIE"),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: AieBackground(child: child),
    );
  }
}