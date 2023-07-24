import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:hearts_scorer/models.dart';
import 'package:hearts_scorer/main.dart';
import 'package:hearts_scorer/game_main.dart';

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
  const NewGameScreen({super.key});

  @override
  _NewGameState createState() => _NewGameState();
}
class _NewGameState extends State {
  _NewGameState();

  final List<String> _playerNames = [ "Player 1", "Player 2", "Player 3", "Player 4" ];
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
      child: Row(
        children: [
          Expanded(child: TextField(
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Player Name'),
              onChanged: (String value) { _playerNames[playerIdx] = value; }
          )),
          IconButton(onPressed: () {
            setState( () { if (_playerNames.length > 3) _playerNames.removeAt(playerIdx); });
          }, icon: const Icon(Icons.delete, color: Colors.red), )
        ]
      )
    );
  }

  List<Widget> buildOptions(BuildContext context) {
    return <Widget>[
      const Text('Game options: ', style: TextStyle(fontSize: 18.0)),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Game over at...'),
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
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          child: const Text("Let's play!"),
          onPressed: () {
            var g = Game.forPlayers(_playerNames, passIncreasinglyLeft: _passLeftIncreasingly, jackOn: _jackOn,
              resetOnExact: _resetOnThreshold, lossThreshold: _lossThreshold);
            setState( () {
              context.read<GameProvider>().add(g);
              print("After add, game provider list looks like ${context.read<GameProvider>().games}");
            } );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GameMainScreen(game: g),
              ),
            );
          }
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('New Game'),
      ),
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
