library simple_url_preview;

import 'package:flutter/material.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:inspired/simple_url_preview/preview_description.dart';
import 'package:inspired/simple_url_preview/preview_image.dart';
import 'package:inspired/simple_url_preview/preview_site_name.dart';
import 'package:inspired/simple_url_preview/preview_title.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

/// Provides URL preview
class SimpleUrlPreview extends StatefulWidget {
  /// URL for which preview is to be shown
  final String url;

  /// Height of the preview
  final double previewHeight;

  /// Whether or not to show close button for the preview
  final bool isClosable;

  /// Background color
  final Color bgColor;

  /// Style of Title.
  final TextStyle titleStyle;

  /// Number of lines for Title. (Max possible lines = 2)
  final int titleLines;

  /// Style of Description
  final TextStyle descriptionStyle;

  /// Number of lines for Description. (Max possible lines = 3)
  final int descriptionLines;

  /// Style of site title
  final TextStyle siteNameStyle;

  /// Color for loader icon shown, till image loads
  final Color imageLoaderColor;

  /// Container padding
  final EdgeInsetsGeometry previewContainerPadding;

  /// onTap URL preview, by default opens URL in default browser
  final VoidCallback onTap;

  SimpleUrlPreview({
    @required this.url,
    this.previewHeight = 130.0,
    this.isClosable,
    this.bgColor,
    this.titleStyle,
    this.titleLines = 2,
    this.descriptionStyle,
    this.descriptionLines = 3,
    this.siteNameStyle,
    this.imageLoaderColor,
    this.previewContainerPadding,
    this.onTap,
  })  : assert(previewHeight >= 130.0,
  'The preview height should be greater than or equal to 130'),
        assert(titleLines <= 2 && titleLines > 0,
        'The title lines should be less than or equal to 2 and not equal to 0'),
        assert(descriptionLines <= 3 && descriptionLines > 0,
        'The description lines should be less than or equal to 3 and not equal to 0');

  @override
  _SimpleUrlPreviewState createState() => _SimpleUrlPreviewState();
}

class _SimpleUrlPreviewState extends State<SimpleUrlPreview> {
  Map _urlPreviewData;
  bool _isVisible = true;
  bool _isClosable;
  double _previewHeight;
  Color _bgColor;
  TextStyle _titleStyle;
  int _titleLines;
  TextStyle _descriptionStyle;
  int _descriptionLines;
  TextStyle _siteNameStyle;
  Color _imageLoaderColor;
  EdgeInsetsGeometry _previewContainerPadding;
  VoidCallback _onTap;

  @override
  void initState() {
    super.initState();
    _getUrlData();
  }

  @override
  void didUpdateWidget(SimpleUrlPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getUrlData();
  }

  void _initialize() {
    _previewHeight = widget.previewHeight;
    _descriptionStyle = widget.descriptionStyle;
    _descriptionLines = widget.descriptionLines;
    _titleStyle = widget.titleStyle;
    _titleLines = widget.titleLines;
    _siteNameStyle = widget.siteNameStyle;
    _previewContainerPadding = widget.previewContainerPadding;
    _onTap = widget.onTap ?? _launchURL;
  }

  void _getUrlData() async {
    if (!isURL(widget.url)) {
      setState(() {
        _urlPreviewData = null;
      });
      return;
    }

    final store = await CacheStore.getInstance();
    var response = await store.getFile(widget.url, flushCache: true).catchError((error) {
      return null;
    });
    // var response = await get(widget.url);

    if (response == null) {
      if (!this.mounted) {
        return;
      }
      setState(() {
        _urlPreviewData = null;
      });
      return;
    }

    // var document = parse(response.body);
    var document = parse(await response.readAsString());
    Map data = {};
    _extractOGData(document, data, 'og:title');
    _extractOGData(document, data, 'og:description');
    _extractOGData(document, data, 'og:site_name');
    _extractOGData(document, data, 'og:image');

    if (!this.mounted) {
      return;
    }

    if (data != null && data.isNotEmpty) {
      setState(() {
        _urlPreviewData = data;
        _isVisible = true;
      });
    }
  }

  void _extractOGData(Document document, Map data, String parameter) {
    // var titleMetaTag = document.getElementsByTagName("meta")?.firstWhere(
    //         (meta) => meta.attributes['property'] == parameter,
    //     orElse: () => null);
    // if (titleMetaTag != null) {
    //   data[parameter] = titleMetaTag.attributes['content'];
    // }
    final metaTags = document.getElementsByTagName("meta");
    if (metaTags == null) return;

    // we search for og tag regardless of the attribute name
    final metaTag = metaTags.firstWhere(
          (element) => element.attributes.containsValue(parameter),
      orElse: () => null,
    );

    if (metaTag == null) return;
    data[parameter] = metaTag.attributes['content'];
  }

  void _launchURL() async {
    if (await canLaunch(Uri.encodeFull(widget.url))) {
      await launch(Uri.encodeFull(widget.url));
    } else {
      throw 'Could not launch ${widget.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    _isClosable = widget.isClosable ?? false;
    _bgColor = widget.bgColor ?? Theme.of(context).primaryColor;
    _imageLoaderColor =
        widget.imageLoaderColor ?? Theme.of(context).accentColor;
    _initialize();

    if (_urlPreviewData == null || !_isVisible) {
      return SizedBox();
    }

    return Container(
      padding: _previewContainerPadding,
      height: _previewHeight,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _onTap,
            child: _buildPreviewCard(context),
          ),
          _buildClosablePreview(),
        ],
      ),
    );
  }

  Widget _buildClosablePreview() {
    return _isClosable
        ? Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          setState(() {
            _isVisible = false;
          });
        },
      ),
    )
        : SizedBox();
  }

  Card _buildPreviewCard(BuildContext context) {
    return Card(
      elevation: 5,
      color: _bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width -
                MediaQuery.of(context).padding.left -
                MediaQuery.of(context).padding.right) *
                0.25,
            child: PreviewImage(
              _urlPreviewData['og:image'],
              _imageLoaderColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PreviewTitle(
                      _urlPreviewData['og:title'],
                      _titleStyle == null
                          ? TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                      )
                          : _titleStyle,
                      _titleLines),
                  PreviewDescription(
                    _urlPreviewData['og:description'],
                    _descriptionStyle == null
                        ? TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    )
                        : _descriptionStyle,
                    _descriptionLines,
                  ),
                  PreviewSiteName(
                    _urlPreviewData['og:site_name'],
                    _siteNameStyle == null
                        ? TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    )
                        : _siteNameStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
