import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: Image.asset("assets/icons/banner.png")),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Evil Wordle is Wordle but the computer is cheating. Inspired by difficult Wordle words, the computer will change the word (techinally words) in the background to make the game as hard as possible while keeping the answer as a common english word. I hope you enjoy!",
            ),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text("Donate"),
            onTap: redirectToDonations,
          ),
          ListTile(
            leading: const Icon(Icons.extension_sharp),
            title: const Text("Offical Wordle"),
            onTap: redirectToWordle,
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/linkedin.png",
              height: 24,
              width: 24,
            ),
            title: const Text("Linkedin"),
            onTap: redirectToLinkedin,
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text("Source Code"),
            onTap: redirectToSourceCode,
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text("Give Feedback"),
            onTap: redirectToFeedbackForm,
          ),
        ],
      ),
    );
  }

  void redirectToLinkedin() {
    launch("https://www.linkedin.com/in/ryan-remer-475261171/");
  }

  void redirectToSourceCode() {
    launch("https://github.com/RyanRemer/evil-wordle");
  }

  void redirectToFeedbackForm() {
    launch(
        "https://docs.google.com/forms/d/e/1FAIpQLScF2gzO0UkQnxc92-_O_LxEEUSAWRhZi5WhMhjlWBobsvSqyQ/viewform?usp=sf_link");
  }

  void redirectToWordle() {
    launch("https://www.nytimes.com/games/wordle/index.html");
  }

  void redirectToDonations() {
    launch("https://www.buymeacoffee.com/ryanremer");
  }
}
