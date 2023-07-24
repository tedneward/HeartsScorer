import 'package:flutter/material.dart';

import 'package:hearts_scorer/models.dart';

/*
This screen displays a history of the game's rounds, showing how each player
fared in each round of the game.

Get here from the GameMainScreen. Goes back to same.
 */
class GameHistoryScreen extends StatelessWidget {
  final Game game;

  const GameHistoryScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      //passing in the ListView.builder
      body: ListView.builder(
        itemCount: game.history.length,
        itemBuilder: (context, index) {
          return const ListTile(
            title: Text('Round summary goes in here'),
          );
        },
      ),
    );
  }
}
