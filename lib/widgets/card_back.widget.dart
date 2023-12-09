import 'package:flutter/material.dart';

import '../constants.dart';

class CardBackWidget extends StatelessWidget {
  final double size;
  final Widget? child;

  const CardBackWidget({
    super.key,
    this.size = 1,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CARD_WIDTH * size,
      height: CARD_HEIGHT * size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.blueGrey,
      ),
      child: child ?? Container(),
    );
  }
}
