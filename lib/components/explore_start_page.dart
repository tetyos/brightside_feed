import 'package:flutter/material.dart';
import 'package:nexth/model/item_list_view_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:provider/provider.dart';

class ExploreStartPage extends StatelessWidget {

  const ExploreStartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          WelcomeCard(),
          SizedBox(height: 10),
          CustomTabsOverviewCard(),
          CategoryOverviewCard(),
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
                  "Explore Section",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Filter content by using the predefined categories or create your own custom filter.",
                  style: TextStyle(color: kColorSecondaryDark,),
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

class CustomTabsOverviewCard extends StatelessWidget {

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
                  Text("Custom filters", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10,),
                  Text("You have not configured any filter so far."),
                  ListTile(
                    leading: Icon(Icons.add_outlined),
                    title: Text('Click to add custom filter.'),
                    onTap: () {Provider.of<AppState>(context, listen: false)
                        .setExplorerScreenCurrentTabAndNotify(0);},
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

class CategoryOverviewCard extends StatelessWidget {

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
                  Text("Categories", style: TextStyle(fontSize: 20)),
                  for (ItemCategory itemCategory in ItemCategory.values)
                    ListTile(
                      leading: Icon(itemCategory.icon),
                      title: Text(itemCategory.displayTitle),
                      onTap: () {
                        Provider.of<AppState>(context, listen: false)
                            .setExplorerScreenCurrentTabAndNotify(itemCategory.index + 2);
                      },
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