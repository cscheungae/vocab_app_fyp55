import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;
import '../components/CustomAppBar.dart';
import '../components/CustomBottomNavBar.dart';

class ArticleViewPage extends StatefulWidget {
  ArticleViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ArticleViewPageState createState() => _ArticleViewPageState();
}

class _ArticleViewPageState extends State<ArticleViewPage> {
  // out the widget's state here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "articles", iconData: Icons.person),
    );
  }
}