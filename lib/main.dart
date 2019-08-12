import 'package:flutter/material.dart';
import 'res/theme.dart' as CustomTheme;
import 'pages/BasePage.dart';
import 'pages/ArticlesViewPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashVocab',
      theme: CustomTheme.customThemeData,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the HomeScreen
        '/': (context) => BasePage(title: "Base"),
        '/articles': (context) => ArticlesViewPage(title: "Article"),
      },
    );
  }
}