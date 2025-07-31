import 'package:flutter/material.dart';
import 'StyleText.dart';

var beginPosition = Alignment.topLeft;
var endPosition = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key});

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
             Color.fromARGB(255, 0, 100, 255),
             Color.fromARGB(255, 100, 200, 255),
          ],
          begin: beginPosition,
          end: endPosition,
        ),
      ),
      child: Center(
        child: StyleText("Logowanie")),
    );
  }
}
