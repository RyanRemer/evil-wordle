import 'package:evil_wordle/model/wordle_color.dart';

class WordleGuess {
  String text;
  List<WordleColor> colors;
  
  WordleGuess(this.text, this.colors);

  factory WordleGuess.fromGuess(String guessText, String answerText) {
    guessText = guessText.toLowerCase();
    answerText = answerText.toLowerCase();

    if (guessText.length != answerText.length) {
      throw "Guess text length is different from answer text length";
    }

    List<int> guessCharacters = guessText.codeUnits.toList();
    List<int> answerCharacters = answerText.codeUnits.toList();

    int wordLength = guessText.length;
    List<WordleColor> colors = List.filled(wordLength, WordleColor.absent);
    List<bool> isMarked = List.filled(wordLength, false); //for double letter case

    // determine correct letters
    for (int i = 0; i < wordLength; i++) {
      if (guessCharacters[i] == answerCharacters[i]) {
        colors[i] = WordleColor.correct;
        isMarked[i] = true;
      }
    }   

    // determine present letters (beware double letter use case)
    for (int i = 0; i < guessCharacters.length; i++) {
      for (int j = 0; j < answerCharacters.length; j++) {
        if (guessCharacters[i] == answerCharacters[j] && !isMarked[j]) {
          colors[i] = WordleColor.present;
          isMarked[j] = true;
        }
      }
    }

    return WordleGuess(guessText, colors);
  }

  bool isAllCorrect() {
    for (WordleColor color in colors) {
      if (color != WordleColor.correct) {
        return false;
      }
    }
    return true;
  }

  @override 
  int get hashCode => colors.fold<int>(0, (previousValue, element) => previousValue + element.index) + text.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WordleGuess && hasSameColors(other) && text == other.text;

  bool hasSameColors(WordleGuess other) {
    if (colors.length != other.colors.length) return false;

      for (int i = 0; i < colors.length; i++) {
        if (colors[i] != other.colors[i]) {
          return false;
        }
      }
      return true;
  }
}