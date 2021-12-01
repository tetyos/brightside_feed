import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nexth/backend_connection/api_connector.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/vote_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:nexth/utils/preview_data_loader.dart';
import 'package:nexth/utils/ui_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailScreen extends StatefulWidget {

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool _hasItem = true;
  late ItemData _itemData;
  late GestureDetector _imageWidget;
  late String _dateString;
  late String _host;

  /// vote-requests can only be sent one after another to backend.
  /// if two request would reach backend roughly at the same time, it can trigger a bug.
  /// the second vote-request can override the first one (since both read 'no votes so far' and both insert a new one.
  /// change to backend would be complicated -> so easy solution for -> wait for first request to finish.
  bool isVoteProcessing = false;


  @override
  void initState() {
    super.initState();

    ItemData? item = Provider.of<AppState>(context, listen: false).currentSelectedItem;
    if (item == null) {
      _hasItem = false;
      return;
    }

    _itemData = item;
    _dateString = PreviewDataLoader.getFormattedDateFromIso8601(_itemData.dateAdded);
    _host = PreviewDataLoader.getHostFromUrl(_itemData.url);

    Widget imageWidget = _itemData.imageProvider == null
        ? SpinKitCircle(color: Colors.blueAccent)
        : ClipRRect(
            child: Image(
              image: _itemData.imageProvider!,
            ),
            borderRadius: BorderRadius.circular(8),
          );
    _imageWidget = GestureDetector(
        onTap: launchUrl,
        child: imageWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasItem) {
      return Text("Glitch in the Matrix");
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          renderImage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_itemData.title, style: TextStyle(fontSize: 16),),
                if (_itemData.description != null) ...[
                  SizedBox(height: 5),
                  Text(
                    _itemData.description!,
                    style: TextStyle(color: Color(0x8a000000), fontSize: 14),
                  )
                ],
                SizedBox(height: 5),
                Text(_host, style: TextStyle(color: kColorPrimary, fontWeight: FontWeight.bold),),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Added on: " +  _dateString,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    if (_itemData.itemCategory != null) ...[
                      Text(_itemData.itemCategory!.displayTitle),
                      SizedBox(width: 2),
                      Icon(_itemData.itemCategory!.icon),
                    ],
                  ],
                ),
                renderDivider(),
                renderSocialIcons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void launchUrl() async {
    String url = _itemData.url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      try {
        await launch(url);
      } catch (err) {
        throw Exception('Could not launch $url. Error: $err');
      }
    }
  }

  Widget renderImage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Padding(
        child: _imageWidget,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  Widget renderDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(color: Colors.black),
    );
  }

  renderSocialIcons() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.remove_red_eye_outlined),
              SizedBox(width: 2),
              Text("4.505"),
            ],
          ),
        ),
        VoteButton(voteModel: _itemData.upVoteModel, onPressed: onVoteCallback,),
        SizedBox(width: 5),
        VoteButton(voteModel: _itemData.impactVoteModel, onPressed: onVoteCallback,),
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
    return TextButton(
      child: Row(
        children: [
          Icon(
            voteModel.iconData,
            color: voteModel.voted ? null : Colors.black,
          ),
          SizedBox(width: 2),
          Text(
            voteModel.numberOfRatings.toString(),
            style: voteModel.voted ? null : TextStyle(color: Colors.black),
          ),
        ],
      ),
      onPressed: () => onPressed(voteModel: voteModel),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

