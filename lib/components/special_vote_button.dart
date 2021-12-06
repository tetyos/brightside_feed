import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/vote_model.dart';
import 'package:nexth/utils/constants.dart';

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
    VoteModel impactModel = itemData.impactVoteModel;
    VoteModel inspiringModel = itemData.inspiringVoteModel;
    VoteModel wellWrittenModel = itemData.wellWrittenVoteModel;

    int sumSpecialVotes = impactModel.numberOfRatings + inspiringModel.numberOfRatings + wellWrittenModel.numberOfRatings;
    bool hasVotes = sumSpecialVotes > 0;
    bool hasUserVoted = impactModel.voted || wellWrittenModel.voted || inspiringModel.voted;
    Color menuButtonColor = hasVotes
        ? hasUserVoted
            ? userVotedColor
            : hasVotesColor
        : noVoteColor;

    return PopupMenuButton<String>(
      child: Row(
        children: [
          if (!hasVotes) SizedBox(width: 3),
          FaIcon(FontAwesomeIcons.award, color: menuButtonColor),
          SizedBox(width: 2),
          if (hasVotes)
            Text(
              sumSpecialVotes.toString(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: menuButtonColor),
            ),
        ],
      ),
      onSelected: (String value) async {
        if (value == impactModel.identifier) {
          onPressed(voteModel: impactModel);
        } else if (value == inspiringModel.identifier) {
          onPressed(voteModel: inspiringModel);
        } else if (value == wellWrittenModel.identifier) {
          onPressed(voteModel: wellWrittenModel);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        renderPopupMenuItem(impactModel),
        renderPopupMenuItem(inspiringModel),
        renderPopupMenuItem(wellWrittenModel)
      ],
    );
  }

  PopupMenuItem<String> renderPopupMenuItem(VoteModel voteModel) {
    Color voteColor = voteModel.voted ? kColorPrimary : Colors.black;

    return PopupMenuItem<String>(
      value: voteModel.identifier,
      child: ListTile(
        dense: true,
        horizontalTitleGap: 0,
        leading: FaIcon(voteModel.iconData, color: voteColor),
        trailing: Text(
          voteModel.numberOfRatings.toString(),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: voteColor),
        ),
        title: Text(voteModel.displayText, style: TextStyle(color: voteColor)),
      ),
    );
  }
}
