import 'package:flutter/material.dart';

import 'package:hearts_scorer/models/models.dart';
import 'package:hearts_scorer/ui/score_round.dart';

/*
This screen is the main interactive area; it displays each player's current
score in a card, and has a button taking us to the ScoreRoundScreen,
allowing us to score the current Round.

Layout thoughts:

      Pass: Across

Ted: 24         Charlotte: 33

**Michael**: 26 Matthew: 14

                        (+)
 */
class GameMainScreen extends StatefulWidget {
  final Game game;
  const GameMainScreen({super.key, required this.game});

  @override
  _GameMainState createState() => _GameMainState(game);
}
class _GameMainState extends State<GameMainScreen> {
  final Game game;
  _GameMainState(this.game);

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
            icon: const Icon(Icons.help),
            tooltip: 'Help',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Push the "+" button to score a round')));
            },
          ),
        ]
      ),
      body: Center(
        child: GridView.builder(
          itemCount: game.players.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return PlayerCurrentScoreTile(
                name: game.players[index].name,
                score: game.scoreFor(game.players[index].name),
                dealer: game.dealerIdx() == index
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (game.gameOver() ? null : () {
          final result = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScoreRoundScreen(game: game),
            ),
          );
          result.then((value) => setState( () => game.history.add(value) ) );
        }),
        tooltip: 'Score!',
        child: const Icon(Icons.add_circle),
      ),
    );
  }
}
class PlayerCurrentScoreTile extends StatelessWidget {
  final String name;
  final int score;
  final bool dealer;
  const PlayerCurrentScoreTile({super.key, required this.name, required this.score, this.dealer = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Wrap the ListTile in a Material widget so the ListTile has someplace
      // to draw the animated colors during the hero transition.
      child: Center(
        child: ListTile(
          title: Text(name),
          titleTextStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: dealer ? FontWeight.bold  : FontWeight.normal,
            fontStyle: dealer ? FontStyle.italic : FontStyle.normal,
            fontSize: 24
          ),
          tileColor: Theme.of(context).cardTheme.color,
          subtitle: Text(score.toString()),
          subtitleTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 20
          ),
        )
      )
    );
  }
}