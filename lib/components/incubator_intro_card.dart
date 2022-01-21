import 'package:flutter/material.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncubatorIntroCard extends StatefulWidget {
  const IncubatorIntroCard();

  @override
  State<IncubatorIntroCard> createState() => _IncubatorIntroCardState();
}

class _IncubatorIntroCardState extends State<IncubatorIntroCard> {
  bool isShowCard = true;

  @override
  void initState() {
    super.initState();
    isShowCard = Provider.of<AppState>(context, listen: false).isShowIncubatorIntro;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          child: isShowCard ? renderCard() : renderMinimizedCard(),
          color: kColorPrimaryLight,
        ),
      ),
    );
  }

  toggleShowCardButton() async {
    setState(() {
      isShowCard = !isShowCard;
    });
    Provider.of<AppState>(context, listen: false).isShowIncubatorIntro = isShowCard;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kLocalStorageShowIncubatorIntro, isShowCard);
  }

  Widget renderCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 22.0, left: 15, right: 15),
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Text(
                "Incubator Section",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [IconButton(onPressed: toggleShowCardButton, icon: Icon(Icons.keyboard_arrow_up, color: kColorWhiteTransparent))],
              )
            ],
          ),
          SizedBox(height: 0),
          Text(
            "In this area you find newly added content. Help by promoting content that fits here.\n ",
            style: TextStyle(color: Colors.black87, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Text(
            "Incubator status",
            style: TextStyle(
                color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "After a threshold is met (for now 3 up-votes), the incubator status will be removed and the items will be visible in the rest of the app.\n",
            style: TextStyle(color: Colors.black87, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Text(
            "Trusted sources",
            style: TextStyle(
                color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "Currently there are two lists: one for trusted hosts and one for hosts that have not been verified yet.\n",
            style: TextStyle(color: Colors.black87, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Text(
            "Upcoming: News scanner",
            style: TextStyle(
                color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "At a later point the incubator will also suggest automatically collected news.",
            style: TextStyle(color: Colors.black87, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget renderMinimizedCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 15),
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Text(
                "Incubator Section",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [IconButton(onPressed: toggleShowCardButton, icon: Icon(Icons.keyboard_arrow_down, color: kColorWhiteTransparent))],
              )
            ],
          ),
        ],
      ),
    );
  }
}