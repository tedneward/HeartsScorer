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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Text('Player $index');
        },
      ),
    );
  }
}
