import 'package:flutter/material.dart';

class StyleText extends StatelessWidget {
  StyleText(this.text, {super.key});

  final String text;

  @override
  Widget build(context) {
    return 

    Text(
      this.text,
      style: TextStyle(
        color: Colors.black, 
        fontSize: 30),
    );
   }
}
