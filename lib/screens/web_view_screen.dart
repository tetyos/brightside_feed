import 'package:flutter/material.dart';
import 'package:brightside_feed/backend_connection/api_connector.dart';
import 'package:brightside_feed/components/more_menu.dart';
import 'package:brightside_feed/components/special_vote_button.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/model/vote_model.dart';
import 'package:brightside_feed/navigation/app_state.dart';
import 'package:brightside_feed/utils/constants.dart';
import 'package:brightside_feed/utils/ui_utils.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late ItemData itemData;
  late WebViewController webViewController;

  /// vote-requests can only be sent one after another to backend.
  /// if two request would reach backend roughly at the same time, it can trigger a bug.
  /// the second vote-request can override the first one (since both read 'no votes so far' and both insert a new one.
  /// change to backend would be complicated -> so easy solution for -> wait for first request to finish.
  bool isVoteProcessing = false;

  bool isWebViewOnItem = true;
  bool isLoadingTimeUp = false;

  @override
  void initState() {
    super.initState();
    itemData = Provider.of<AppState>(context, listen: false).currentWebViewItem!;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          body: WebView(
            initialUrl: itemData.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (url) {
              // workaround to detect if the user changed the website of the WebView. if he did, voting is to be disabled.
              // since some websites slightly change their url automatically when they load, we wait for a certain amount of time to pass first.
              // after that its likely that the user did a manual change to WebView.
              if (isLoadingTimeUp) {
                setState(() {
                  isWebViewOnItem = url == itemData.url;
                });
              }
            },
            onPageFinished: (url) {
              // Future.delayed(Duration(milliseconds: 10)).then((value) =>
              //     webViewController.runJavascript(
              //         "document.getElementsByTagName('header')[0].style.display='None'"));
              // webViewController
              //     .runJavascript("javascript:(function() { " +
              //         "var head = document.getElementsByTagName('header')[0];" +
              //         "head.parentNode.removeChild(head);" +
              //         "var footer = document.getElementsByTagName('footer')[0];" +
              //         "footer.parentNode.removeChild(footer);" +
              //         "})()")
              //     .then((value) => debugPrint('Page finished loading Javascript'))
              //     .catchError((onError) => debugPrint('$onError'));
            },
            onWebViewCreated: (controller) {
              print("---------------Webview created --------------");
              print(isLoadingTimeUp);
              Future.delayed(Duration(milliseconds: 1500)).then((value) {
                isLoadingTimeUp = true;
                print("---------------loading time up --------------");
              });
              webViewController = controller;
            },
            gestureNavigationEnabled: true,
          ),
          bottomNavigationBar: BottomAppBar(
            color: kColorPrimary,
            shape: CircularNotchedRectangle(),
            notchMargin: 5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () {
                  appState.currentWebViewItem = null;
                },),
                renderUpVoteButton(),
                renderAwardMenu(),
                MoreMenu(itemData: itemData),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget renderUpVoteButton() {
    if (!isWebViewOnItem) {
      return renderExternalContentButton(Icons.thumb_up_alt_outlined);
    }
    return IconButton(
      icon: Icon(Icons.thumb_up_alt_outlined,
          color: itemData.upVoteModel.voted ? kColorOrange : Colors.white),
      onPressed: () => onVoteCallback(voteModel: itemData.upVoteModel),
    );
  }

  Widget renderAwardMenu() {
    if (!isWebViewOnItem) {
      return renderExternalContentButton(Icons.emoji_events);
    }
    return SpecialVoteButton(
      itemData: itemData,
      onPressed: onVoteCallback,
      noVoteColor: Colors.white,
      hasVotesColor: Colors.white,
      userVotedColor: kColorOrange,
    );
  }

  Widget renderExternalContentButton(IconData iconData) {
    return IconButton(
      icon: Icon(iconData, color: kColorWhiteTransparent),
      onPressed: () {
        UIUtils.showSnackBar("Voting not possible after changing websites. Go back to main screen to vote on item.", context);
        return;
      },
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
          UIUtils.showSnackBar(
              "Vote could not be processed. Check internet connection and retry.", context);
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
