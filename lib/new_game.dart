import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hearts_scorer/models.dart';

/*
This screen is designed to gather options and player names for a new game
of Hearts. Can only be reached from the GamesListScreen, and takes us to
the GameMainScreen from here for play. Can we display this as a modal?

Layout thoughts:

Players                                  [+]
_Player 1___________________________________
_Player 2___________________________________
_Player 3___________________________________
_Player 4_______________________________ [-]
_Player 5_______________________________ [-]

Game options
Jack of Diamonds:   (*  )     Pass:     (*  )
Reset at threshold: (*  )     Shooting: (  *)
Game over at:       _100_

NOTES:
[+] adds a new text field to the list for input; [-] deletes that player

Players cannot have duplicate names.
Players cannot be empty fields.

Each switch change sends a SnackBar message about the option chosen:
"Jack of Diamonds worth -10" vs "Nothing special for Jack of Diamonds"
"Reset score to 0 at exactly 100" vs "No score reset possible"
 */
class NewGameScreen extends StatefulWidget {
  @override
  _NewGameState createState() => _NewGameState();
}
class _NewGameState extends State {
  final _formKey = GlobalKey();

  List<String> _playerNames = [
    "Player 1", "Player 2", "Player 3", "Player 4"
  ];
  bool _jackOn = true;
  bool _shootPositive = true;
  bool _resetOnThreshold = true;
  bool _passLeftIncreasingly = false;
  int _lossThreshold = 100;

  List<Widget> buildPlayers(BuildContext context) {
    return <Widget>[
      Row(
        children: [
          const Text('Players: ', style: TextStyle(fontSize: 18.0)),
          Ink(
            decoration: const ShapeDecoration(
              color: Colors.lightBlue,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () { setState( () { if (_playerNames.length < 7) _playerNames.add("Player"); }); },
            ),
          ),
        ]
      ),
      for (var entry in _playerNames.asMap().entries) buildPlayerTile(context, entry.key)
    ];
  }

  Widget buildPlayerTile(BuildContext context, int playerIdx) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
          child: Row(
            children: [
              Expanded(child: TextField(
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Player Name'),
                  onChanged: (String value) {
                    print("Updating player ${playerIdx} to $value");
                    _playerNames[playerIdx] = value;
                  }
              )),
              IconButton(onPressed: () {
                setState( () { if (_playerNames.length > 3) _playerNames.removeAt(playerIdx); });
              }, icon: Icon(Icons.delete, color: Colors.red), )
            ]
          ),
      )
    );
  }

  List<Widget> buildOptions(BuildContext context) {
    return <Widget>[
      const Text('Game options: ', style: TextStyle(fontSize: 18.0)),
      Padding(
        padding: EdgeInsets.all(12.0),
        child: TextField(
          decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Game over at...'),
          controller: TextEditingController(text: _lossThreshold.toString()),
          keyboardType: TextInputType.number,
          inputFormatters: [ FilteringTextInputFormatter.digitsOnly ],
          onChanged: (String value) {
            if (value.isNotEmpty) {
              _lossThreshold = int.parse(value);
            }
            else {
              _lossThreshold = 0;
            }
          },
        ),
      ),
      SwitchListTile(
        value: _jackOn,
        onChanged: (bool? value) { setState(() { _jackOn = value!; }); },
        title: const Text('Jack of Diamonds'),
        subtitle: const Text('Take -10 when taking the Jack'),
      ),
      SwitchListTile(
        value: _shootPositive,
        onChanged: (bool? value) { setState(() { _shootPositive = value!; }); },
        title: const Text('Shooting adds 26'),
        subtitle: const Text("Shooting the moon adds 26 to others' scores"),
      ),
      SwitchListTile(
        value: _resetOnThreshold,
        onChanged: (bool? value) { setState(() { _resetOnThreshold = value!; }); },
        title: const Text('Reset on threshold'),
        subtitle: const Text("Scoring the exact loss threshold resets that score back to 0"),
        isThreeLine: true,
      ),
      SwitchListTile(
        value: _passLeftIncreasingly,
        onChanged: (bool? value) { setState(() { _passLeftIncreasingly = value!; }); },
        title: const Text('Pass left increasingly'),
        subtitle: const Text("Each pass is to one more to the left (left, across, hold, pass)"),
        isThreeLine: true,
      ),
    ];
  }

  List<Widget> buildNewGameTile(BuildContext context) {
    return <Widget>[
      Padding(
        padding: EdgeInsets.all(12.0),
        child: ElevatedButton(
          child: const Text("Let's play!"),
          onPressed: () {
            print("Time to go to GameMainScreen, passing over the options and ${_playerNames}");
          }
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children:
          buildPlayers(context) +
          [ const Divider(height: 0) ] +
          buildOptions(context) +
          [ const Divider(height: 0) ] +
          buildNewGameTile(context)
      )
    );
  }
}
