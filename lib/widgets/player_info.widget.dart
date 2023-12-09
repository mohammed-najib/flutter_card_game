import 'package:flutter/material.dart';

import '../models/turn.model.dart';

class PlayerInfoWidget extends StatelessWidget {
  final TurnModel turn;

  const PlayerInfoWidget({
    super.key,
    required this.turn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      width: double.infinity,
      height: 32,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: turn.players.map((player) {
            final isCurrentPlayer = turn.currentPlayer.name == player.name;

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: isCurrentPlayer ? Colors.white : Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text("${player.name} [${player.cards.length}]",
                    style: TextStyle(
                      color: isCurrentPlayer ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
