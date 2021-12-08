import 'package:flutter/material.dart';
import 'package:nexth/model/explore_popular_model.dart';
import 'package:nexth/model/model_manager.dart';

class FilterPopularScreen extends StatelessWidget {
  const FilterPopularScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Change filter',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 20),
        renderPeriodChooser(),
        SizedBox(height: 10),
        // LanguageDropdownButton(callback: (String? value) => _languageSelection = value),
        SizedBox(height: 30),
      ],
    );
  }

  Widget renderPeriodChooser() {
    Periodicity currentPeriodicity = ModelManager.instance.explorePopularModel.periodicity;

    return DropdownButton<Periodicity>(
      value: currentPeriodicity,
      //icon: const Icon(Icons.arrow_downward),
      //iconSize: 24,
      //elevation: 16,
      // isExpanded: true,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Color(0xFFBDBDBD),
      ),
      onChanged: (Periodicity? newValue) {
        if (newValue != null) {
          // context.read<PopularFilterCubit>().changeFilter(newValue, VoteType.impact);
          // setState(() {
          //   currentSelection = newValue;
          // });
        }
      },
      items: Periodicity.values.map<DropdownMenuItem<Periodicity>>((Periodicity value) {
        return DropdownMenuItem<Periodicity>(
          value: value,
          child: Text(value.displayTitle),
        );
      }).toList(),
    );
  }
}
