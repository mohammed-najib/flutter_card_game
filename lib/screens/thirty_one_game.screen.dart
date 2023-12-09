import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player.model.dart';
import '../providers/thirty_one_game.provider.dart';
import '../widgets/thirty_one_game_board.widget.dart';

class ThirtyOneGameScreen extends StatefulWidget {
  const ThirtyOneGameScreen({super.key});

  @override
  State<ThirtyOneGameScreen> createState() => _ThirtyOneGameScreenState();
}

class _ThirtyOneGameScreenState extends State<ThirtyOneGameScreen> {
  late final ThirtyOneGameProvider _gameProvider;

  @override
  void initState() {
    super.initState();

    _gameProvider = Provider.of<ThirtyOneGameProvider>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thirty One'),
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
      body: const ThirtyOneGameBoardWidget(),
    );
  }
}
