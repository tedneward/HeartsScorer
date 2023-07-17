import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearts_scorer/score_hand.dart';

import 'models.dart';
import 'new_game_page.dart';

/*
 * TODO:
 *  dialog used to enter the details for a Hand
 *  HandCardView: a widget that displays a single Hand as a card
 *  MainPageState: use a ListView of HandCardViews to display the whole Game
 *  MainPageState: put a summary block above the ListView for easy reference
 */
/*
 * NOTE: Unicode code points for spades (\u2660) and diamonds (\u2662)
 */


void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft]
  ).then((_) {
    runApp(new HeartsApp());
  });
}

class HeartsApp extends StatelessWidget {
  final _title = "Hearts Scorer";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MainPage(title: _title),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Game _game;

  void _scoreHand(BuildContext context) {
    var hand = Hand(game: _game);


    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Hand scores:"),
          contentPadding: const EdgeInsets.all(16.0),
          children: [
            ScoreHandDialog(game: _game)
          ],
        );
      },
    );
    // Capture the Hand instance coming back
  }

  String _upcomingText() {
    if (_game != null) {
      return ': Dealer: ${_game.dealer().name}, passing ${_game.dealer().pass.toString().split('.')[1]}';
    }
    else
      return ': (No game)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('${widget.title}' + _upcomingText()),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _newGame(context);
              },
            icon: Icon(Icons.create)
          ),
        ],
      ),
      body: null,
      floatingActionButton: (_game == null ? null :
        FloatingActionButton(
          onPressed: () { _scoreHand(context); },
          tooltip: 'Score Hand!',
          child: Icon(Icons.add_box),
        )
      ),
    );
  }

  _newGame(BuildContext context) async {
    final Game result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewGamePage()),
    );
    if (result != null) {
      print("Game Instance: ${result.toString()}");
      // When NewGamePage() returns a Game object, assign it here
      _game = result;
    }
  }
}
