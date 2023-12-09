import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/card.model.dart';
import '../models/player.model.dart';
import 'playing_card.widget.dart';

class CardListWidget extends StatelessWidget {
  final double size;
  final PlayerModel player;
  final Function(CardModel)? onPlayCard;

  const CardListWidget({
    super.key,
    required this.player,
    this.size = 1,
    this.onPlayCard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CARD_HEIGHT * size,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: player.cards.length,
          itemBuilder: (context, index) {
            final card = player.cards[index];

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: PlayingCardWidget(
                card: card,
                size: size,
                visible: player.isHuman,
                onPlayCard: onPlayCard,
              ),
            );
          },
        ),
      ),
    );
  }
}
