import 'dart:math';

import 'package:evil_wordle/model/wordle_color.dart';
import 'package:evil_wordle/model/wordle_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GuessKeyboard extends StatelessWidget {
  static const List<String> topRowLetters = [
    "Q",
    "W",
    "E",
    "R",
    "T",
    "Y",
    "U",
    "I",
    "O",
    "P"
  ];
  static const List<String> middleRowLetters = [
    "A",
    "S",
    "D",
    "F",
    "G",
    "H",
    "J",
    "K",
    "L"
  ];
  static const List<String> bottowRowLetters = [
    "Z",
    "X",
    "C",
    "V",
    "B",
    "N",
    "M"
  ];
  static const EdgeInsets keyMargins = EdgeInsets.all(2);
  static const EdgeInsets keyboardPadding = EdgeInsets.all(8);

  final Map<String, WordleColor> keyColorMap;
  final ValueSetter<String>? onKeyPress;
  final VoidCallback? onEnterPress;
  final VoidCallback? onBackspacePress;
  final FocusNode focusNode = FocusNode();

  GuessKeyboard(
      {Key? key,
      required this.keyColorMap,
      this.onKeyPress,
      this.onEnterPress,
      this.onBackspacePress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);

    return RawKeyboardListener(
      focusNode: focusNode,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints contraints) {
        
        double totalWidth = min(contraints.maxWidth, 520);
        int maxKeysInRow = topRowLetters.length;
        double totalKeySpace = totalWidth - maxKeysInRow * (keyMargins.horizontal) - keyboardPadding.horizontal;

        double keyAspectRatio = 5/3;

        double keyWidth = totalKeySpace / maxKeysInRow;
        double keyHeight = keyAspectRatio * keyWidth;
        double keyWidthBig = keyWidth * 1.5;

        List<Widget> topRowKeys =
            buildKeyboardKeys(topRowLetters, keyHeight, keyWidth);
        List<Widget> middleRowKeys =
            buildKeyboardKeys(middleRowLetters, keyHeight, keyWidth);
        List<Widget> bottomRowKeys = [
          buildEnterKey(keyHeight, keyWidthBig),
          ...buildKeyboardKeys(bottowRowLetters, keyHeight, keyWidth),
          buildBackspaceKey(keyHeight, keyWidthBig),
        ];

        return Container(
          margin: keyboardPadding,
          height: keyHeight * 3 + keyMargins.top * 3 + keyMargins.bottom * 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: topRowKeys),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: middleRowKeys),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bottomRowKeys),
            ],
          ),
        );
      }),
      onKey: (RawKeyEvent rawKeyEvent) {
        String? character = rawKeyEvent.character;
        if (character != null) {
          onKeyPress?.call(character);
        }

        if (rawKeyEvent.isKeyPressed(LogicalKeyboardKey.backspace)) {
          onBackspacePress?.call();
        }

        if (rawKeyEvent.isKeyPressed(LogicalKeyboardKey.enter)) {
          onEnterPress?.call();
        }
      },
    );
  }

  List<Widget> buildKeyboardKeys(
      List<String> letters, double keyHeight, double keyWidth) {
    return List.generate(letters.length,
        (index) => buildKeyboardKey(letters[index], keyHeight, keyWidth));
  }

  Widget buildKeyboardKey(String text, double keyHeight, double keyWidth) {
    return InkWell(
      child: Padding(
        padding: keyMargins,
        child: Ink(
          height: keyHeight,
          width: keyWidth,
          child: Center(child: Text(text)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: getBackgroundColor(keyColorMap[text.toLowerCase()] ??
                keyColorMap[text.toUpperCase()]),
          ),
        ),
      ),
      onTap: () {
        onKeyPress?.call(text);
      },
    );
  }

  Widget buildEnterKey(double keyHeight, double keyWidth) {
    return InkWell(
      child: Padding(
        padding: keyMargins,
        child: Ink(
          height: keyHeight,
          width: keyWidth,
          child: const Center(
              child: Text(
            "ENTER",
            style: TextStyle(fontSize: 12),
          )),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: WordleTheme.keyColor,
          ),
        ),
      ),
      onTap: onEnterPress,
    );
  }

  Widget buildBackspaceKey(double keyHeight, double keyWidth) {
    return InkWell(
      child: Padding(
        padding: keyMargins,
        child: Ink(
          height: keyHeight,
          width: keyWidth,
          child: const Center(
              child: Icon(
            Icons.backspace_outlined,
            size: 20,
          )),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: WordleTheme.keyColor,
          ),
        ),
      ),
      onTap: onBackspacePress,
    );
  }

  Color getBackgroundColor(WordleColor? color) {
    switch (color) {
      case WordleColor.correct:
        return WordleTheme.colorCorrect;
      case WordleColor.present:
        return WordleTheme.colorPresent;
      case WordleColor.absent:
        return WordleTheme.colorAbsent;
      default:
        return WordleTheme.keyColor;
    }
  }
}
