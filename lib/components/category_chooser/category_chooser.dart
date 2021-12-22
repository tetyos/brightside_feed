import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexth/components/category_chooser/second_level_button.dart';
import 'package:nexth/components/category_chooser/category_cubit.dart';
import 'package:nexth/model/category_tree_model.dart';
import 'package:nexth/components/category_chooser/third_level_button.dart';
import 'package:nexth/model/category_tree_non_tech.dart';
import 'package:nexth/model/category_tree_tech.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/ui_utils.dart';

class CategoryChooser extends StatefulWidget {
  final Function(List<CategoryElement>) callback;
  final List<CategoryElement> initElements;
  
  const CategoryChooser({Key? key, required this.callback, this.initElements = const []}) : super(key: key);

  @override
  _CategoryChooserState createState() => _CategoryChooserState();
}

class _CategoryChooserState extends State<CategoryChooser> {
  late final CategoryCubit _categoryCubit = CategoryCubit(callback: widget.callback, initElements: widget.initElements);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _categoryCubit,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RootCategoryChooser(rootModel: kTechCategory),
            RootCategoryChooser(rootModel: kNonTechCategory),
          ],
        ),
      ),
    );
  }
}

class RootCategoryChooser extends StatefulWidget {

  final RootCategory rootModel;

  const RootCategoryChooser({required this.rootModel, Key? key}) : super(key: key);

  @override
  _RootCategoryChooserState createState() => _RootCategoryChooserState();
}

class _RootCategoryChooserState extends State<RootCategoryChooser> {
  bool isRootSelected = false;
  final List<LevelTwoCategory> allSelectedLevelTwoCategories = [];
  final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: Size(80, 36),
      padding: EdgeInsets.symmetric(horizontal: 10),
      primary: kColorPrimary);

  @override
  void initState() {
    super.initState();
    List<CategoryElement> initElements = context.read<CategoryCubit>().state;
    if (initElements.contains(widget.rootModel)) {
      isRootSelected = true;
    }
    for (CategoryElement categoryElement in initElements) {
      if (categoryElement is LevelTwoCategory && widget.rootModel.levelTwoCategories.contains(categoryElement)) {
        allSelectedLevelTwoCategories.add(categoryElement);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: rootPressed,
            child: Text(rootCategory.displayTitle),
            style: isRootSelected ? style.copyWith(backgroundColor: MaterialStateProperty.all(kColorOrange1)) : style),
        if (isRootSelected) renderLevelTwo(),
        if (allSelectedLevelTwoCategories.isNotEmpty) renderLevelThree(),
      ],
    );
  }

  RootCategory get rootCategory => widget.rootModel;

  Widget renderLevelTwo() {
    List<LevelTwoCategory> levelTwoCategories = rootCategory.levelTwoCategories;
    List<Widget> levelTwoButtons = [];
    for (LevelTwoCategory levelTwoCategory in levelTwoCategories) {
      levelTwoButtons.add(
        SecondLevelButton(
          levelTwoCategory: levelTwoCategory,
          callback: levelTwoPressed,
        ),
      );
    }
    return Wrap(
      spacing:2,
      runSpacing: 0,
      alignment: WrapAlignment.center,
      children: levelTwoButtons,
    );
  }

  Widget renderLevelThree() {
    List<Widget> levelThreeButtons = [];
    for (LevelTwoCategory levelTwoCategory in allSelectedLevelTwoCategories) {
      List<LevelThreeCategory> levelThreeCategories = levelTwoCategory.levelThreeElements;

      for (LevelThreeCategory levelThreeCategory in levelThreeCategories) {
        levelThreeButtons.add(
          LevelThreeButton(
            levelThreeCategory: levelThreeCategory,
          ),
        );
      }
    }

    return Wrap(
      spacing:2,
      runSpacing: 0,
      alignment: WrapAlignment.center,
      children: levelThreeButtons,
    );
  }

  void rootPressed() {
    setState(() {
      if (isRootSelected) {
        unselectRoot();
      } else {
        context.read<CategoryCubit>().addElement(rootCategory);
      }
      isRootSelected = !isRootSelected;
    });
  }

  void levelTwoPressed(LevelTwoCategory levelTwoCategory, bool isSelected) {
    setState(() {
      if (isSelected) {
        unselectLevelTwoElement(levelTwoCategory);
      } else {
        context.read<CategoryCubit>().addElement(levelTwoCategory);
        allSelectedLevelTwoCategories.add(levelTwoCategory);
      }
    });
  }

  void unselectLevelTwoElement(LevelTwoCategory levelTwoCategory) {
    List<CategoryElement> elementsToRemove = [];
    elementsToRemove.add(levelTwoCategory);
    elementsToRemove.addAll(levelTwoCategory.levelThreeElements);
    context.read<CategoryCubit>().removeElements(elementsToRemove);
    allSelectedLevelTwoCategories.remove(levelTwoCategory);
  }

  void unselectRoot() {
    List<CategoryElement> elementsToRemove = [];
    elementsToRemove.add(rootCategory);
    elementsToRemove.addAll(allSelectedLevelTwoCategories);
    allSelectedLevelTwoCategories.forEach((levelTwoElement) {
      elementsToRemove.addAll(levelTwoElement.levelThreeElements);
    });
    context.read<CategoryCubit>().removeElements(elementsToRemove);
    allSelectedLevelTwoCategories.clear();
  }
}


class CurrentSelectionList extends StatelessWidget {
  const CurrentSelectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, List<CategoryElement>>(
      builder: (context, selectedCategories) {
        if (selectedCategories.isEmpty) {
          return SizedBox.shrink();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 2,
              runSpacing: 2,
              children: [
                Text("Selected: "),
                for (CategoryElement categoryElement in selectedCategories)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: kColorSecondaryLight,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    ),
                    child: Text(categoryElement.displayTitle),
                  )
              ],
            ),
            UIUtils.renderDivider(),
          ],
        );
      },
    );
  }


}
