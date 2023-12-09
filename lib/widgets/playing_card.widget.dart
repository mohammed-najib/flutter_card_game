import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/card.model.dart';
import 'card_back.widget.dart';

class PlayingCardWidget extends StatelessWidget {
  final CardModel card;
  final double size;
  final bool visible;
  final Function(CardModel)? onPlayCard;

  const PlayingCardWidget({
    super.key,
    required this.card,
    this.size = 1,
    this.visible = false,
    this.onPlayCard,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPlayCard != null) {
          onPlayCard!(card);
        }
      },
      child: Container(
        width: CARD_WIDTH * size,
        height: CARD_HEIGHT * size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: visible
            ? CachedNetworkImage(
                imageUrl: card.image,
                width: CARD_WIDTH * size,
                height: CARD_HEIGHT * size,
                fit: BoxFit.fill,
              )
            : CardBackWidget(size: size),
      ),
    );
  }
}
