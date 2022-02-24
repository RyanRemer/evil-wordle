import 'package:evil_wordle/model/wordle_color.dart';
import 'package:evil_wordle/model/wordle_guess.dart';
import 'package:evil_wordle/model/wordle_theme.dart';
import 'package:flutter/material.dart';

class GuessGrid extends StatelessWidget {
  static TextStyle cellStyle =
      const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  static EdgeInsets cellMargin = const EdgeInsets.all(4);

  final List<WordleGuess> guesses;
  final String typedGuess;

  const GuessGrid({Key? key, required this.guesses, required this.typedGuess,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: ((context, constraints) => Container(
          margin: const EdgeInsets.all(16),
          width: constraints.maxHeight * 3/4,

          child: AbsorbPointer(
            child: GridView.count(
              crossAxisCount: 5,
              children: buildGridChildren(context),
            ),
          ),
        )
        ),
      ),
    );
  }

  List<Widget> buildGridChildren(BuildContext context) {
    int numberOfRows = 6;
    int numberOfLetters = 5;

    List<Widget> cells = [];

    for (int row = 0; row < numberOfRows; row++) {
      for (int letterIndex = 0; letterIndex < numberOfLetters; letterIndex++) {
        if (row < guesses.length) {
          WordleGuess guess = guesses[row];
          String cellLetter =
              guess.text.substring(letterIndex, letterIndex + 1);
          WordleColor color = guess.colors[letterIndex];

          cells.add(buildGridCell(context, cellLetter, color));
        } else if (row == guesses.length && letterIndex < typedGuess.length) {
          cells.add(buildEmptyCell(
              context, typedGuess.substring(letterIndex, letterIndex + 1)));
        } else {
          cells.add(buildEmptyCell(context));
        }
      }
    }

    return cells;
  }

  Widget buildGridCell(BuildContext context, String letter, WordleColor color) {
    return Container(
      margin: cellMargin,
      color: getBackgroundColor(color),
      child: Center(
          child: Text(
        letter.toUpperCase(),
        style: cellStyle,
      )),
    );
  }

  Color getBackgroundColor(WordleColor color) {
    switch (color) {
      case WordleColor.correct:
        return WordleTheme.colorCorrect;
      case WordleColor.present:
        return WordleTheme.colorPresent;
      case WordleColor.absent:
        return WordleTheme.colorAbsent;
    }
  }

  Widget buildEmptyCell(BuildContext context, [String? letter]) {
    return Container(
      margin: cellMargin,
      child: Center(
          child: Text(
        letter?.toUpperCase() ?? "",
        style: cellStyle,
      )),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              letter == null ? WordleTheme.borderColor : WordleTheme.typedBorderColor,
          width: 2.0,
        ),
      ),
    );
  }
}
