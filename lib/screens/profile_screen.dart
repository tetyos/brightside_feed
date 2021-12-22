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

class AdminAddonButtons extends StatefulWidget {
  const AdminAddonButtons({Key? key}) : super(key: key);

  @override
  _AdminAddonButtonsState createState() => _AdminAddonButtonsState();
}

class _AdminAddonButtonsState extends State<AdminAddonButtons> {
  bool isShowIntroSelected = false;
  bool isShowCategoryUpdaterSelected = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isShowIntroSelected = prefs.getBool(kLocalStorageAlwaysShowIntro) ?? false;
        isShowCategoryUpdaterSelected = prefs.getBool(kLocalStorageShowCategoryUpdater) ?? false;
      });
    });
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
}

