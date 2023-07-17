import 'dart:core';

// A Take is a single player's cards taken during a hand.
//
class Take {
  Take(this.hearts);

  Take.empty();

  int hearts = -1;
  bool queen = false;
  bool jack = false;

  bool shot() {
    return (hearts == 13) && (queen == true);
  }
}

class Hand {
  Game game;
  Hand(this.game) {}

  Map<String, Take> cards = {};

  void begin() {
    cards.forEach((key, value) {
      cards[key] = Take.empty();
    });
  }

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
    if (game.jack && (jackTaken != 1)) {
      return false;
    }

    return true;
  }
}

class Game {
  List<String> playerList = [];
  List<Hand> handHistory = [];

  // The options for the game
  bool shootingNegative = false;
  bool jack = true;
  bool resetOnExact = true;

  int currentRound() {
    return handHistory.length;
  }

  int dealerIdx() {
    // return the index into the list whose deal it is; take the current round #,
    // mod it by the number of players, and apply that into the list
    // round 0 => 0 mod 4 => 0 => first player in the list
    int playerCount = playerList.length;
    int hands = handHistory.length;

    return hands % playerCount;
  }
}
