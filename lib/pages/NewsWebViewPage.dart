import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NewsWebViewPage extends StatefulWidget {
  
  final String _url;
  NewsWebViewPage({url = ""}): this._url = url;

  @override
  _NewsWebViewPage createState() => _NewsWebViewPage();

}


class _NewsWebViewPage extends State<NewsWebViewPage> {
  
  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
          url: widget._url,
          appBar: new AppBar(
            title: new Text("Articles Widget"),
          ),
    );
  }
}