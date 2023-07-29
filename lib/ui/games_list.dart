import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:hearts_scorer/models/providers.dart';
import 'package:hearts_scorer/ui/game_main.dart';
import 'package:hearts_scorer/ui/new_game.dart';

/*
This is the top-level screen displaying all of the Hearts game known on this
device; We can create a new one, or load an old one and play it out if it isn't
finished.

TODO: On entry, load games list from some kind of local storage. On exit, save
the games list to local storage.
 */
class GamesListScreen extends StatefulWidget {
  final String title;
  const GamesListScreen({super.key, required this.title});

  @override
  _GamesListState createState() => _GamesListState(title);
}
class _GamesListState extends State<GamesListScreen> {
  final String title;
  _GamesListState(this.title);

  int _selectedScreen = 0;

  Widget buildUnfinishedGameList(BuildContext context) {
    return Consumer<GameProvider>(
        builder: (context, gameProvider, child) => ListView.builder(
          itemCount: gameProvider.unfinishedGames().length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(DateFormat.yMMMMd().format(gameProvider.unfinishedGames()[index].started)),
              subtitle: Text(gameProvider.unfinishedGames()[index].summarize()),
              trailing: IconButton(
                  onPressed: () => print("Delete this game"),
                  icon: Icon(Icons.delete)
              ),
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) =>
                        GameMainScreen(game: gameProvider.unfinishedGames()[index])
                  ),
                ).whenComplete(() => setState( () => { } ));
              }
            );
          },
        )
    );
  }

  Widget buildFinishedGameList(BuildContext context) {
    return Consumer<GameProvider>(
        builder: (context, gameProvider, child) => ListView.builder(
          itemCount: gameProvider.finishedGames().length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(gameProvider.finishedGames()[index].summarize()),
                subtitle: Text(DateFormat.yMMMMd().format(gameProvider.finishedGames()[index].started)),
                // There needs to be a delete button in here, or a slide-out behavior
                trailing: IconButton(
                    onPressed: () => print("Delete this game"),
                    icon: Icon(Icons.delete)
                ),
                onTap: () {
                  print("Push to HistoryScreen");
                  //Navigator.push(
                  //       context, MaterialPageRoute( builder: (context) => GameHistoryScreen(game: gameProvider.finishedGames()[index])),
                  //     )
                }
            );
          },
        )
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
          child: switch (_selectedScreen) {
            0 => buildUnfinishedGameList(context),
            1 => buildFinishedGameList(context),
            //2 => buildStatisticsScreen(context),
            _ => buildUnfinishedGameList(context)
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context, MaterialPageRoute( builder: (context) => NewGameScreen() ),
        ),
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart),
            label: 'Unfinished',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Finished',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Statistics',
          ),
        ],
        currentIndex: _selectedScreen,
        selectedItemColor: Colors.amber[800],
        onTap: (index) { setState( () => _selectedScreen = index); },
      ),
    );
  }
}