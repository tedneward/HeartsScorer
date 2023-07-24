import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:hearts_scorer/models.dart';
import 'package:hearts_scorer/main.dart';
import 'package:hearts_scorer/game_main.dart';
import 'package:hearts_scorer/new_game.dart';

/*
This is the top-level screen displaying all of the Hearts game known on this
device; We can create a new one, or load an old one and play it out if it isn't
finished.

TODO: On entry, load games list from some kind of local storage. On exit, save
the games list to local storage.
 */
class GamesListScreen extends StatelessWidget {
  const GamesListScreen({super.key, required this.title});

  final String title;

  void _loadGame(BuildContext context, Game game) {
    Navigator.push(
      context, MaterialPageRoute( builder: (context) => GameMainScreen(game: game), ),
    );
  }

  void _newGame(BuildContext context) {
    Navigator.push(
      context, MaterialPageRoute( builder: (context) => NewGameScreen() ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
          child: Consumer<GameProvider>(
            builder: (context, gameProvider, child) => ListView.builder(
              itemCount: gameProvider.unfinishedGames().length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: Icon(Icons.monitor_heart),
                    title: Text(DateFormat.yMMMMd().format(gameProvider.unfinishedGames()[index].started)),
                    subtitle: Text(gameProvider.unfinishedGames()[index].summarize()),
                    // There needs to be a delete button in here, or a slide-out behavior
                    trailing: IconButton(
                        onPressed: () => print("Delete this game"),
                        icon: Icon(Icons.delete)
                    ),
                    onTap: () {
                      _loadGame(context, gameProvider.unfinishedGames()[index]);
                    }
                );
              },
            )
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newGame(context),
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }
}