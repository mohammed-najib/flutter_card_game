import 'package:flutter/material.dart';

import '../constants.dart';
import '../main.dart';
import '../models/card.model.dart';
import '../widgets/suit_chooser_modal.widget.dart';
import 'game.provider.dart';

class CrazyEightsGameProvider extends GameProvider {
  @override
  Future<void> setupBoard() async {
    for (final player in players) {
      await drawCards(player, count: 8, allowAnyTime: true);
    }

    await drawCardToDiscardPile();

    setLastPlayedCard(discardTop!);

    turn.drawCount = 0;
    turn.actionCount = 0;
  }

  @override
  bool get canEndTurn {
    if (turn.drawCount > 0 || turn.actionCount > 0) {
      return true;
    }

    return false;
  }

  @override
  bool canPlayCard(CardModel card) {
    bool canPlay = false;

    if (gameState[GS_LAST_SUIT] == null || gameState[GS_LAST_VALUE] == null) {
      return false;
    }

    if (isGameOver() || turn.actionCount > 0) return false;

    if (gameState[GS_LAST_SUIT] == card.suit) {
      canPlay = true;
    } else if (gameState[GS_LAST_VALUE] == card.value) {
      canPlay = true;
    } else if (card.value == '8') {
      canPlay = true;
    }

    return canPlay;
  }

  @override
  Future<void> applyCardSideEffects(CardModel card) async {
    if (card.value == '8') {
      Suit suit;

      if (turn.currentPlayer.isHuman) {
        suit = await showDialog(
          context: navigatorKey.currentContext!,
          builder: (_) => const SuitChooserModal(),
          barrierDismissible: false,
        );
      } else {
        suit = turn.currentPlayer.cards.first.suit;
      }

      showToast(
        '${turn.currentPlayer.name} chose ${CardModel.suitToUnicode(suit)}',
      );

      gameState[GS_LAST_SUIT] = suit;
      setTrump(suit);
    } else if (card.value == '2') {
      await drawCards(
        turn.otherPlayer,
        count: 2,
        allowAnyTime: true,
      );
      showToast(
        '${turn.otherPlayer.name} has to draw 2 cards',
      );
    } else if (card.value == 'QUEEN' && card.suit == Suit.SPADES) {
      await drawCards(
        turn.otherPlayer,
        count: 5,
        allowAnyTime: true,
      );
      showToast(
        '${turn.otherPlayer.name} has to draw 5 cards',
      );
    } else if (card.value == 'JACK') {
      showToast(
        '${turn.otherPlayer.name} has to skip their turn',
      );
      skipTurn();
    }
  }

  @override
  bool isGameOver() {
    if (turn.currentPlayer.cards.isEmpty) {
      return true;
    }

    return false;
  }

  @override
  void finishGame() {
    showToast('Game Over! ${turn.currentPlayer.name} wins!}');

    notifyListeners();
  }

  @override
  Future<void> activateBotTurn() async {
    final player = turn.currentPlayer;

    await Future.delayed(const Duration(milliseconds: 500));

    for (final card in player.cards) {
      if (canPlayCard(card)) {
        await playCard(player: player, card: card);
        endTurn();

        return;
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    await drawCards(player);
    await Future.delayed(const Duration(milliseconds: 500));

    if (!canPlayCard(player.cards.last)) {
      await playCard(player: player, card: player.cards.last);
    }

    endTurn();
  }
}
