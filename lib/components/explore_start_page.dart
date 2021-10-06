import 'package:flutter/material.dart';
import 'package:nexth/model/item_list_view_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:provider/provider.dart';

class ExploreStartPage extends StatelessWidget {

  const ExploreStartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WelcomeCard(),
        SizedBox(height: 10),
        CategorySelectorCard(),
      ],
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
                  "Explore Section!",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Filter content by using the predefined categories or create your own ones.",
                  style: TextStyle(color: kColorSecondaryDark),
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


class CategorySelectorCard extends StatelessWidget {

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
                for (ItemCategory itemCategory in ItemCategory.values)
                  TextButton(
                      onPressed: () {
                        Provider.of<AppState>(context, listen: false).setExplorerScreenCurrentTabAndNotify(itemCategory.index + 2);
                      },
                      child: Text(itemCategory.displayTitle))
              ],
            ),
          ),
          color: kColorPrimaryLight,
        ),
      ),
    );
  }
}