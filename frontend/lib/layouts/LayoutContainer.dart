import 'package:flutter/material.dart';
import 'package:aie/pages/DiceRollerPage.dart';
import 'package:aie/pages/StartPage.dart';

class LayoutContainer extends StatelessWidget {
  final Widget child;

  const LayoutContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 100, 255),
            Color.fromARGB(255, 100, 200, 255),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartPage()),
                    );
                  },
                  child: Image.asset('assets/images/aie_3.png'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiceRollerPage(),
                      ),
                    );
                  },
                  child: Image.asset('assets/images/dice.png', width: 50),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
