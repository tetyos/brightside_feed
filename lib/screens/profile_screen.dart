import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mail = ModelManager.instance.userModel!.email;
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Hi, " + mail + "",
                  style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Text("This is a construction site.", style: TextStyle(color: Colors.black87, fontSize: 20)),
              SizedBox(height: 20),
              Image.asset("images/russian_miner.gif"),
              SizedBox(height: 20),
              UserSettings(),
              if (ModelManager.instance.isAdmin())
                AdminAddonButtons(),
              ElevatedButton(
                onPressed: () => ModelManager.instance.logout(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.logout, color: Colors.white), Text("Logout")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  bool isShowContentDescription = true;

  @override
  void initState() {
    super.initState();
    isShowContentDescription = Provider.of<AppState>(context, listen: false).isShowContentDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Show content description:"),
            Switch(value: isShowContentDescription, onChanged: toggleShowContentDescription, activeColor: Theme.of(context).primaryColor),
          ],
        ),
      ],
    );
  }

  void toggleShowContentDescription(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kLocalStorageShowContentDescription, value);
    Provider.of<AppState>(context, listen: false).isShowContentDescription = value;
    setState(() {
      isShowContentDescription = value;
    });
  }
}

class AdminAddonButtons extends StatefulWidget {
  const AdminAddonButtons({Key? key}) : super(key: key);

  @override
  _AdminAddonButtonsState createState() => _AdminAddonButtonsState();
}

class _AdminAddonButtonsState extends State<AdminAddonButtons> {
  bool isShowIntroSelected = false;
  bool isShowCategoryUpdaterSelected = false;
  bool isDefaultPreviewDataLoader = true;

  @override
  void initState() {
    super.initState();
    AppState appState  = Provider.of<AppState>(context, listen: false);
    isDefaultPreviewDataLoader = appState.isDefaultPreviewDataLoader;
    isShowIntroSelected = appState.isShowIntro;
    isShowCategoryUpdaterSelected = appState.isShowCategoryUpdater;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Always show intro: "),
            Switch(value: isShowIntroSelected, onChanged: isShowIntroChanged, activeColor: Theme.of(context).primaryColor),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Show category updater: "),
            Switch(
              value: isShowCategoryUpdaterSelected,
              onChanged: (value) => isShowCategoryUpdaterChanged(context, value),
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Use default preview data loader: "),
            Switch(
                value: isDefaultPreviewDataLoader,
                onChanged: (value) => isPreviewDataLoaderChanged(context, value),
                activeColor: Theme.of(context).primaryColor),
          ],
        ),
      ],
    );
  }

  void isShowIntroChanged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kLocalStorageAlwaysShowIntro, value);
    setState(() {
      isShowIntroSelected = value;
    });
  }

  void isShowCategoryUpdaterChanged(BuildContext context, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kLocalStorageShowCategoryUpdater, value);
    Provider.of<AppState>(context, listen: false).isShowCategoryUpdater = value;
    setState(() {
      isShowCategoryUpdaterSelected = value;
    });
  }

  void isPreviewDataLoaderChanged(BuildContext context, bool value) async {
    Provider.of<AppState>(context, listen: false).isDefaultPreviewDataLoader = value;
    setState(() {
      isDefaultPreviewDataLoader = value;
    });
  }
}

