import 'package:flutter/material.dart';

import 'models.dart';

class NewGamePage extends StatefulWidget {
  @override
  _NewGamePageState createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  int numberOfPlayers = 4;
  List<String> playerNames = [
    "Player 1",
    "Player 2",
    "Player 3",
    "Player 4",
    "Player 5",
    "Player 6"
  ];
  bool jackOn = true;
  bool shootPositive = true;
  bool passIncreasinglyLeft = false;
  int lossThreshold = 100;
  bool exactThresholdResets = true;

  TextEditingController lossController = new TextEditingController();

  List<Widget> _buildNumberOfPlayersRow() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Players:"),
          // TODO: Space these out more correctly
          Text("3"),
          Radio<int>(
              value: 3,
              groupValue: numberOfPlayers,
              onChanged: (v) {
                setState(() => numberOfPlayers = 3);
              }),
          Text("4"),
          Radio<int>(
              value: 4,
              groupValue: numberOfPlayers,
              onChanged: (v) {
                setState(() => numberOfPlayers = 4);
              }),
          Text("5"),
          Radio<int>(
              value: 5,
              groupValue: numberOfPlayers,
              onChanged: (v) {
                setState(() => numberOfPlayers = 5);
              }),
          Text("6"),
          Radio<int>(
              value: 6,
              groupValue: numberOfPlayers,
              onChanged: (v) {
                setState(() => numberOfPlayers = 6);
              }),
        ],
      ),
    ];
  }

  List<Widget> _buildOptionsRows() {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        Text("Jack of Diamonds on?"),
        Checkbox(
            value: jackOn,
            onChanged: (value) => setState(() => jackOn = value)),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        Text("Shooting adds to others?"),
        Checkbox(
            value: shootPositive,
            onChanged: (value) => setState(() => shootPositive = value)),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        Text("Pass increasingly to the left?"),
        Checkbox(
            value: passIncreasinglyLeft,
            onChanged: (value) => setState(() => passIncreasinglyLeft = value)),
      ]),
      // TODO: REALLY need to fix the layout here, this is terrible
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        Text("Loss"),
        /*Flexible(
              child:
              TextField(
                maxLength: 3,
                controller: lossController,
                keyboardType: TextInputType.number,
                onSubmitted: (value) => setState( () => lossThreshold = int.tryParse(value) ),
              ),
            ),*/
        Text(lossThreshold.toString()),
        Slider(
            value: 100,
            min: 50,
            max: 250,
            onChanged: (value) =>
                setState(() => lossThreshold = value.toInt())),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        Text("Exact threshold resets to 0?"),
        Checkbox(
            value: exactThresholdResets,
            onChanged: (value) => setState(() => exactThresholdResets = value)),
      ]),
    ];
  }

  List<Widget> _buildPlayerNamesRows() {
    List<Widget> namesRows = [];
    int playerNum = 1;
    while (playerNum <= numberOfPlayers) {
      final pn = playerNum;
      namesRows.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Player " + playerNum.toString() + ":"),
        Text(playerNames[playerNum - 1]),
        FlatButton(
            child: Icon(Icons.edit),
            onPressed: () => _showTextInputDialog().then((value) {
                  playerNames[pn - 1] = value;
                }))
      ]));
      playerNum++;
    }
    return namesRows;
  }

  List<Widget> _buildOKCancelRow() {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        FlatButton(
          onPressed: () {
            List<String> pns = playerNames.take(numberOfPlayers).toList();
            Game newGame = Game(playerNames: pns);
            newGame.jackOn = jackOn;
            newGame.shootPositive = shootPositive;
            newGame.passIncreasinglyLeft = passIncreasinglyLeft;
            newGame.exactThresholdResets = exactThresholdResets;
            newGame.lossThreshold = lossThreshold;

            Navigator.pop(context, newGame);
          },
          child: Text('OK'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ])
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Game"),
      ),
      body: SingleChildScrollView(
        child:
          Column(
            children: [
              _buildNumberOfPlayersRow(),
              _buildOptionsRows(),
              _buildPlayerNamesRows(),
              _buildOKCancelRow()
            ].expand((i) => i).toList(),
          ),
      ),
    );
  }

  Future<String> _showTextInputDialog() async {
    var input;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Player Name', hintText: 'eg. John'
                ),
                onChanged: (value) {
                  input = value;
                }),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context, "");
              }
            ),
            new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                print("OK; input = " + input);
                Navigator.pop(context, input);
              }
            )
          ],
        );
      }
    );
  }
}
