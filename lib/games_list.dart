import 'package:flutter/material.dart';

import 'package:hearts_scorer/models.dart';

/*
This is the top-level screen displaying all of the Hearts game known on this
device; We can create a new one, or load an old one and play it out if it isn't
finished.
 */
class GamesListScreen extends StatefulWidget {
  const GamesListScreen({super.key, required this.title});

  final String title;

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  List<Game> _games = [];

  void _newGame() {
    // TEMP TEMP TEMP
    setState(() {
      _games.add(Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew"]));
    });

    // Go to the NewGameScreen to get a new Game set up
  }

  void _loadGame(Game game) {
    // Go to the GameMainScreen to look at the current game state
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView.builder(
            itemCount: _games.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: Icon(Icons.monitor_heart),
                  title: Text(_games[index].started.toString()),
                  subtitle: Text(_games[index].players.toString()),
                  // There needs to be a delete button in here, or a slide-out behavior
                  trailing: IconButton(
                      onPressed: () => _loadGame(_games[index]),
                      icon: Icon(Icons.arrow_forward))
              );
            },
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newGame,
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }
}