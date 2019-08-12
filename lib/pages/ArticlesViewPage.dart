import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;
import '../components/CustomAppBar.dart';

class ArticlesViewPage extends StatefulWidget {
  ArticlesViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ArticlesViewPageState createState() => _ArticlesViewPageState();
}

class _ArticlesViewPageState extends State<ArticlesViewPage> {
  // out the widget's state here

  @override
  Widget build(BuildContext context) {
    //TODO: implement
    return Center(
      child: Text("ArticleViewPage"),
    );
  }
}