import 'package:flutter/material.dart';
import 'res/theme.dart' as CustomTheme;
import 'pages/HomePage.dart';
import 'pages/ArticlesViewPage.dart';
import 'pages/SettingsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
    MaterialApp(
      title: 'FlashVocab',
      theme: CustomTheme.customThemeData,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the HomeScreen
        '/': (context) => HomePage(title: "HOME"),
        '/articles': (context) => ArticleViewPage(title: "Article"),
        '/settings': (context) => SettingsPage(),
      },     
    );
  }
}
