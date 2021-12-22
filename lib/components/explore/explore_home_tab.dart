import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexth/bloc/item_list_model_cubit.dart';
import 'package:nexth/components/intro_card.dart';
import 'package:nexth/model/category_tree_model.dart';
import 'package:nexth/model/category_tree_non_tech.dart';
import 'package:nexth/model/category_tree_tech.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
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
          SectionsOverviewCard(),
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
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
                        .setExplorerScreenCurrentTabAndNotify(4);},
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

class SectionsOverviewCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  Text("Sections", style: TextStyle(fontSize: 20)),
                  ListTile(
                    leading: Icon(Icons.favorite_border_outlined),
                    dense: true,
                    title: Text('Your likes', style: TextStyle(fontSize: 16)),
                    onTap: () {Provider.of<AppState>(context, listen: false)
                        .setExplorerScreenCurrentTabAndNotify(0);},
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.award),
                    dense: true,
                    title: Text('Popular', style: TextStyle(fontSize: 16)),
                    onTap: () {Provider.of<AppState>(context, listen: false)
                        .setExplorerScreenCurrentTabAndNotify(2);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Divider(color: Colors.black),
                  ),
                  Text("By Category", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  CategoryQuickLinks()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class CategoryQuickLinks extends StatelessWidget {
  const CategoryQuickLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(spacing: 2, runSpacing: 0, crossAxisAlignment: WrapCrossAlignment.center, alignment: WrapAlignment.start, children: [
          CategoryButton(
            categoryElement: kTechCategory,
          ),
          for (CategoryElement categoryElement in kTechCategory.levelTwoCategories)
            CategoryButton(categoryElement: categoryElement)
        ]),
        Wrap(spacing: 2, runSpacing: 0, crossAxisAlignment: WrapCrossAlignment.center, alignment: WrapAlignment.start, children: [
          CategoryButton(
            categoryElement: kNonTechCategory,
          ),
          for (CategoryElement categoryElement in kNonTechCategory.levelTwoCategories)
            CategoryButton(categoryElement: categoryElement)
        ]),
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  final CategoryElement categoryElement;
  const CategoryButton({required this.categoryElement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handlePressed(context),
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        color: Colors.transparent,
        child: ElevatedButton(
            onPressed: () => handlePressed(context),
            child: Text(categoryElement.displayTitle),
            style: buildButtonStyle(context)),
      ),
    );
  }

  ButtonStyle buildButtonStyle(BuildContext context) {
    if (categoryElement is RootCategory) {
      return ElevatedButton.styleFrom(
        minimumSize: Size(48, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        primary: Theme.of(context).primaryColor,
      );
    } else if (categoryElement is LevelTwoCategory) {
      return ElevatedButton.styleFrom(
          minimumSize: Size(48, 28),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          primary: kColorPrimaryLight);
    } else {
      return ElevatedButton.styleFrom(
          minimumSize: Size(48, 25),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          primary: kColorSecondaryLight);
    }
  }

  void handlePressed(BuildContext context) {
    context.read<ItemListModelCubit>().changeCategory(categoryElement);
    Provider.of<AppState>(context, listen: false).setExplorerScreenCurrentTabAndNotify(3);
  }
}

