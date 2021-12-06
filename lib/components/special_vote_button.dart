import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/vote_model.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/ui_utils.dart';

class SpecialVoteButton extends StatelessWidget {
  final ItemData itemData;
  final void Function({required VoteModel voteModel}) onPressed;
  final Color noVoteColor;
  final Color hasVotesColor;
  final Color userVotedColor;

  SpecialVoteButton(
      {required this.itemData,
      required this.onPressed,
      required this.noVoteColor,
      required this.hasVotesColor,
      required this.userVotedColor});

  @override
  Widget build(BuildContext context) {
    bool userVotedImpact = itemData.impactVoteModel.voted;
    bool userVotedWellWritten = false;
    bool userVotedInspiring = false;

    int sumSpecialVotes = itemData.impactVoteModel.numberOfRatings;
    bool hasVotes = sumSpecialVotes > 0;
    bool hasUserVoted = userVotedImpact || userVotedWellWritten || userVotedInspiring;
    Color menuButtonColor = hasVotes
        ? hasUserVoted
            ? userVotedColor
            : hasVotesColor
        : noVoteColor;

    return PopupMenuButton<String>(
      child: Row(
        children: [
          if (!hasVotes) SizedBox(width: 3),
          Icon(Icons.emoji_events_outlined, color: menuButtonColor),
          SizedBox(width: 2),
          if (hasVotes)
            Text(
              sumSpecialVotes.toString(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: menuButtonColor),
            ),
        ],
      ),
      onSelected: (String value) async {
        switch (value) {
          case "impactNom":
            onPressed(voteModel: itemData.impactVoteModel);
            break;
          case "inspiringNom":
            UIUtils.showSnackBar("Not yet implemented", context);
            break;
          case "wellWritten":
            UIUtils.showSnackBar("Not yet implemented", context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
            value: "impactNom",
            child: ListTile(
              horizontalTitleGap: 0,
              leading: Icon(Icons.whatshot, color: userVotedImpact ? kColorPrimary : Colors.black),
              trailing: Text(itemData.impactVoteModel.numberOfRatings.toString(),
                  style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: userVotedImpact ? kColorPrimary : Colors.black)),
              title: Text(
                'High Impact',
                style: TextStyle(color: userVotedImpact ? kColorPrimary : Colors.black),),
            )),
        PopupMenuItem<String>(
          value: "inspiringNom",
          child: ListTile(
            horizontalTitleGap: 0,
            leading: FaIcon(FontAwesomeIcons.grinStars, color: Colors.black),
            title: const Text('Inspiring'),
            trailing: Text('0',
                style:
                TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ),
        PopupMenuItem<String>(
          value: "wellWritten",
          child: ListTile(
            horizontalTitleGap: 0,
            leading: FaIcon(FontAwesomeIcons.featherAlt , color: Colors.black),
            title: const Text('Well written'),
            trailing: Text('0',
                style:
                TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
