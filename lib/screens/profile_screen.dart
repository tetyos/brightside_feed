import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexth/model/model_manager.dart';

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
              Text("Hi, " + mail + "", style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Text("This is a construction site.", style: TextStyle(color: Colors.black87, fontSize: 20)),
              SizedBox(height: 20),
              Image.asset("images/russian_miner.gif"),
              SizedBox(height: 20),
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
