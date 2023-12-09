import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player.model.dart';
import '../providers/thirty_one_game.provider.dart';
import 'card_List.widget.dart';
import 'deck_pile.widget.dart';
import 'discard_pile.widget.dart';
import 'player_info.widget.dart';

class ThirtyOneGameBoardWidget extends StatelessWidget {
  const ThirtyOneGameBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThirtyOneGameProvider>(
      builder: (context, model, child) {
        final currentDeck = model.currentDeck;

        final bottomWidget = model.bottomWidget;

        return currentDeck != null
            ? Column(
                children: [
                  PlayerInfoWidget(
                    turn: model.turn,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await model
                                          .drawCards(model.turn.currentPlayer);
                                    },
                                    child: DeckPileWidget(
                                      remaining: currentDeck.remaining,
                                      // canDraw: true,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  DiscardPileWidget(
                                      cards: model.discards,
                                      onPressed: (card) {
                                        model.drawCardsFromDiscardPile(
                                            model.turn.currentPlayer);
                                        // model.playCard(
                                        //   player: model.turn.currentPlayer,
                                        //   card: card,
                                        // );
                                      }),
                                ],
                              ),
                              if (bottomWidget != null &&
                                  model.showBottomWidget)
                                bottomWidget,
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: CardListWidget(
                            player: model.players[1],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (model.turn.currentPlayer ==
                                        model.players.first)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ...model.additionalButtons
                                              .map((button) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: ElevatedButton(
                                                      onPressed: button.enabled
                                                          ? button.onPressed
                                                          : null,
                                                      child: Text(button.label),
                                                    ),
                                                  )),
                                          // if (model.turn.currentPlayer ==
                                          //     model.players.first)
                                          ElevatedButton(
                                            onPressed: model.canEndTurn
                                                ? () {
                                                    model.endTurn();
                                                  }
                                                : null,
                                            child: const Text('End Turn'),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ),
                              CardListWidget(
                                player: model.players.first,
                                onPlayCard: (card) {
                                  model.playCard(
                                    player: model.players.first,
                                    card: card,
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: TextButton(
                  onPressed: () {
                    final players = [
                      PlayerModel(name: 'Tyler', isHuman: true),
                      PlayerModel(name: 'Bot', isHuman: false),
                    ];

                    model.newGame(players);
                  },
                  child: const Text('New Game?'),
                ),
              );
      },
    );
  }
}
