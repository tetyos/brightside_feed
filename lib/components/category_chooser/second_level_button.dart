import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexth/components/category_chooser/category_tree.dart';
import 'package:nexth/utils/constants.dart';

class SecondLevelButton extends StatefulWidget {
  final LevelTwoCategory levelTwoCategory;
  final void Function(LevelTwoCategory, bool) callback;

  const SecondLevelButton(
      {required this.levelTwoCategory,
        required this.callback,
        Key? key})
      : super(key: key);

  @override
  _SecondLevelButtonState createState() => _SecondLevelButtonState();
}

class _SecondLevelButtonState extends State<SecondLevelButton> {
  bool isSelected = false;
  final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: Size(48, 28),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      primary: kColorPrimaryLight);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        color: Colors.transparent,
        child: ElevatedButton(
            onPressed: onPressed,
            child: Text(levelTwoCategory.displayTitle),
            style: isSelected ? style.copyWith(backgroundColor: MaterialStateProperty.all(kColorOrange1)) : style),
      ),
    );
  }

  void onPressed() {
    widget.callback(levelTwoCategory, isSelected);
    setState(() {
      isSelected = !isSelected;
    });
  }

  LevelTwoCategory get levelTwoCategory => widget.levelTwoCategory;
}