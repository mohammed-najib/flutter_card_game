import 'card.model.dart';

class PlayerModel {
  final String name;
  final bool isHuman;
  List<CardModel> cards;
  int score;

  PlayerModel({
    required this.name,
    this.isHuman = false,
    this.cards = const [],
    this.score = 0,
  });

  void addCards(List<CardModel> newCards) {
    cards = [...cards, ...newCards];
  }

  void removeCard(CardModel card) {
    cards.removeWhere(
      (element) => element.value == card.value && element.suit == card.suit,
    );
  }

  bool get isBot => !isHuman;
}
