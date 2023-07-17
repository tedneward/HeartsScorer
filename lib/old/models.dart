enum Pass { left, twoLeft, threeLeft, across, threeRight, twoRight, right, hold }

class Player {
  Player({this.name});

  String name;
  Pass pass;

  String toString() {
    return "Player: ${name} (passes ${pass})";
  }
}

// Score is a given Player's score for a Hand. "Score" here means keeping track
// of the pre-calculated result (as in, not just a simple number, but the facts
// that lead to the calculated result, since the actual number will depend on
// the selected rules for the Game).
class Score {
  Score({this.hearts = 0, this.queen = false, this.jack = false});

  int hearts;
  bool queen;
  bool jack;

  String toString() {
    return "Score: ${hearts} ${queen ? "Q" : ""} ${jack ? "J" : ""}";
  }
}

// A Hand is a collection of the Scores for a given round in the game.
class Hand {
  Hand({this.game}) {
    if (this.game != null) {
      game.players.forEach( (player) {
        scores[player] = Score();
      });
    }
  }

  final Game game; // we need this for the options
  Map<Player, Score> scores = <Player, Score>{};

  String toString() {
    return "Hand: $scores";
  }

  Player _shotTheMoon() {
    for (var p in scores.keys) {
      var s = scores[p];
      if (s.hearts == 13 && s.queen)
        return p;
    }
    return null;
  }

  int scoreFor(Player p) {
    int score = 0;

    Player shooter = _shotTheMoon();
    if (shooter != null) {
      if (game.shootPositive) {
        score = (p == shooter ? 0 : 26);
      }
      else {
        score = (p == shooter ? -26 : 0);
      }
    }
    else {
      // No shot, calculate as usual
      score = scores[p].hearts;
      score += (scores[p].queen ? 13 : 0);
    }

    if (scores[p].jack && game.jackOn)
      score -= 10;

    return score;
  }

  bool validate() {
    if (scores.length != game.players.length)
      return false;

    int hearts = 0;
    int queens = 0;
    int jacks = 0;
    scores.forEach((p, s) {
      hearts += s.hearts;
      queens += (s.queen ? 1 : 0);
      jacks += (s.jack ? 1 : 0);
    });
    return (hearts == 13) && (queens == 1) && (game.jackOn ? jacks == 1 : true);
  }

  bool finalize() {
    if (validate()) {
      this.game.hands.add(this);
      return true;
    }
    else {
      return false;
    }
  }
}

/*
 * Game class represents the players in the game and the rules selected.
 * -- numberOfPlayers is self-explanatory
 * -- players is the collection of Player objects
 * -- shootPositive indicates whether everybody else goes positive (+26) or the
 *    shooter goes negative (-26).
 * -- jackOn: Jack of Diamonds reduces score by 10
 * -- passIncreasinglyLeft: does successive pass direction go to the left, or
 *    in the more traditional left/right/across/.../hold pattern?
 * -- lossThreshold: at how many points is the game over?
 * -- exactThresholdResets: if somebody hits the lossThreshold exactly, do they
 *    reset to 0?
 */
class Game {
  Game({playerNames = const [
      "Player 1",
      "Player 2",
      "Player 3",
      "Player 4"
    ],
    this.shootPositive = true,
    this.jackOn = true,
    this.passIncreasinglyLeft = false,
    this.exactThresholdResets = true,
    this.lossThreshold = 100}) {
    for (var n in playerNames) {
      players.add(Player(name: n));
    }

    if (passIncreasinglyLeft) {
      switch (players.length) {
        case 3:
          players[0].pass = Pass.left;
          players[1].pass = Pass.right;
          players[2].pass = Pass.hold;
          break;
        case 4:
          players[0].pass = Pass.left;
          players[1].pass = Pass.across;
          players[2].pass = Pass.right;
          players[3].pass = Pass.hold;
          break;
        case 5:
          players[0].pass = Pass.left;
          players[1].pass = Pass.twoLeft;
          players[2].pass = Pass.twoRight;
          players[3].pass = Pass.right;
          players[4].pass = Pass.hold;
          break;
        case 6:
          players[0].pass = Pass.left;
          players[1].pass = Pass.twoLeft;
          players[2].pass = Pass.across;
          players[3].pass = Pass.twoRight;
          players[4].pass = Pass.right;
          players[5].pass = Pass.hold;
          break;
      }
    }
    else {
      switch (players.length) {
        case 3:
          players[0].pass = Pass.left;
          players[1].pass = Pass.right;
          players[2].pass = Pass.hold;
          break;
        case 4:
          players[0].pass = Pass.left;
          players[1].pass = Pass.right;
          players[2].pass = Pass.across;
          players[3].pass = Pass.hold;
          break;
        case 5:
          players[0].pass = Pass.left;
          players[1].pass = Pass.right;
          players[2].pass = Pass.twoLeft;
          players[3].pass = Pass.twoRight;
          players[4].pass = Pass.hold;
          break;
        case 6:
          players[0].pass = Pass.left;
          players[1].pass = Pass.right;
          players[2].pass = Pass.twoLeft;
          players[3].pass = Pass.twoRight;
          players[4].pass = Pass.across;
          players[5].pass = Pass.hold;
          break;
      }
    }
  }

  List<Player> players = [];
  bool shootPositive = true;
  bool jackOn = true;
  bool passIncreasinglyLeft = false;
  bool exactThresholdResets = true;
  int lossThreshold = 100;

  List<Hand> hands = <Hand>[];

  String toString() {
    return "Game: " +
      "Players: $players," +
      "shootPositive: $shootPositive," +
      "jackOn: $jackOn, " +
      "passIncreasinglyLeft: $passIncreasinglyLeft," +
      "lossThreshold: $lossThreshold," +
      "exactThresholdResets: $exactThresholdResets," +
      "Hands: $hands,"
    ;
  }

  Player dealer() {
    if (hands.length == 0) {
      return players[0];
    }
    else {
      int dealerPlayer = (hands.length % players.length);
      return players[dealerPlayer];
    }
  }

  Pass upcomingPass() {
    return dealer().pass;
  }

  Player playerFor(String name) {
    return players.firstWhere((it) => it.name == name);
  }

  int scoreFor(Player player) {
    int score = 0;
    hands.forEach( (h) => score += h.scoreFor(player) );
    return score;
  }

  bool gameOver() {
    return players.firstWhere((it) => playerLost(it), orElse: () => null) != null;
  }

  bool playerLost(Player player) {
    return scoreFor(player) > lossThreshold;
  }
  bool playerResets(Player player) {
    return this.exactThresholdResets && (scoreFor(player) == lossThreshold);
  }

  reset() {
    hands.clear();
  }
}
