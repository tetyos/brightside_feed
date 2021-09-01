import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';

class ItemAnyLink extends StatelessWidget {

  final String url;

  ItemAnyLink({this.url});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: AnyLinkPreview(
        link: url,
        displayDirection: UIDirection.UIDirectionHorizontal,
        cache: Duration(hours: 1),
        backgroundColor: Colors.grey[300],
        errorWidget: Container(
          color: Colors.grey[300],
          child: Text('Oops!'),
        ),
      ),
    );
  }
}
