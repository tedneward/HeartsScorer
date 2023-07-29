import 'package:flutter/foundation.dart';

import 'package:hearts_scorer/models/models.dart';
import 'package:sqlite3/sqlite3.dart';

class GameProvider with ChangeNotifier {
  List<Game> games = [];

  Database _openDatabase() {
    Database db;
    try {
      db = sqlite3.open('hearts.db', mode: OpenMode.readWrite);
    }
    on SqliteException {
      db = sqlite3.open('hearts.db', mode: OpenMode.readWriteCreate);
      db.execute('''
        CREATE TABLE games (
          id INTEGER NOT NULL PRIMARY KEY,
          name TEXT NOT NULL
        );''');
    }
    return db;
  }
  void loadFromDatabase() {
    var db = _openDatabase();
    final ResultSet resultSet = db.select('SELECT * FROM games');
    for (final Row row in resultSet) {
      print(row);
    }

    db.dispose();
  }
  void storeToDatabase() {
    var db = _openDatabase();
    db.dispose();
  }

  List<Game> finishedGames() => games.where( (g) => g.gameOver()).toList();
  List<Game> unfinishedGames() => games.where( (g) => g.gameOver() == false).toList();

  void add(Game g) { games.add(g); notifyListeners(); }
}
