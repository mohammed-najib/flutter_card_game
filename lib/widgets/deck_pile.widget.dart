import 'package:flutter/material.dart';

import 'card_back.widget.dart';

class DeckPileWidget extends StatelessWidget {
  final int remaining;
  final double size;
  final bool canDraw;

  const DeckPileWidget({
    super.key,
    required this.remaining,
    this.size = 1,
    this.canDraw = false,
  });

  @override
  Widget build(BuildContext context) {
    return CardBackWidget(
      size: size,
      child: Center(
        child: Text(
          "$remaining",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
