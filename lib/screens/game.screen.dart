import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player.model.dart';
import '../providers/crazy_eights_game.provider.dart';
import '../widgets/game_board.widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final CrazyEightsGameProvider _gameProvider;

  @override
  void initState() {
    super.initState();

    _gameProvider = Provider.of<CrazyEightsGameProvider>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crazy Eights'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              final players = [
                PlayerModel(name: 'Tyler', isHuman: true),
                PlayerModel(name: 'Bot', isHuman: false),
              ];

              await _gameProvider.newGame(players);
            },
            child: const Text('New Game'),
          ),
        ],
      ),
      body: const GameBoardWidget(),
    );
  }
}
