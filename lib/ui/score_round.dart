import 'package:flutter/material.dart';

import 'package:hearts_scorer/models/models.dart';

/*
This screen displays each player and allows input for hearts, queen (boolean),
and jack(boolean, visible only if Game.jackOn is true).

Layout thoughts:

Ted:           Charlotte:
o-------- 0    o--------  0
(*  )  Q  0    (  *)  Q  13
(*  )  J  0    (  *)  J -10
--------  0    ---------  3

Michael:        Matthew:
---o------ 5    o----o--   8
(*  )   Q  0    (*  )  Q  13
(*  )   J  0    (*  )  J -10
---------  5    ---------  3

          [Score!]

Score button only enabled if the round is "good" (legit)
Score button returns to the GameMainScreen.
 */
class ScoreRoundScreen extends StatefulWidget {
  final Game game;
  ScoreRoundScreen({super.key, required this.game});

  @override
  ScoreRoundState createState() => ScoreRoundState(game: game);
}

class ScoreRoundState extends State<ScoreRoundScreen> {
  late final Game game;
  late final Round round;

  ScoreRoundState({required this.game}) {
    this.round = Round(this.game);
    this.round.cards.entries.forEach( (entry) { entry.value.hearts = 0; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Score"),
        actions: [
          ElevatedButton.icon(
            onPressed: (round.good() ? () {
              print("Popping back to GameMainScreen");
              Navigator.pop(context, round);
            } : null),
            icon: Icon(Icons.add_comment),
            label: Text("Score It!")
          )
        ],
      ),
      body: ListView.builder(
        itemCount: this.game.players.length,
        itemBuilder: (context, index) {
          return Card(
            // Wrap the ListTile in a Material widget so the ListTile has someplace
            // to draw the animated colors during the hero transition.
              child: Center(
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(game.players[index].name),
                            Flexible(child: Text(round.pointsFor(game.players[index].name).toString())),
                          ],
                        ),
                        titleTextStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24
                        ),
                        tileColor: Theme.of(context).cardTheme.color,
                      ),
                      Slider(
                        value: round.cards[game.players[index].name]!.hearts.toDouble(),
                        min: 0,
                        max: 13,
                        divisions: 13,
                        label: round.cards[game.players[index].name]!.hearts.toString(),
                        onChanged: (double value) {
                          setState(() { round.cards[game.players[index].name]!.hearts = value.toInt(); });
                        },
                      ),
                      SwitchListTile(
                        value: round.cards[game.players[index].name]!.queen,
                        onChanged: (bool? value) { setState(() { round.cards[game.players[index].name]!.queen = value!; }); },
                        title: const Text('Queen of Spades'),
                      ),
                      if (round.game.jackOn case true) SwitchListTile(
                        value: round.cards[game.players[index].name]!.jack,
                        onChanged: (bool? value) { setState(() { round.cards[game.players[index].name]!.jack = value!; }); },
                        title: const Text('Jack of Diamonds'),
                      ),
                    ],
                  )
              )
          );
        }
      )
    );
  }
}
