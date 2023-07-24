import 'package:flutter/material.dart';

import 'package:hearts_scorer/models.dart';

/*
This screen is the main interactive area; it displays each player's current
score in a card, and has a button taking us to the ScoreRoundScreen,
allowing us to score the current Round.
 */
class GameMainScreen extends StatelessWidget {
  final Game game;
  const GameMainScreen({super.key, required this.game});

  static const passText = [
    "Left",
    "Two to the left",
    "Three to the left",
    "Across",
    "Three to the right",
    "Two to the right",
    "Right",
    "Hold 'em"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Pass: ${passText[game.currentPass().index]}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ]
      ),
      body: Center(
        child: GridView.builder(
          itemCount: game.players.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Text('${game.players[index].name}: 0');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Navigate to ScoreRoundScreen");
        },
        tooltip: 'Score!',
        child: const Icon(Icons.add_circle),
      ),
    );
  }
}
