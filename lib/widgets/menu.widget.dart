import 'package:flutter/material.dart';

import '../screens/game.screen.dart';
import '../screens/thirty_one_game.screen.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const GameScreen(),
              )),
              child: const Text('Crazy Eights'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ThirtyOneGameScreen(),
              )),
              child: const Text('Thirty One'),
            ),
          ],
        ),
      ),
    );
  }
}
