import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/components/CustomAppBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebViewPage extends StatefulWidget {
  
  final String _url;
  NewsWebViewPage({url = ""}): this._url = url;

  @override
  _NewsWebViewPage createState() => _NewsWebViewPage();

}


class _NewsWebViewPage extends State<NewsWebViewPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "News Viewing",),
      body: WebView(
        initialUrl: widget._url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}