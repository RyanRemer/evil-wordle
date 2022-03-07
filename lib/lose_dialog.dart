import 'package:flutter/material.dart';

class LoseDialog {
  bool showingLoseDialog = false;
  Future<void> show(BuildContext context, List<String> answers) async {
    answers.sort();

    if (showingLoseDialog) return;
    showingLoseDialog = true;
    await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text("You Lost"),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Text("${answers.length} possible answers:"),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: answers.length < 5 ? answers.length * 48 : 320,
                      minHeight: 48,
                      minWidth: 320,
                      maxWidth: 320),
                  child: ListView.builder(
                      itemCount: answers.length,
                      itemBuilder: (context, index) {
                        return ListTile(title: Text(answers[index]));
                      }),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Okay",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                )
              ],
            ));
    showingLoseDialog = false;
  }
}
