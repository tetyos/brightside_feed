import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:brightside_feed/utils/constants.dart';

class LoadingScreen2 extends StatelessWidget {
  static const String id = 'loading_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Center(
          child: SpinKitCubeGrid(
            color: kColorPrimary,
            size: 100.0,
          ),
        )
    );
  }
}
