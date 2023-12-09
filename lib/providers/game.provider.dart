import 'package:flutter/material.dart';

import '../constants.dart';
import '../main.dart';
import '../models/card.model.dart';
import '../models/deck.model.dart';
import '../models/player.model.dart';
import '../models/turn.model.dart';
import '../services/deck.service.dart';

class ActionButton {
  final String label;
  final bool enabled;
  final Function() onPressed;

  ActionButton({
    required this.label,
    this.enabled = true,
    required this.onPressed,
  });
}

abstract class GameProvider with ChangeNotifier {
  GameProvider() {
    _service = DeckService();
  }

  late DeckService _service;

  late TurnModel _turn;
  TurnModel get turn => _turn;

  DeckModel? _currentDeck;
  DeckModel? get currentDeck => _currentDeck;

  List<PlayerModel> _players = [];
  List<PlayerModel> get players => _players;

  List<CardModel> _discards = [];
  List<CardModel> get discards => _discards;
  CardModel? get discardTop => _discards.isNotEmpty ? _discards.last : null;

  Map<String, dynamic> gameState = {};

  Widget? bottomWidget;
  List<ActionButton> additionalButtons = [];

  Future<void> newGame(List<PlayerModel> players) async {
    final deck = await _service.newDeck();
    _currentDeck = deck;
    _players = players;
    _discards = [];
    setupBoard();
    _turn = TurnModel(players: _players, currentPlayer: _players.first);

    notifyListeners();
  }

  Future<void> setupBoard() async {}

  Future<void> drawCardToDiscardPile({
    int count = 1,
  }) async {
    final draw = await _service.drawCards(_currentDeck!, count: count);

    _currentDeck!.remaining = draw.remaining;
    _discards.addAll(draw.cards);

    notifyListeners();
  }

  void setBottomWidget(Widget? widget) {
    bottomWidget = widget;

    notifyListeners();
  }

  void setTrump(Suit suit) {
    setBottomWidget(
      Card(
        child: Text(
          CardModel.suitToUnicode(suit),
          style: TextStyle(
            color: CardModel.suitToColor(suit),
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  bool get showBottomWidget => true;

  void setLastPlayedCard(CardModel card) {
    gameState[GS_LAST_SUIT] = card.suit;
    gameState[GS_LAST_VALUE] = card.value;

    setTrump(card.suit);

    notifyListeners();
  }

  bool get canDrawCard {
    if (isGameOver()) return false;

    return _turn.drawCount < 1 && _turn.actionCount == 0;
  }

  Future<void> drawCards(
    PlayerModel player, {
    int count = 1,
    bool allowAnyTime = false,
  }) async {
    final DeckModel? deck = _currentDeck;

    if (deck == null) return;
    if (!allowAnyTime && !canDrawCard) return;

    final draw = await _service.drawCards(deck, count: count);
    player.addCards(draw.cards);

    _turn.drawCount += count;

    _currentDeck!.remaining = draw.remaining;

    notifyListeners();
  }

  bool canPlayCard(CardModel card) {
    if (isGameOver() || _turn.actionCount > 0) return false;

    return true;
  }

  Future<void> playCard({
    required PlayerModel player,
    required CardModel card,
  }) async {
    if (!canPlayCard(card)) return;

    player.removeCard(card);
    _discards.add(card);

    _turn.actionCount += 1;

    setLastPlayedCard(card);

    await applyCardSideEffects(card);

    if (isGameOver()) {
      finishGame();
    }

    notifyListeners();
  }

  bool canDrawCardsFromDiscardPile({int count = 1}) {
    if (isGameOver()) return false;
    if (!canDrawCard) return false;

    return count <= _discards.length;
  }

  void drawCardsFromDiscardPile(
    PlayerModel player, {
    int count = 1,
  }) {
    if (!canDrawCardsFromDiscardPile(count: count)) return;

    // get first x cards
    final start = discards.length - count;
    final end = discards.length;
    final cards = discards.getRange(start, end).toList();
    discards.removeRange(start, end);

    // give them to player
    player.addCards(cards);

    // increment draw count
    _turn.drawCount += count;

    notifyListeners();
  }

  Future<void> applyCardSideEffects(CardModel card) async {}

  bool get canEndTurn => _turn.drawCount > 0;

  void endTurn() {
    _turn.nextTurn();

    if (_turn.currentPlayer.isBot) {
      activateBotTurn();
    }

    notifyListeners();
  }

  void skipTurn() {
    if (_turn.currentPlayer.isBot) {
      _turn.nextTurn();
      activateBotTurn();
    } else {
      _turn.nextTurn();
      _turn.nextTurn();
    }

    notifyListeners();
  }

  bool isGameOver() {
    if (_currentDeck?.remaining == 0) return true;

    return false;
  }

  void finishGame() {
    showToast('Game Over!');

    notifyListeners();
  }

  Future<void> activateBotTurn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    await drawCards(_turn.currentPlayer);
    await Future.delayed(const Duration(milliseconds: 1000));

    if (_turn.currentPlayer.cards.isNotEmpty) {
      playCard(
          player: _turn.currentPlayer, card: _turn.currentPlayer.cards.first);
    }

    if (canEndTurn) {
      endTurn();
    }
  }

  void showToast(
    String message, {
    int seconds = 2,
    SnackBarAction? action,
  }) {
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
        action: action,
      ),
    );
  }
}
