import 'package:flutter_test/flutter_test.dart';
import 'package:hearts_scorer/models.dart';

const players3 = ["Ted", "Charlotte", "Michael"];
const players4 = ["Ted", "Charlotte", "Michael", "Matthew"];
const players5 = ["Ted", "Charlotte", "Michael", "Matthew", "Lance"];
const players6 = ["Ted", "Charlotte", "Michael", "Matthew", "Lance", "Donna"];
const players7 = ["Ted", "Charlotte", "Michael", "Matthew", "Lance", "Donna", "John"];

void main() {
  group('Simple Take tests', () {
    test('We can see if we shot the moon', () {
      var t = Take(13);
      t.queen = true;

      expect(t.shot(), isTrue);
    });
  });

  group('Round tests with jackOn', () {
    test('A round is good if all hearts, the queen, and the jack are taken', () {
      var g = Game.forPlayers(players4);
      var r = Round(g);
      r.score("Ted", Take(0));
      r.score("Charlotte", Take(5));
      r.score("Matthew", Take(5));
      r.score("Michael", Take.withQueenAndJack(3));

      expect(r.good(), isTrue);
    });
    test('A round is not good if not all hearts are taken, but the queen and the jack are taken', () {
      var g = Game.forPlayers(players4);
      var r = Round(g);
      r.score("Ted", Take(0));
      r.score("Charlotte", Take(0));
      r.score("Matthew", Take(5));
      r.score("Michael", Take.withQueenAndJack(3));

      expect(r.good(), isFalse);
    });
    test('A round is not good if all hearts and the queen are taken, but not the jack', () {
      var g = Game.forPlayers(players4);
      var r = Round(g);
      r.score("Ted", Take(0));
      r.score("Charlotte", Take(5));
      r.score("Matthew", Take(5));
      r.score("Michael", Take.withQueen(3));

      expect(r.good(), isFalse);
    });
    test('A round is not good if all hearts and the jack are taken, but not the queen', () {
      var g = Game.forPlayers(players4);
      var r = Round(g);
      r.score("Ted", Take(0));
      r.score("Charlotte", Take(5));
      r.score("Matthew", Take(5));
      r.score("Michael", Take.withJack(3));

      expect(r.good(), isFalse);
    });
    test('Calculate points for a round where nobody shoots', () {
      var g = Game.forPlayers(players4);
      var r = Round(g);

      r.score("Ted", Take(5));
      r.score("Charlotte", Take(5));
      r.score("Michael", Take(3));
      r.score("Matthew", Take.withQueenAndJack(0));

      expect(r.pointsFor("Ted"), equals(5));
      expect(r.pointsFor("Charlotte"), equals(5));
      expect(r.pointsFor("Michael"), equals(3));
      expect(r.pointsFor("Matthew"), equals(3));
    });
    test('Calculate points for a round where somebody shoots and shootPositive is false', () {
      var g = Game.forPlayers(players4);
      g.shootPositive = false; // subtract 26 from shooter's score
      var r = Round(g);

      r.score("Ted", Take(5));
      r.score("Charlotte", Take(5));
      r.score("Michael", Take(3));
      r.score("Matthew", Take.withQueenAndJack(0));

      expect(r.pointsFor("Ted"), equals(5));
      expect(r.pointsFor("Charlotte"), equals(5));
      expect(r.pointsFor("Michael"), equals(3));
      expect(r.pointsFor("Matthew"), equals(3));
    });
    test('Calculate points for a round where somebody shoots and shootPositive is true', () {
      var g = Game.forPlayers(players4);
      g.shootPositive = true; // add 26 to everybody else's score
      var r = Round(g);

      r.score("Ted", Take.withQueenAndJack(13));
      r.score("Charlotte", Take(0));
      r.score("Michael", Take(0));
      r.score("Matthew", Take(0));

      expect(r.pointsFor("Ted"), equals(-10));
      expect(r.pointsFor("Charlotte"), equals(26));
      expect(r.pointsFor("Michael"), equals(26));
      expect(r.pointsFor("Matthew"), equals(26));
    });
  });

  group('Simple Game tests', () {
    test('We get an accurate dealer index', () {
      var g3 = Game.forPlayers(["Ted", "Charlotte", "Matthew"]);
      expect(g3.dealerIdx(), equals(0));
      g3.history.add(Round(g3));
      expect(g3.dealerIdx(), equals(1));
      g3.history.add(Round(g3));
      expect(g3.dealerIdx(), equals(2));
      g3.history.add(Round(g3));
      expect(g3.dealerIdx(), equals(0));

      var g4 = Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew"]);
      expect(g4.dealerIdx(), equals(0));
      g4.history.add(Round(g4));
      expect(g4.dealerIdx(), equals(1));
      g4.history.add(Round(g4));
      expect(g4.dealerIdx(), equals(2));
      g4.history.add(Round(g4));
      expect(g4.dealerIdx(), equals(3));
      g4.history.add(Round(g4));
      expect(g4.dealerIdx(), equals(0));

      var g7 = Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew", "Lance", "Donna", "John"]);
      expect(g7.dealerIdx(), equals(0));
      g7.history.add(Round(g7));
      expect(g7.dealerIdx(), equals(1));
      g7.history.add(Round(g7));
      expect(g7.dealerIdx(), equals(2));
      g7.history.add(Round(g7));
      expect(g7.dealerIdx(), equals(3));
      g7.history.add(Round(g7));
      expect(g7.dealerIdx(), equals(4));
      g7.history.add(Round(g7));
      expect(g7.dealerIdx(), equals(5));
      g7.history.add(Round(g7));
      expect(g7.dealerIdx(), equals(6));
      g7.history.add(Round(g7));
      expect(g7.dealerIdx(), equals(0));
    });
    test("Test default settings", () {
      final game = Game.forPlayers(players4);

      expect(game.players[0].name, equals("Ted"));
      expect(game.players[1].name, equals("Charlotte"));
      expect(game.players[2].name, equals("Michael"));
      expect(game.players[3].name, equals("Matthew"));

      expect(game.gameOver(), equals(false));

      expect(game.players, hasLength(4));
      expect(game.jackOn, isTrue);
      expect(game.shootPositive, isFalse);
      expect(game.passIncreasinglyLeft, isFalse);
      expect(game.resetOnExact, isTrue);
      expect(game.lossThreshold, equals(100));
    });
    test('Pass is correct with standard pass for 4-, 5-, 6- and 7-player games', () {
      void passRotation(Game g, List<Pass> expected) {
        for (int i=0; i < expected.length; i++) {
          expect(g.currentPass(), equals(expected[i]));
          g.history.add(Round(g));
        }
      }
      passRotation(Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew"]),
          [Pass.left, Pass.right, Pass.across, Pass.hold, Pass.left]);
      passRotation(Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew", "Lance"]),
          [Pass.left, Pass.right, Pass.twoLeft, Pass.twoRight, Pass.hold, Pass.left]);
      passRotation(Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew", "Lance", "Donna"]),
          [Pass.left, Pass.right, Pass.twoLeft, Pass.twoRight, Pass.across, Pass.hold, Pass.left]);
      passRotation(Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew", "Lance", "Donna", "John"]),
          [Pass.left, Pass.right, Pass.twoLeft, Pass.twoRight, Pass.threeLeft, Pass.threeRight, Pass.hold, Pass.left]);
    });
    test('Pass is correct with increasingly left pass for 4-, 5-, 6- and 7-player games', () {
      void passRotation(Game g, List<Pass> expected) {
        expect(g.passIncreasinglyLeft, isTrue);
        for (int i=0; i < expected.length; i++) {
          //print("${g.players[g.dealerIdx()]} deals passing ${g.currentPass()}");
          expect(g.currentPass(), equals(expected[i]));
          g.history.add(Round(g));
        }
      }
      passRotation(Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew"], passIncreasinglyLeft: true),
          [Pass.left, Pass.across, Pass.right, Pass.hold, Pass.left]);
      passRotation(Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew", "Lance"], passIncreasinglyLeft: true),
          [Pass.left, Pass.twoLeft, Pass.twoRight, Pass.right, Pass.hold, Pass.left]);
      passRotation(Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew", "Lance", "Donna"], passIncreasinglyLeft: true),
          [Pass.left, Pass.twoLeft, Pass.across, Pass.twoRight, Pass.right, Pass.hold, Pass.left]);
      passRotation(Game.forPlayers(["Ted", "Charlotte", "Michael", "Matthew", "Lance", "Donna", "John"], passIncreasinglyLeft: true),
          [Pass.left, Pass.twoLeft, Pass.threeLeft, Pass.threeRight, Pass.twoRight, Pass.right, Pass.hold, Pass.left]);
    });
    // Test summarize() in various scenarios
  });

  group('Complex Game tests', () {
    // Test for exact threshold reset
    // Test that game isn't over if nobody is above 100
    // Test that game is over if somebody is above 100
  });
}
