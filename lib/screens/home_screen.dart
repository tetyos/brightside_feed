import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexth/components/item_list_scroll_view.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  HomeScreen({required Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemListScrollView(
        itemListModel: ModelManager.instance.homeModel,
        appBar: sliverAppBar(),
        introCard: welcomeSliver());
  }

  Widget sliverAppBar() {
    return SliverAppBar(
      title: Text('Recently added'),
      floating: true,
      // expandedHeight: 200.0,
      // TODO: Add a FlexibleSpaceBar
    );
  }

  Widget welcomeSliver() {
    return SliverToBoxAdapter(
      child: const WelcomeCard(),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  const WelcomeCard();

  @override
  Widget build(BuildContext context) {
    bool isFirstLogin = Provider.of<AppState>(context, listen: false).isFirstLogin;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                Text(
                  isFirstLogin? "Welcome, my friend!" : "Welcome back!",
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "Pacifico",
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Scroll down, to catch up on the cool stuff happening around the world.",
                  // "Scroll down, to catch up on the good things fellow human beings have done since your last login.",
                  style: TextStyle(color: Colors.black87), textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          color: kColorPrimaryLight,
        ),
      ),
    );
  }
}