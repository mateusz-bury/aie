import 'package:flutter/material.dart';
import 'package:aie/layouts/LayoutContainer.dart';
import 'package:aie/buttons/Button.dart';

class DiceRollerPage extends StatefulWidget {
  const DiceRollerPage({super.key});

  @override
  State<DiceRollerPage> createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRollerPage> with SingleTickerProviderStateMixin {
  var activeDiceImg = 'assets/images/dice-3.png';
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final diceNumber = (DateTime.now().millisecondsSinceEpoch % 6) + 1;
        setState(() {
          activeDiceImg = 'assets/images/dice-$diceNumber.png';
        });
        _controller.reset();
      }
    });
  }

  void rollDice() {
    _controller.forward(); 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _rotationAnimation,
              child: Image.asset(
                activeDiceImg,
                width: 200,
              ),
            ),
            const SizedBox(height: 100),
            Button(
              'Losuj!',
              onPressed: rollDice,
            ),
          ],
        ),
      ),
    );
  }
}
