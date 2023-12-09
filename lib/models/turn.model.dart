import 'player.model.dart';

class TurnModel {
  final List<PlayerModel> players;
  int index;
  PlayerModel currentPlayer;
  int drawCount;
  int actionCount;

  TurnModel({
    required this.players,
    required this.currentPlayer,
    this.index = 0,
    this.drawCount = 0,
    this.actionCount = 0,
  });

  void nextTurn() {
    index += 1;
    currentPlayer = index % 2 == 0 ? players[0] : players[1];
    drawCount = 0;
    actionCount = 0;
  }

  PlayerModel get otherPlayer =>
      players.firstWhere((p) => p.name != currentPlayer.name);
}
