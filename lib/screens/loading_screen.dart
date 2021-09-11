import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspired/components/preview_data_loader.dart';
import 'package:inspired/screens/item_view_screen.dart';
import 'package:inspired/testdata/basic_test_urls.dart';



class LoadingScreen extends StatefulWidget {
  static const String id = 'loading_screen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  void getInitialData() async {
    List<Future<LinkPreviewData>> futures = [];
    for (int i = 0; i < 2; i++) {
    futures.add(PreviewDataLoader.fetchDataFromUrl(BasicTestUrls.testURLs.elementAt(i)));
    }
    List<LinkPreviewData> initialData = await Future.wait(futures);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ItemViewScreen(initialData: initialData);
    }));
  }

  @override
  void initState() {
    super.initState();
    print("Initialising state");
    getInitialData();
    print("Initialising state finished.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Center(
          child: SpinKitCubeGrid(
            color: Colors.blueAccent,
            size: 100.0,
          ),
        )
    );
  }
}
