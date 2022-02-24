import 'package:flutter/material.dart';
import 'package:nexth/utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  final TextStyle descriptionTextStyle = const TextStyle(color: Colors.black87, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome to the Brightside-Feed!",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                          constraints: BoxConstraints(maxWidth: 500),
                        child: Text(
                          "Here you will find news on events, tech and other things that help to advance our society into a brighter age.",
                          style: descriptionTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      Image.asset( 'images/intro4.png'),
                      SizedBox(height: 30),
                      Text("A brighter age?", style: TextStyle(color: Colors.black87, fontSize: 18)),
                      SizedBox(height: 10),
                      Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Text(
                          "The numerous challenges of today make it easy to overlook that we are also living in times that offer enormous possibilities for our future.",
                          style: descriptionTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Text(
                          "Goal of this project is to highlight the progress that our society makes everyday - a progress enabled by millions of people around the globe.",
                          style: descriptionTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 0,
                            maxWidth: 300,
                          ),
                          child: Card(
                            color: kColorSecondary,
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                            child: ListTile(
                              leading: Icon(
                                Icons.contact_mail,
                                color: Colors.white,
                              ),
                              title: SelectableText(
                                "renfilpe@googlemail.com",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                color: kColorPrimaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}