import 'package:flutter/material.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/ui_utils.dart';

class ExploreAddFilterTab extends StatelessWidget {

  const ExploreAddFilterTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          WelcomeCard(),
          SizedBox(height: 10),
          ConfigureFilterCard()
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
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Add a custom filter.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "You can configure you own filter here, in order to have fast access to the content which you like the most.",
                    style: TextStyle(color: kColorSecondaryDark),
                  ),
                ],
              ),
            ),
          ),
          color: kColorPrimaryLight,
        ),
      ),
    );
  }
}

class ConfigureFilterCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Center(
              child: Column(
                children: [
                  Text("Properties of filters", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10,),
                  ListTile(
                    leading: Icon(Icons.add_outlined),
                    title: Text('Click to add a filter-property.'),
                    onTap: () {UIUtils.showSnackBar("Not yet implemented.", context);},
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}