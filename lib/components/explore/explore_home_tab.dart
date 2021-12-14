import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexth/components/intro_card.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:provider/provider.dart';

class ExploreHomeTab extends StatelessWidget {

  const ExploreHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          IntroCard(title: "Explore Section", message: "Discover content by using predefined sections or create your own filter."),
          CustomTabsOverviewCard(),
          CategoryOverviewCard(),
          OtherTabsOverviewCard(),
        ],
      ),
    );
  }
}

class OtherTabsOverviewCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                children: [
                  Text("Others", style: TextStyle(fontSize: 20)),
                  // SizedBox(height: 10,),
                  ListTile(
                    leading: Icon(Icons.favorite_border_outlined),
                    title: Text('Your likes'),
                    onTap: () {Provider.of<AppState>(context, listen: false)
                        .setExplorerScreenCurrentTabAndNotify(1);},
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.award),
                    title: Text('Popular'),
                    onTap: () {Provider.of<AppState>(context, listen: false)
                        .setExplorerScreenCurrentTabAndNotify(1);},
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

class CustomTabsOverviewCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  Text("Custom filter", style: TextStyle(fontSize: 20)),
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
            padding: const EdgeInsets.all(10.0),
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