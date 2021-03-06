import 'package:flutter/material.dart';
import 'package:brightside_feed/backend_connection/api_connector.dart';
import 'package:brightside_feed/components/special_vote_button.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/model/vote_model.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/utils/constants.dart';
import 'package:brightside_feed/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class VoteButtons extends StatefulWidget {
  final ItemData itemData;

  VoteButtons({required this.itemData, Key? key}) : super(key: key);

  @override
  _VoteButtonsState createState() => _VoteButtonsState();
}

class _VoteButtonsState extends State<VoteButtons> {
  /// vote-requests can only be sent one after another to backend.
  /// if two request would reach backend roughly at the same time, it can trigger a bug.
  /// the second vote-request can override the first one (since both read 'no votes so far' and both insert a new one.
  /// change to backend would be complicated -> so easy solution for -> wait for first request to finish.
  bool isVoteProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoteButton(voteModel: widget.itemData.upVoteModel, onPressed: onVoteCallback,),
        SpecialVoteButton(itemData: widget.itemData, onPressed: onVoteCallback, noVoteColor: Colors.grey, hasVotesColor: Colors.black, userVotedColor: kColorPrimary,),
      ],
    );
  }

  void onVoteCallback({required VoteModel voteModel}) async {
    if (!Provider.of<AppState>(context, listen: false).isUserLoggedIn) {
      UIUtils.showSnackBar("Log in to be able to vote on items.", context);
      return;
    }
    if (!isVoteProcessing) {
      // instantly display the change to vote, even though not yet processed by backend.
      // -> lag free UI.
      bool isNewVote = !voteModel.voted;
      if (isNewVote) {
        voteModel.voted = true;
        voteModel.numberOfRatings++;
      } else {
        voteModel.voted = false;
        voteModel.numberOfRatings--;
      }
      setState(() {
        isVoteProcessing = true;
      });
      APIConnector.postVote(voteModel, isIncrease: isNewVote).then((voteSuccessful) {
        if (!voteSuccessful) {
          // in case something went wrong, turn back preliminary ui changes.
          if (isNewVote) {
            voteModel.voted = false;
            voteModel.numberOfRatings--;
          } else {
            voteModel.voted = true;
            voteModel.numberOfRatings++;
          }
          // todo maybe differentiate between different errors here? at least if backend give status codes?
          UIUtils.showSnackBar("Vote could not be processed. Check internet connection and retry.", context);
        }
        if (mounted) {
          setState(() {
            isVoteProcessing = false;
          });
        }
      });
    }
  }
}

class VoteButton extends StatelessWidget {
  final VoteModel voteModel;
  final void Function({required VoteModel voteModel}) onPressed;

  VoteButton({required this.voteModel, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool hasVotes = voteModel.numberOfRatings > 0;
    bool hasUserVoted = voteModel.voted;
    Color voteColor = hasVotes
        ? hasUserVoted
        ? kColorPrimary
        : Colors.black
        : Colors.grey;
    return GestureDetector(
      onTap: () => onPressed(voteModel: voteModel),
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        color: Colors.transparent,
        child: TextButton(
          child: Row(
            children: [
              SizedBox(width: 10),
              Icon(voteModel.iconData, color: voteColor),
              SizedBox(width: 2),
              if (hasVotes) Text(voteModel.numberOfRatings.toString(), style: TextStyle(color: voteColor)),
              if (!hasVotes) SizedBox(width: 2),
            ],
          ),
          onPressed: () => onPressed(voteModel: voteModel),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(30, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
    );
  }
}