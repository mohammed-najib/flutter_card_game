import 'dart:math';

import 'package:card_game/models/card.model.dart';
import 'package:card_game/models/player.model.dart';

import 'game.provider.dart';

// ignore: constant_identifier_names
const GS_PLAYER_HAS_KNOCKED = 'PLAYER_HAS_KNOCKED';

class ThirtyOneGameProvider extends GameProvider {
  @override
  Future<void> setupBoard() async {
    for (final player in players) {
      await drawCards(player, count: 3, allowAnyTime: true);
    }

    await drawCardToDiscardPile();

    turn.drawCount = 0;
  }

  @override
  Future<void> newGame(List<PlayerModel> players) {
    gameState[GS_PLAYER_HAS_KNOCKED] = null;

    return super.newGame(players);
  }

  @override
  Future<void> drawCardToDiscardPile({int count = 1}) async {
    if (isGameOver()) {
      return;
    }

    return super.drawCardToDiscardPile(count: count);
  }

  @override
  bool get canEndTurn => turn.drawCount == 1 && turn.actionCount == 1;

  @override
  bool get canDrawCard {
    if (isGameOver()) return false;

    return turn.drawCount < 1;
  }

  @override
  bool canPlayCard(CardModel card) {
    if (isGameOver()) return false;

    return turn.drawCount == 1 && turn.actionCount < 1;
  }

  @override
  bool isGameOver() {
    if (gameState[GS_PLAYER_HAS_KNOCKED] != null &&
        gameState[GS_PLAYER_HAS_KNOCKED].name == turn.currentPlayer.name) {
      return true;
    }

    return false;
  }

  @override
  void finishGame() {
    for (final player in players) {
      int diamondPoints = 0;
      int spadePoints = 0;
      int heartPoints = 0;
      int clubPoints = 0;
      for (final card in player.cards) {
        int points = 0;
        switch (card.value) {
          case 'ACE':
            points += 11;
            break;
          case "JACK":
          case 'QUEEN':
          case 'KING':
            points += 10;
            break;
          default:
            points += int.parse(card.value);
        }

        switch (card.suit) {
          case Suit.DIAMONDS:
            diamondPoints += points;
            break;
          case Suit.SPADES:
            spadePoints += points;
            break;
          case Suit.HEARTS:
            heartPoints += points;
            break;
          case Suit.CLUBS:
            clubPoints += points;
            break;
          default:
            break;
        }
      }

      final totalPoints = [diamondPoints, spadePoints, heartPoints, clubPoints]
          .fold(spadePoints, max);

      player.score = totalPoints;
    }

    final winner = players.fold(players.first, (prev, player) {
      if (player.score < prev.score) {
        return player;
      }

      return prev;
    });

    showToast(
      '${winner.name} wins with ${winner.score} points!',
    );
  }

  @override
  bool get showBottomWidget => false;

  @override
  List<ActionButton> get additionalButtons => [
        if (!isGameOver())
          ActionButton(
            label: 'Knock',
            onPressed: () async {
              gameState[GS_PLAYER_HAS_KNOCKED] = turn.currentPlayer;

              endTurn();
            },
          ),
      ];
}
