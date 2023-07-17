import 'package:flutter/material.dart';

import 'models.dart';

class ScoreHandDialog extends StatefulWidget {
  ScoreHandDialog({
    Key key,
    this.game,
  }): super(key: key);

  final Game game;

  @override
  _ScoreHandDialogState createState() => new _ScoreHandDialogState(game);
}

class _ScoreHandDialogState extends State<ScoreHandDialog> {

  final Game _game;
  Hand _hand;

  _ScoreHandDialogState(this._game) {
    _hand = Hand(game: _game);
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: buildPlayerRows()
      )
    );
  }

  List<Widget> buildPlayerRows() {
    List<Widget> rows = [];
    rows.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("Player"),
        Text("Hearts"),
        Text("Queen"),
        Text("Jack")
      ]
    ));
    rows.addAll(_game.players.map( (player) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("${player.name} "),
            DropdownButton<int>(
                value: _hand.scores[player].hearts,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(height: 2, color: Colors.deepPurpleAccent,),
                onChanged: (int newValue) {
                  setState(() {
                    print("${player.name} takes ${newValue} hearts; Hand = $_hand");
                    _hand.scores[player].hearts = newValue;
                  });
                },
                items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
            ),
            Switch(
              value: false,
              onChanged: (newValue) {
                setState( () {
                  _hand.scores.forEach( (player, score) => score.queen = false );
                  _hand.scores[player].queen = true;
                });
              }
            ),
            Switch(
              value: false,
              onChanged: (newValue) {
                setState( () {
                  _hand.scores.forEach( (player, score) => score.jack = false );
                  _hand.scores[player].jack = true;
                });
              }
            )
          ]
      );
    }));
    rows.add(
        ButtonBar(
          children: <Widget>[
            new RaisedButton(
                child: const Text('OK'),
                onPressed: (_hand.validate())
                    ? () { Navigator.of(context).pop(); }
                    : null
            ),
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
          ],
        )
    );
    return rows;
  }
}