import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/card.model.dart';
import 'playing_card.widget.dart';

class DiscardPileWidget extends StatelessWidget {
  final List<CardModel> cards;
  final double size;
  final Function(CardModel)? onPressed;

  const DiscardPileWidget({
    super.key,
    required this.cards,
    this.size = 1,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!(cards.last);
        }
      },
      child: Container(
        width: CARD_WIDTH * size,
        height: CARD_HEIGHT * size,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black45,
            width: 2,
          ),
        ),
        child: IgnorePointer(
          ignoring: true,
          child: Stack(
            children: cards
                .map((card) => PlayingCardWidget(
                      card: card,
                      visible: true,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
