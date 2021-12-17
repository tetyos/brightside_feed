import 'package:flutter/material.dart';
import 'package:nexth/utils/constants.dart';

class IncubatorStartPage extends StatelessWidget {

  const IncubatorStartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          WelcomeCard(),
        ],
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  const WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                Text(
                  "Incubator Section",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "In this area you find newly added content. Help by promoting content that fits here.\n ",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Incubator status",
                  style: TextStyle(
                      color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "After a threshold is met (for now 3 up-votes), the incubator status will be removed and the items will be visible in the rest of the app.\n",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Trusted sources",
                  style: TextStyle(
                      color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Currently there are two lists: one for trusted hosts and one for hosts that have not been verified yet.\n",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Upcoming: News scanner",
                  style: TextStyle(
                      color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "At a later point the incubator will also suggest automatically collected news.",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          color: kColorPrimaryLight,
        ),
      ),
    );
  }
}