import 'package:flutter/material.dart';

import 'package:hearts_scorer/models/models.dart';
import 'package:hearts_scorer/ui/score_round.dart';

/*
This screen displays a history of the game's rounds, showing how each player
fared in each round of the game.

Get here from the GameMainScreen. Goes back to same.

Can open a ScoreRoundScreen to edit an existing round, in case there's a mistake.
 */
class GameHistoryScreen extends StatelessWidget {
  final Game game;

  const GameHistoryScreen({super.key, required this.game});

  String summaryText(Round round, String playername) {
    return "${round.cards[playername]!.hearts}${(round.cards[playername]!.queen) ? "Q" : ""}${(game.jackOn && round.cards[playername]!.jack) ? "J" : ""}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Round History'),),
      body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: game.history.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                height: 50,
                child: Row(
                  children: List<Widget>.generate(game.players.length,
                    (index) => Expanded(
                      child: Center(child: Text(game.players[index].name, style: const TextStyle(fontWeight: FontWeight.bold)))
                    )
                  ) + [
                    const Text("  Edit   ") // spaces are a crude man's spacing
                  ]
                ),
              );
            }
            else {
              return Container(
                  height: 50,
                  child: Row(
                    children: List<Widget>.generate(game.players.length,
                      (playerindex) => Expanded(
                        child: Center(child: Text(summaryText(game.history[index - 1], game.players[playerindex].name)))
                      )
                    ) + [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScoreRoundScreen.editRound(game: game, round: game.history[index - 1]),
                            )
                        );
                      },
                      icon: const Icon(Icons.edit))
                    ]
                  ),
              );
            }
          },
          separatorBuilder: (BuildContext context, int index) => const Divider()
      )
    );
  }
}


// This isn't used anymore
/*Row buildRoundRow(Round round) {
    return Row(
      children:
        List<Widget>.generate(game.players.length, (index) => Expanded(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                height: 20,
                child: Center(
                  child: Row(
                    children: [
                      Center( child: Text(summaryText(round, game.players[index].name))),
                    ]
                  )
                )
              ),
            ],
          )
        ),
      ) + [
        IconButton(
          onPressed: () {
            print("Edit round ${round}");
          },
          icon: const Icon(Icons.edit))
      ]
    );
  } */

/*
ListView.builder(
        itemCount: game.history.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(title:
              Row(
                children:
                List<Widget>.generate(game.players.length, (index) => Expanded(child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 20,
                          child: Center(
                              child: Row(
                                  children: [
                                    Center( child: Text(game.players[index].name)),
                                  ]
                              )
                          )
                        ),
                      ],
                    )
                  ),
                )
              )
            );
          } else {
            return ListTile(title: buildRoundRow(game.history[index-1]));
          }
        },
      )
 */