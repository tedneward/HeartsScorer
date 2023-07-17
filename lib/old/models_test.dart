import 'package:flutter_test/flutter_test.dart';
import 'package:hearts_scorer/models.dart';

Game getTCMMGame() {
  return Game(playerNames: <String>["Ted", "Charlotte", "Michael", "Matthew"]);
}

void main() {
  test("Test default settings", () {
    final game = getTCMMGame();

    expect(game.gameOver(), equals(false));
    expect(game.players, hasLength(4));
    expect(game.jackOn, equals(true));
    expect(game.shootPositive, equals(true));
    expect(game.passIncreasinglyLeft, equals(false));
    expect(game.exactThresholdResets, equals(true));
  });

  test("Test four-players with defaults", () {
    final game = getTCMMGame();

    expect(game.players[0].name, equals("Ted"));
    expect(game.players[1].name, equals("Charlotte"));
    expect(game.players[2].name, equals("Michael"));
    expect(game.players[3].name, equals("Matthew"));

    expect(game.gameOver(), equals(false));

    expect(game.passIncreasinglyLeft, equals(false));
    expect(game.playerFor("Ted").pass, equals(Pass.left));
    expect(game.playerFor("Charlotte").pass, equals(Pass.right));
    expect(game.playerFor("Michael").pass, equals(Pass.across));
    expect(game.playerFor("Matthew").pass, equals(Pass.hold));
    expect(game.dealer(), equals(game.playerFor("Ted")));
  });

  test("Test nothing special", () {
    final game = getTCMMGame();
    game.jackOn = false; // turn the Jack off for simple scoring

    Hand h = Hand(game: game);
    // Ted took 0, Char took 2, Mike took 6, Matt took 5+queen
    h.scores[game.playerFor("Ted")] = Score();
    h.scores[game.playerFor("Charlotte")] = Score(hearts: 2);
    h.scores[game.playerFor("Michael")] = Score(hearts: 6);
    h.scores[game.playerFor("Matthew")] = Score(hearts: 5, queen: true);

    expect(h.finalize(), equals(true));
    expect(h.scoreFor(game.playerFor("Ted")), equals(0));
    expect(h.scoreFor(game.playerFor("Charlotte")), equals(2));
    expect(h.scoreFor(game.playerFor("Michael")), equals(6));
    expect(h.scoreFor(game.playerFor("Matthew")), equals(18));
    expect(h.scoreFor(game.playerFor("Ted")) +
        h.scoreFor(game.playerFor("Charlotte")) +
        h.scoreFor(game.playerFor("Michael")) +
        h.scoreFor(game.playerFor("Matthew")), equals(26));
    expect(game.gameOver(), equals(false));
  });

  test("Test Hand validation fail", () {
    final game = getTCMMGame();
    game.jackOn = false; // turn the Jack off for simple scoring

    Hand h = Hand(game: game);
    // Ted took 0, Char took 5, Mike took 6, Matt took 5+queen: IMPOSSIBLE!
    h.scores[game.playerFor("Ted")] = Score();
    h.scores[game.playerFor("Charlotte")] = Score(hearts: 5);
    h.scores[game.playerFor("Michael")] = Score(hearts: 6);
    h.scores[game.playerFor("Matthew")] = Score(hearts: 5, queen: true);

    expect(h.finalize(), equals(false));
  });

  test("Test Hand with the Jack", () {
    final game = getTCMMGame();

    Hand h = Hand(game: game);
    // Ted took 0 & J, Char took 2, Mike took 6, Matt took 5+queen
    h.scores[game.playerFor("Ted")] = Score(jack: true);
    h.scores[game.playerFor("Charlotte")] = Score(hearts: 2);
    h.scores[game.playerFor("Michael")] = Score(hearts: 6);
    h.scores[game.playerFor("Matthew")] = Score(hearts: 5, queen: true);

    expect(h.finalize(), equals(true));
    expect(h.scoreFor(game.playerFor("Ted")), equals(-10));
    expect(h.scoreFor(game.playerFor("Charlotte")), equals(2));
    expect(h.scoreFor(game.playerFor("Michael")), equals(6));
    expect(h.scoreFor(game.playerFor("Matthew")), equals(18));
    expect(game.gameOver(), equals(false));
  });

  test("Test shooter without Jack", () {
    final game = getTCMMGame();

    Hand h = Hand(game: game);
    // Ted shot, Char took J
    h.scores[game.playerFor("Ted")] = Score(hearts: 13, queen: true);
    h.scores[game.playerFor("Charlotte")] = Score(jack: true);
    h.scores[game.playerFor("Michael")] = Score();
    h.scores[game.playerFor("Matthew")] = Score();

    expect(h.finalize(), equals(true));
    expect(h.scoreFor(game.playerFor("Ted")), equals(0));
    expect(h.scoreFor(game.playerFor("Charlotte")), equals(16));
    expect(h.scoreFor(game.playerFor("Michael")), equals(26));
    expect(h.scoreFor(game.playerFor("Matthew")), equals(26));
    expect(game.gameOver(), equals(false));
  });

  test("Test shooter with Jack", () {
    final game = getTCMMGame();

    Hand h = Hand(game: game);
    h.scores[game.playerFor("Ted")] =
        Score(hearts: 13, queen: true, jack: true);
    h.scores[game.playerFor("Charlotte")] = Score();
    h.scores[game.playerFor("Michael")] = Score();
    h.scores[game.playerFor("Matthew")] = Score();

    expect(h.finalize(), equals(true));
    expect(h.scoreFor(game.playerFor("Ted")), equals(-10));
    expect(h.scoreFor(game.playerFor("Charlotte")), equals(26));
    expect(h.scoreFor(game.playerFor("Michael")), equals(26));
    expect(h.scoreFor(game.playerFor("Matthew")), equals(26));
  });

  test("Test shooter with Jack and shooterNegative on", () {
    final game = getTCMMGame();
    game.shootPositive = false;

    Hand h = Hand(game: game);
    h.scores[game.playerFor("Ted")] = Score(hearts: 13, queen: true);
    h.scores[game.playerFor("Charlotte")] = Score(jack: true);
    h.scores[game.playerFor("Michael")] = Score();
    h.scores[game.playerFor("Matthew")] = Score();

    expect(h.finalize(), equals(true));
    expect(h.scoreFor(game.playerFor("Ted")), equals(-26));
    expect(h.scoreFor(game.playerFor("Charlotte")), equals(-10));
    expect(h.scoreFor(game.playerFor("Michael")), equals(0));
    expect(h.scoreFor(game.playerFor("Matthew")), equals(0));
  });

  test("Test shooter without Jack and shooterNegative on", () {
    final game = getTCMMGame();
    game.shootPositive = false;

    Hand h = Hand(game: game);
    h.scores[game.playerFor("Ted")] =
        Score(hearts: 13, queen: true, jack: true);
    h.scores[game.playerFor("Charlotte")] = Score();
    h.scores[game.playerFor("Michael")] = Score();
    h.scores[game.playerFor("Matthew")] = Score();

    expect(h.finalize(), equals(true));
    expect(h.scoreFor(game.playerFor("Ted")), equals(-36));
    expect(h.scoreFor(game.playerFor("Charlotte")), equals(0));
    expect(h.scoreFor(game.playerFor("Michael")), equals(0));
    expect(h.scoreFor(game.playerFor("Matthew")), equals(0));
  });

  test("First pass should be first player's pass", () {
    final game = getTCMMGame();

    expect(game.dealer(), equals(game.playerFor("Ted")));
    expect(game.upcomingPass(), equals(Pass.left));

    expect(game.dealer().pass, equals(game.upcomingPass()));
  });

  test("Second pass should be second player's pass", () {
    final game = getTCMMGame();

    Hand h1 = Hand(game: game);
    h1.scores[game.playerFor("Ted")] =
        Score(hearts: 13, queen: true, jack: true);
    h1.scores[game.playerFor("Charlotte")] = Score();
    h1.scores[game.playerFor("Michael")] = Score();
    h1.scores[game.playerFor("Matthew")] = Score();
    h1.finalize();

    expect(game.upcomingPass(), equals(Pass.right));
  });
}
