import 'package:flutter_test/flutter_test.dart';

import 'package:hearts_scorer/models.dart';

void main() {

  test("Test two rounds", () {
    final game = Game(playerNames: <String>["Ted", "Charlotte", "Michael", "Matthew"]);

    expect(game.dealer(), equals(game.playerFor("Ted")));

    Hand h1 = Hand(game: game);
    h1.scores[game.playerFor("Ted")] =
        Score(hearts: 13, queen: true, jack: true);
    h1.scores[game.playerFor("Charlotte")] = Score();
    h1.scores[game.playerFor("Michael")] = Score();
    h1.scores[game.playerFor("Matthew")] = Score();
    h1.finalize();

    expect(game.dealer(), equals(game.playerFor("Charlotte")));

    expect(game.hands.length, equals(1));
    expect(game.scoreFor(game.playerFor("Ted")), equals(-10));
    expect(game.scoreFor(game.playerFor("Charlotte")), equals(26));

    Hand h2 = Hand(game: game);
    h2.scores[game.playerFor("Ted")] =
        Score(hearts: 13, queen: true, jack: true);
    h2.scores[game.playerFor("Charlotte")] = Score();
    h2.scores[game.playerFor("Michael")] = Score();
    h2.scores[game.playerFor("Matthew")] = Score();
    h2.finalize();

    expect(game.dealer(), equals(game.playerFor("Michael")));

    expect(game.hands.length, equals(2));
    expect(game.scoreFor(game.playerFor("Ted")), equals(-20));
    expect(game.scoreFor(game.playerFor("Charlotte")), equals(52));
  });

  test("Full game", () {
    final game = Game(playerNames: <String>["Ted", "Charlotte", "Michael", "Matthew"]);
    game.jackOn = false;

    expect(game.dealer(), equals(game.playerFor("Ted")));

    Hand h1 = Hand(game: game);
    h1.scores[game.playerFor("Ted")] =
        Score(hearts: 13, queen: true, jack: true);
    h1.scores[game.playerFor("Charlotte")] = Score();
    h1.scores[game.playerFor("Michael")] = Score();
    h1.scores[game.playerFor("Matthew")] = Score();
    h1.finalize();

    expect(game.dealer(), equals(game.playerFor("Charlotte")));

    expect(game.hands.length, equals(1));
    expect(game.scoreFor(game.playerFor("Ted")), equals(0));
    expect(game.scoreFor(game.playerFor("Charlotte")), equals(26));

    Hand h2 = Hand(game: game);
    h2.scores[game.playerFor("Ted")] =
        Score(hearts: 13, queen: true, jack: true);
    h2.scores[game.playerFor("Charlotte")] = Score();
    h2.scores[game.playerFor("Michael")] = Score();
    h2.scores[game.playerFor("Matthew")] = Score();
    h2.finalize();

    expect(game.dealer(), equals(game.playerFor("Michael")));

    expect(game.hands.length, equals(2));
    expect(game.scoreFor(game.playerFor("Ted")), equals(0));
    expect(game.scoreFor(game.playerFor("Charlotte")), equals(52));

    Hand h3 = Hand(game: game);
    h3.scores[game.playerFor("Ted")] =
        Score(hearts: 13, queen: true, jack: true);
    h3.scores[game.playerFor("Charlotte")] = Score();
    h3.scores[game.playerFor("Michael")] = Score();
    h3.scores[game.playerFor("Matthew")] = Score();
    h3.finalize();

    expect(game.dealer(), equals(game.playerFor("Matthew")));

    expect(game.hands.length, equals(3));
    expect(game.scoreFor(game.playerFor("Ted")), equals(0));
    expect(game.scoreFor(game.playerFor("Charlotte")), equals(78));

    Hand h4 = Hand(game: game);
    h4.scores[game.playerFor("Ted")] =
        Score(hearts: 13, queen: true, jack: true);
    h4.scores[game.playerFor("Charlotte")] = Score();
    h4.scores[game.playerFor("Michael")] = Score();
    h4.scores[game.playerFor("Matthew")] = Score();
    h4.finalize();

    expect(game.dealer(), equals(game.playerFor("Ted")));

    expect(game.hands.length, equals(4));
    expect(game.scoreFor(game.playerFor("Ted")), equals(0));
    expect(game.scoreFor(game.playerFor("Charlotte")), equals(104));
    expect(game.gameOver(), equals(true));
  });

  test("Somebody resets to zero", () {
    final Game game = Game(playerNames: <String>["Ted", "Charlotte", "Michael", "Matthew"]);
  });
}
