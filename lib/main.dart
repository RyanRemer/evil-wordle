import 'package:evil_wordle/guess_grid.dart';
import 'package:evil_wordle/guess_keyboard.dart';
import 'package:evil_wordle/lose_dialog.dart';
import 'package:evil_wordle/main_drawer.dart';
import 'package:evil_wordle/model/evil_result.dart';
import 'package:evil_wordle/model/wordle_color.dart';
import 'package:evil_wordle/model/wordle_guess.dart';
import 'package:evil_wordle/model/wordle_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evil Wordle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final LoseDialog loseDialog = LoseDialog();

  bool hasWon = false;
  int round = 1;
  List<WordleGuess> guesses = [];
  String typedGuess = "";
  Map<String, WordleColor> keyColorMap = {};
  Set<String> answers = {};
  Set<String> guessables = {};
  Future<void>? loadAssetsFuture;
  String errorText = "";

  // The main algorithm for deciding how to color the guess
  EvilResult getResult(
    Set<String> answers,
    String guessText,
    Map<String, WordleColor> keyColorMap,
  ) {
    // Sort based on color sequence
    Map<WordleGuess, Set<String>> guessMap = {};
    for (String answerText in answers) {
      WordleGuess guess = WordleGuess.fromGuess(guessText, answerText);
      guessMap.putIfAbsent(guess, () => {}).add(answerText);
    }

    // Pick the largest group of words
    WordleGuess answerWithMostWords = guessMap.keys.first;
    for (WordleGuess currentResult in guessMap.keys) {
      int maxLength = guessMap[answerWithMostWords]!.length;
      int currentLength = guessMap[currentResult]!.length;

      if (currentLength > maxLength) {
        answerWithMostWords = currentResult;
      }
      else if (currentLength == maxLength && !currentResult.isAllCorrect()) {
        answerWithMostWords = currentResult;
      }
    }

    // Update the keyColorMap
    for (int i = 0; i < answerWithMostWords.text.length; i++) {
      String character = answerWithMostWords.text.substring(i, i + 1);
      keyColorMap.putIfAbsent(character, () => answerWithMostWords.colors[i]);

      if (answerWithMostWords.colors[i] == WordleColor.correct) {
        keyColorMap[character] = WordleColor.correct;
      }
    }

    return EvilResult(
        guessMap[answerWithMostWords]!, answerWithMostWords, keyColorMap);
  }

  @override
  Widget build(BuildContext context) {
    loadAssetsFuture ??= loadAssets();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: WordleTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: WordleTheme.backgroundColor,
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Evil Wordle"),
            Text(
              " changing the answer as you play",
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
        actions: [
          IconButton(onPressed: refreshGame, icon: const Icon(Icons.refresh))
        ],
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder(
          future: loadAssetsFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                const Divider(),
                Expanded(
                  child: GuessGrid(
                    guesses: guesses,
                    typedGuess: typedGuess,
                  ),
                ),


                Align(
                  alignment: Alignment.center,
                  child: Visibility(
                    visible: errorText.isNotEmpty,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white
                      ),
                      child: Text(errorText, style: const TextStyle(color: Colors.black),),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(hasWon ? "" : "${answers.length} possible words"),
                  ),
                ),
                Center(
                  child: GuessKeyboard(
                    keyColorMap: keyColorMap,
                    onKeyPress: (String key) {
                      if (typedGuess.length < 5) {
                        setState(() {
                          typedGuess = typedGuess + key.toLowerCase();
                        });
                      }
                    },
                    onBackspacePress: () {
                      if (typedGuess.isNotEmpty) {
                        setState(() {
                          typedGuess =
                              typedGuess.substring(0, typedGuess.length - 1);
                        });
                      }
                    },
                    onEnterPress: onEnter,
                  ),
                ),
              ],
            );
          },
        ),
    );
  }

  Future<void> loadAssets() async {
    final answersFileContent = await rootBundle.loadString(
      'assets/answers.txt',
    );
    answers = answersFileContent.split("\n").toSet();
    final guessablesFileContent = await rootBundle.loadString(
      'assets/guessables.txt',
    );
    guessables = guessablesFileContent.split("\n").toSet();
  }

  Future<void> refreshGame() async {
    setState(() {
      hasWon = false;
      round = 1;
      guesses = [];
      typedGuess = "";
      keyColorMap = {};
      loadAssetsFuture = loadAssets();
      errorText = "";
    });
  }

  void onEnter() {
    clearMessage();
    tryReshowResult();
    if (!validateInput()) {
      return;
    }

    EvilResult result = getResult(answers, typedGuess, keyColorMap);

    if (result.answers.length == 1 && result.guess.isAllCorrect()) {
      showMessage(context, "You Win");
      hasWon = true;
    } else if (round == 6) {
      loseDialog.show(context, result.answers.toList());
    }

    setState(() {
      round++;
      typedGuess = "";
      guesses.add(result.guess);
      keyColorMap = result.keyColorMap;
      answers = result.answers;
    });
  }

  void tryReshowResult() {
    if (round > 6 && hasWon) {
      showMessage(context, "You Win");
    }

    if (round > 6 && !hasWon) {
      loseDialog.show(context, answers.toList());
    }
  }

  bool validateInput() {
    if (typedGuess.length != 5) {
      return false;
    }

    if (!guessables.contains(typedGuess.toLowerCase())) {
      showMessage(context, "\"$typedGuess\" not in list", secondsToShow: 2);
      return false;
    }

    return true;
  }

  Future<void> showMessage(BuildContext context, String message, {int? secondsToShow}) async {
    setState(() {
      errorText = message;
    });

    if (secondsToShow != null) {
      await Future.delayed(Duration(seconds: secondsToShow));

      setState(() {
        errorText = "";
      });
    }    
  }

  void clearMessage() {
    setState(() {
      errorText = "";
    });
  }
}
