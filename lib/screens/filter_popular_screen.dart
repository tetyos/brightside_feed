import 'package:flutter/material.dart';
import 'package:brightside_feed/bloc/item_list_model_cubit.dart';
import 'package:brightside_feed/model/list_models/explore_popular_model.dart';
import 'package:brightside_feed/model/model_manager.dart';
import 'package:brightside_feed/model/vote_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterPopularScreen extends StatefulWidget {
  const FilterPopularScreen({Key? key}) : super(key: key);

  @override
  State<FilterPopularScreen> createState() => _FilterPopularScreenState();
}

class _FilterPopularScreenState extends State<FilterPopularScreen> {
  late Periodicity currentPeriodicity;
  late VoteType currentVoteType;

  @override
  void initState() {
    super.initState();
    currentPeriodicity = ModelManager.instance.explorePopularModel.periodicity;
    currentVoteType = ModelManager.instance.explorePopularModel.votingType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      decoration: BoxDecoration(
        color: Color(0xFFfafafa),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Change filter',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 20),
          renderPeriodChooser(context),
          SizedBox(height: 10),
          renderVoteChooser(context),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              bool isVoteTypeChanged =
                  ModelManager.instance.explorePopularModel.votingType != currentVoteType;
              bool isPeriodicityChanged =
                  ModelManager.instance.explorePopularModel.periodicity != currentPeriodicity;
              if (isVoteTypeChanged || isPeriodicityChanged) {
                context
                    .read<ItemListModelCubit>()
                    .changeFilter(currentPeriodicity, currentVoteType);
              }
              Navigator.pop(context);
            },
            child: Text('Go'),
          ),
        ],
      ),
    );
  }

  Widget renderPeriodChooser(BuildContext context) {
    return DropdownButton<Periodicity>(
      value: currentPeriodicity,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Color(0xFFBDBDBD),
      ),
      onChanged: (Periodicity? newValue) {
        if (newValue != null) {
          setState(() {
            currentPeriodicity = newValue;
          });
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

  Widget renderVoteChooser(BuildContext context) {
    return DropdownButton<VoteType>(
      value: currentVoteType,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Color(0xFFBDBDBD),
      ),
      onChanged: (VoteType? newValue) {
        if (newValue != null) {
          setState(() {
            currentVoteType = newValue;
          });
        }
      },
      items: VoteType.values.map<DropdownMenuItem<VoteType>>((VoteType value) {
        return DropdownMenuItem<VoteType>(
          value: value,
          child: Text(value.displayTitle),
        );
      }).toList(),
    );
  }
}
