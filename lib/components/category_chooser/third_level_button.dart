import 'package:flutter/material.dart';
import 'package:brightside_feed/components/category_chooser/category_cubit.dart';
import 'package:brightside_feed/model/category_tree_model.dart';
import 'package:brightside_feed/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: Size(48, 25),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      primary: kColorSecondaryLight);

  @override
  void initState() {
    super.initState();
    List<CategoryElement> initElements = context.read<CategoryCubit>().state;
    if (initElements.contains(widget.levelThreeCategory)) {
      isSelected = true;
    }
  }

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
            child: Text(levelThreeCategory.displayTitle),
            style: isSelected ? style.copyWith(backgroundColor: MaterialStateProperty.all(kColorOrange1)) : style),
      ),
    );
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