// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:evil_wordle/model/wordle_color.dart';
import 'package:evil_wordle/model/wordle_guess.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Double letter coloring is correct: bully vs loops', () {
    WordleGuess guess = WordleGuess.fromGuess("bully", "loops");
    expect(
        WordleGuess("bully", [
              WordleColor.absent,
              WordleColor.absent,
              WordleColor.present,
              WordleColor.absent,
              WordleColor.absent,
            ]) ==
            guess,
        isTrue);
  });

  test('Double letter coloring is correct: vally vs value', () {
    WordleGuess guess = WordleGuess.fromGuess("vally", "value");
    expect(
        WordleGuess("vally", [
              WordleColor.correct,
              WordleColor.correct,
              WordleColor.correct,
              WordleColor.absent,
              WordleColor.absent,
            ]) ==
            guess,
        isTrue);
  });

  test('Double letter coloring is correct: puppy vs xppxy', () {
    WordleGuess guess = WordleGuess.fromGuess("puppy", "xppxx");
    expect(
        WordleGuess("puppy", [
              WordleColor.present,
              WordleColor.absent,
              WordleColor.correct,
              WordleColor.absent,
              WordleColor.absent,
            ]) ==
            guess,
        isTrue);
  });
}
