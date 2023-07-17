import 'package:flutter_test/flutter_test.dart';
import 'package:hearts_scorer/scores.dart';

void main() {
  group('Take', () {
    test('We can see if we shot the moon', () {
      var t = Take(13);
      t.queen = true;

      expect(t.shot(), isTrue);
    });
  });

  group('Simple Game tests', () {
    test('We get an accurate dealer index', () {
      var g = Game();
      g.playerList.add("Ted");
      g.playerList.add("Ted");
      g.playerList.add("Ted");
      g.playerList.add("Ted");

      expect(g.dealerIdx(), equals(0));

      g.handHistory.add(Hand(g));

      expect(g.dealerIdx(), equals(1));

      g.handHistory.add(Hand(g));

      expect(g.dealerIdx(), equals(2));

      g.handHistory.add(Hand(g));

      expect(g.dealerIdx(), equals(3));

      g.handHistory.add(Hand(g));

      expect(g.dealerIdx(), equals(0));
    });
  });

  group('Complex Game tests', () {
    test("We aren't good until all the hearts and queen are assigned", () {
      var g = Game();
      g.jack = true;
    });
  });
}
