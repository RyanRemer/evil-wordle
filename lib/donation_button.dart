import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationButton extends StatelessWidget {
  const DonationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        textStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      onPressed: redirectToDonations,
      child: const Text("Donate"),
    );
  }

  void redirectToDonations() {
    launch("https://www.buymeacoffee.com/ryanremer");
  }
}
