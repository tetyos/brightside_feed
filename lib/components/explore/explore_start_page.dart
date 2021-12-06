import 'package:flutter/material.dart';
import 'package:nexth/components/intro_card.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:provider/provider.dart';

class ExploreStartPage extends StatelessWidget {

  const ExploreStartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          IntroCard(title: "Explore Section", message: "Filter content by using the predefined categories or create your own custom filter."),
          SizedBox(height: 10),
          CustomTabsOverviewCard(),
          CategoryOverviewCard(),
        ],
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
                            .setExplorerScreenCurrentTabAndNotify(itemCategory.index + 4);
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