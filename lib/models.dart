import 'dart:core';

enum Pass {
  left,
  twoLeft,
  threeLeft,
  across,
  threeRight,
  twoRight,
  right,
  hold
}

class Player {
  String name;

  Player(this.name);

  String displayString() {
    return "${name}";
  }

  String toString() {
    return "Player: ${name})";
  }
}

// A Take is a single player's cards taken during a hand.
//
class Take {
  Take(this.hearts);

  Take.empty();
  Take.withJack(this.hearts) : jack = true;
  Take.withQueen(this.hearts) : queen = true;
  Take.withQueenAndJack(this.hearts)
      : jack = true,
        queen = true;

  int hearts = -1;
  bool queen = false;
  bool jack = false;

  bool shot() {
    return (hearts == 13) && (queen == true);
  }
}

class Round {
  Game game;

  Round(this.game) {
    cards = Map.fromEntries(game.players.map( (p) => MapEntry(p.name, Take.empty())));
  }

  Map<String, Take> cards = {};

  bool score(String player, Take take) {
    cards[player] = take;
    return true;
  }

  bool good() {
    // Do hearts total 13? Is the queen taken (once)? Is the jack taken (once)?
    int totalHearts = 0;
    int queenTaken = 0;
    int jackTaken = 0;
    cards.forEach((key, value) {
      totalHearts += value.hearts;
      queenTaken += (value.queen ? 1 : 0);
      jackTaken += (value.jack ? 1 : 0);
    });
    if (totalHearts != 13) {
      return false;
    }
    if (queenTaken != 1) {
      return false;
    }
    if (game.jackOn && (jackTaken != 1)) {
      return false;
    }

    return true;
  }

  int pointsFor(String player) {
    if (!good()) {
      return -1;
    }

    // Shoot-the-moon check
    String shooter = "";
    cards.forEach((key, value) {
      if (cards[key]!.shot()) {
        shooter = key;
      }
    });

    if (shooter != "") { // Somebody shot!
      if (shooter == player) { // shooter...
        if (game.shootPositive) { // gets 0
          return (game.jackOn && cards[player]!.jack ? -10 : 0);
        }
        else { // gets -26
          return (game.jackOn && cards[player]!.jack ? -10 : 0) - 26;
        }
      }
      else { // everybody else...
        if (game.shootPositive) { // gets 26
          return (game.jackOn && cards[player]!.jack ? -10 : 0) + 26;
        }
        else { // gets 0
          return (game.jackOn && cards[player]!.jack ? -10 : 0);
        }
      }
    }

    // Nobody shot, so standard calculation
    Take t = cards[player]!;
    return t.hearts + (t.queen ? 13 : 0) - (game.jackOn && t.jack ? 10 : 0);
  }
}

class Game {
  DateTime started = DateTime.timestamp();

  Game({this.shootPositive = false, this.jackOn = true,
        this.resetOnExact = true, this.passIncreasinglyLeft = false,
        this.exactThresholdResets = true, this.lossThreshold = 100});

  Game.forPlayers(List<String> playerNames,
       {this.shootPositive = false, this.jackOn = true,
        this.resetOnExact = true, this.passIncreasinglyLeft = false,
        this.exactThresholdResets = true, this.lossThreshold = 100})
      : players = playerNames.map((e) => Player(e)).toList();

  List<Player> players = [];
  List<Round> history = [];

  // The options for the game
  bool shootPositive = false;
  bool jackOn = true;
  bool resetOnExact = true;
  bool passIncreasinglyLeft = false;
  bool exactThresholdResets = true;
  int lossThreshold = 100;

  int currentRound() {
    return history.length;
  }

  Pass currentPass() {
    if (passIncreasinglyLeft) {
      switch (players.length) {
        case 3: return [Pass.left, Pass.right, Pass.hold][dealerIdx()];
        case 4: return [Pass.left, Pass.across, Pass.right, Pass.hold][dealerIdx()];
        case 5: return [Pass.left, Pass.twoLeft, Pass.twoRight, Pass.right, Pass.hold][dealerIdx()];
        case 6: return [Pass.left, Pass.twoLeft, Pass.across, Pass.twoRight, Pass.right, Pass.hold][dealerIdx()];
        case 7: return [Pass.left, Pass.twoLeft, Pass.threeLeft, Pass.threeRight, Pass.twoRight, Pass.right, Pass.hold][dealerIdx()];
        default: throw 'How do we have less than 3 or more than 7 players?!?';
      }
    }
    else {
      switch (players.length) {
        case 3: return [Pass.left, Pass.right, Pass.hold][dealerIdx()];
        case 4: return [Pass.left, Pass.right, Pass.across, Pass.hold][dealerIdx()];
        case 5: return [Pass.left, Pass.right, Pass.twoLeft, Pass.twoRight, Pass.hold][dealerIdx()];
        case 6: return [Pass.left, Pass.right, Pass.twoLeft, Pass.twoRight, Pass.across, Pass.hold][dealerIdx()];
        case 7: return [Pass.left, Pass.right, Pass.twoLeft, Pass.twoRight, Pass.threeLeft, Pass.threeRight, Pass.hold][dealerIdx()];
        default: throw 'How do we have less than 3 or more than 7 players?!?';
      }
    }
  }

  Player playerFor(String name) {
    return players.firstWhere((it) => it.name == name);
  }

  int dealerIdx() {
    // return the index into the list whose deal it is; take the current round #,
    // mod it by the number of players, and apply that into the list
    // round 0 => 0 mod 4 => 0 => first player in the list
    return (history.length) % (players.length);
  }

  Player dealer() {
    return players[dealerIdx()];
  }

  bool gameOver() {
    // Get total scores, see if any are over 100
    return false;
  }
}
