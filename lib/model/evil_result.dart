import 'package:evil_wordle/model/wordle_color.dart';
import 'package:evil_wordle/model/wordle_guess.dart';

class EvilResult {
  Set<String> answers;
  WordleGuess guess;
  Map<String, WordleColor> keyColorMap;

  EvilResult(this.answers, this.guess, this.keyColorMap);
}