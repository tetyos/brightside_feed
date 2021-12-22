import 'package:flutter/material.dart';
import 'package:nexth/utils/constants.dart';

class IntroCard extends StatelessWidget {
  final String title;
  final String message;

  const IntroCard({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          color: kColorPrimaryLight,
        ),
      ),
    );
  }
}