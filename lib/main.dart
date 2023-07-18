import 'package:flutter/material.dart';
import 'package:hearts_scorer/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hearts Scorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hearts Games'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Game> _games = [];

  void _newGame() {
    Game game = Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew"]);
    setState(() {
      _games.add(game);
    });
  }

  void _loadGame(Game game) {
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

class GameHistoryScreen extends StatelessWidget {
  final Game game;

  const GameHistoryScreen({super.key, required Game this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      //passing in the ListView.builder
      body: ListView.builder(
        itemCount: game.history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Round summary goes in here'),
          );
        },
      ),
    );
  }
}

class RoundScreen extends StatelessWidget {
  final Round round;
  const RoundScreen({super.key, required Round this.round});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Text('Player $index');
        },
      ),
    );
  }
}

class TakeCard extends StatelessWidget {
  final Take take;
  final String playerName;
  const TakeCard(
      {super.key, required String this.playerName, required Take this.take});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey,
        elevation: 8.0,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            height: 200,
            width: 350,
            child: Text('Container body')));
  }
}
