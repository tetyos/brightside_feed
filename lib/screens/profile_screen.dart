import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mail = ModelManager.instance.userModel!.email;
    return Center(
      child: Container(
        // color: kColorSecondaryDark,
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
                ToggleIntroButton(),
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

class ToggleIntroButton extends StatefulWidget {
  const ToggleIntroButton({Key? key}) : super(key: key);

  @override
  _ToggleIntroButtonState createState() => _ToggleIntroButtonState();
}

class _ToggleIntroButtonState extends State<ToggleIntroButton> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isSelected = prefs.getBool(kLocalStorageAlwaysShowIntro) ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Text("Always show intro: "),
        Switch(value: isSelected, onChanged: onChanged, activeColor: Theme.of(context).primaryColor),
      ],
    );
  }

  void onChanged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kLocalStorageAlwaysShowIntro, value);
    setState(() {
      isSelected = value;
    });
  }
}

