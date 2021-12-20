import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexth/components/category_chooser/category_cubit.dart';
import 'package:nexth/components/category_chooser/category_tree.dart';
import 'package:nexth/model/category_tree_non_tech.dart';
import 'package:nexth/model/category_tree_tech.dart';
import 'package:nexth/utils/constants.dart';

class CategoryChooser extends StatefulWidget {
  final Function(List<CategoryElement>) callback;
  
  const CategoryChooser({Key? key, required this.callback}) : super(key: key);

  @override
  _CategoryChooserState createState() => _CategoryChooserState();
}

class _CategoryChooserState extends State<CategoryChooser> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit(callback: widget.callback),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CurrentSelectionList(),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: rootPressed,
            child: Text(rootCategory.displayTitle),
            style: isRootSelected
                ? ElevatedButton.styleFrom(primary: kColorAccentOrange) : null),
        if (isRootSelected) renderLevelTwo(),
        if (isRootSelected) SizedBox(height: 10),
        if (allSelectedLevelTwoCategories.isNotEmpty) renderLevelThree(),
        if (allSelectedLevelTwoCategories.isNotEmpty) SizedBox(height: 10),
      ],
    );
  }

  RootCategory get rootCategory => widget.rootModel;

  Widget renderLevelTwo() {
    List<LevelTwoCategory> levelTwoCategories = rootCategory.levelTwoCategories;
    List<Widget> levelTwoButtons = [];
    for (LevelTwoCategory levelTwoCategory in levelTwoCategories) {
      levelTwoButtons.add(
        LevelTwoButton(
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

class LevelTwoButton extends StatefulWidget {
  final LevelTwoCategory levelTwoCategory;
  final void Function(LevelTwoCategory, bool) callback;

  const LevelTwoButton(
      {required this.levelTwoCategory,
      required this.callback,
      Key? key})
      : super(key: key);

  @override
  _LevelTwoButtonState createState() => _LevelTwoButtonState();
}

class _LevelTwoButtonState extends State<LevelTwoButton> {
  bool isSelected = false;
  final ButtonStyle style =
  ElevatedButton.styleFrom(
      minimumSize: Size(0, 0),
      // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      primary: kColorPrimaryLight);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(levelTwoCategory.displayTitle),
        // style: style.copyWith(side: MaterialStateProperty.all(BorderSide(width: 1.0, color: Colors.blueAccent,))));
        style: isSelected ? style.copyWith(backgroundColor: MaterialStateProperty.all(kColorAccentOrange)) : style);
  }

  void onPressed() {
    widget.callback(levelTwoCategory, isSelected);
    setState(() {
      isSelected = !isSelected;
    });
  }

  LevelTwoCategory get levelTwoCategory => widget.levelTwoCategory;
}

class LevelThreeButton extends StatefulWidget {
  final LevelThreeCategory levelThreeCategory;

  const LevelThreeButton(
      {required this.levelThreeCategory,
        Key? key})
      : super(key: key);

  @override
  _LevelThreeButtonState createState() => _LevelThreeButtonState();
}

class _LevelThreeButtonState extends State<LevelThreeButton> {
  bool isSelected = false;
  final ButtonStyle style =
  ElevatedButton.styleFrom(
      minimumSize: Size(0, 0),
      // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      primary: kColorPrimaryLight);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(levelThreeCategory.displayTitle),
        // style: style.copyWith(side: MaterialStateProperty.all(BorderSide(width: 1.0, color: Colors.blueAccent,))));
        style: isSelected ? style.copyWith(backgroundColor: MaterialStateProperty.all(kColorAccentOrange)) : style);
  }

  void onPressed() {
    setState(() {
      if (isSelected) {
        context.read<CategoryCubit>().removeElement(levelThreeCategory);
      } else {
        context.read<CategoryCubit>().addElement(levelThreeCategory);
      }
      isSelected = !isSelected;
    });
  }

  LevelThreeCategory get levelThreeCategory => widget.levelThreeCategory;
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
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    ),
                    child: Text(categoryElement.displayTitle),
                  )
              ],
            ),
            renderDivider(),
          ],
        );
      },
    );
  }

  Widget renderDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(color: Colors.black),
    );
  }
}
